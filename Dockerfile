FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV TORCH_CUDA_ARCH_LIST=8.6
ENV MAX_JOBS=4

WORKDIR /workspace

# -------------------------
# System dependencies
# -------------------------
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
    python3 \
    python3-dev \
    python3-pip \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

RUN git lfs install

# -------------------------
# Python base tools
# -------------------------
RUN pip3 install --upgrade pip setuptools wheel

# -------------------------
# PyTorch (CUDA 12.1)
# -------------------------
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# -------------------------
# Flash Attention
# -------------------------
RUN pip3 install flash-attn --no-build-isolation

# -------------------------
# Clone ComfyUI
# -------------------------
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI

WORKDIR /workspace/ComfyUI

RUN pip3 install -r requirements.txt

EXPOSE 8188

CMD ["sleep", "infinity"]

# rebuild trigger
