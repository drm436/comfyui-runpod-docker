FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

WORKDIR /workspace

# -----------------------
# System packages
# -----------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    git-lfs \
    ffmpeg \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6 \
    wget \
    curl \
    ca-certificates \
    build-essential \
    python3.10 \
    python3.10-dev \
    python3.10-venv \
    python3-pip \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

RUN git lfs install

# -----------------------
# Create venv
# -----------------------
RUN python3.10 -m venv /workspace/wanenv
ENV PATH="/workspace/wanenv/bin:$PATH"

RUN pip install --upgrade pip setuptools wheel

# -----------------------
# Torch 2.4 CUDA 12.1 (фиксированная версия)
# -----------------------
RUN pip install torch==2.4.0+cu121 torchvision==0.19.0+cu121 torchaudio==2.4.0+cu121 \
    --index-url https://download.pytorch.org/whl/cu121

# -----------------------
# Clone repos
# -----------------------
RUN git clone https://github.com/comfyanonymous/ComfyUI.git
RUN git clone https://github.com/Wan-Video/Wan2.2.git

# -----------------------
# Wan dependencies (строго совместимые)
# -----------------------
RUN pip install \
    diffusers==0.36.0 \
    transformers==4.51.3 \
    accelerate==1.12.0 \
    huggingface-hub==0.36.2 \
    peft==0.18.1 \
    tokenizers==0.21.4 \
    easydict ftfy dashscope \
    imageio[ffmpeg] imageio-ffmpeg \
    opencv-python \
    decord librosa av soundfile \
    timm einops scipy omegaconf sentencepiece

# -----------------------
# FlashAttention 2
# -----------------------
ENV MAX_JOBS=2
ENV TORCH_CUDA_ARCH_LIST="8.6"

RUN pip install flash-attn --no-build-isolation

ENV LD_LIBRARY_PATH=/workspace/wanenv/lib/python3.10/site-packages/torch/lib:$LD_LIBRARY_PATH

# -----------------------
# ComfyUI deps
# -----------------------
WORKDIR /workspace/ComfyUI
RUN pip install -r requirements.txt
RUN pip install sqlalchemy alembic torchsde torchaudio kornia spandrel

# -----------------------
# Port
# -----------------------
EXPOSE 8188

# -----------------------
# Start Comfy
# -----------------------
CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
