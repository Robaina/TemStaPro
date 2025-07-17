# Use NVIDIA CUDA base image with Python 3.7
FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04

# Install system dependencies including Python 3.7
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    python3.7 \
    python3.7-dev \
    python3.7-distutils \
    python3-pip \
    git \
    make \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set python3.7 as default
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1

# Upgrade pip for python3.7
RUN python3.7 -m pip install --upgrade pip

# Set working directory
WORKDIR /app

# Copy TemStaPro repository code
COPY . /app

# Install exact PyTorch version matching conda approach
RUN pip install torch==1.13.1+cu117 torchvision==0.14.1+cu117 torchaudio==0.13.1 \
    --extra-index-url https://download.pytorch.org/whl/cu117

# Install other dependencies to match conda versions
RUN pip install \
    transformers==4.21.3 \
    sentencepiece==0.1.97 \
    matplotlib==3.5.3 \
    numpy

# Ensure the TemStaPro script has execute permission
RUN chmod +x /app/temstapro

# Test CUDA availability (following docs exactly)
RUN python -c "import torch; print('CUDA available:', torch.cuda.is_available())"

# Test the setup (following docs recommendation)
RUN make clean || true
RUN make all || (echo "First test run failed, trying again..." && make clean && make all)

# Copy and set up entrypoint script  
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]