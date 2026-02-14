FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

WORKDIR /workspace

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

RUN python3 -m pip install --upgrade pip setuptools wheel

# Устанавливаем PyTorch под CUDA 12.1
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Клонируем ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git

WORKDIR /workspace/ComfyUI

RUN pip install -r requirements.txt

EXPOSE 8188

CMD ["python3", "main.py",]()
