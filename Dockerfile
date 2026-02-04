RUN apt-get update || true && \
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
 || true && \
    rm -rf /var/lib/apt/lists/*


RUN git lfs install

# Clone ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI

WORKDIR /workspace/ComfyUI

# Python deps
RUN pip install --upgrade pip setuptools wheel && \
    pip install -r requirements.txt

# Expose ComfyUI port
EXPOSE 8188

# Default start command (NO AUTO-START IN RUNPOD)
CMD ["bash"]
