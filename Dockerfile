FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility

WORKDIR /workspace

# -------------------------
# System dependencies
# -------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
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
        python3 \
        python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN git lfs install

# -------------------------
# Clone ComfyUI
# -------------------------
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI

WORKDIR /workspace/ComfyUI

# -------------------------
# Python dependencies
# -------------------------
RUN pip3 install --upgrade pip setuptools wheel && \
    pip3 install -r requirements.txt

# -------------------------
# Networking
# -------------------------
EXPOSE 8188

# -------------------------
# FINAL CUT:
# контейнер живёт всегда,
# Comfy запускается вручную
# -------------------------
CMD ["bash", "-c", "echo 'Container alive. Start ComfyUI manually.' && sleep infinity"]
