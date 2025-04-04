# Use an NVIDIA CUDA base image with CUDA 11.7 and cuDNN 8 on Ubuntu 22.04 (which includes Python 3.10)
FROM nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu22.04

# Install Python 3 and pip
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip git && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy TemStaPro repository code into the container (assuming Docker build context has the repository files)
COPY . /app

# Install Python dependencies (PyTorch with CUDA support, Transformers, SentencePiece, Matplotlib, NumPy, etc.)
RUN pip3 install --no-cache-dir torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu117 && \
    pip3 install --no-cache-dir transformers sentencepiece matplotlib numpy

# Ensure the TemStaPro script has execute permission
RUN chmod +x /app/temstapro

# Copy the entrypoint script into the image and give execute permission
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Set the entrypoint for the container
ENTRYPOINT ["/app/entrypoint.sh"]
