# Use an NVIDIA CUDA base image with CUDA 11.7 and cuDNN 8 on Ubuntu 20.04
FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04

# Install system dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    git \
    make \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda (following TemStaPro recommendations)
RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh
ENV PATH="/opt/conda/bin:${PATH}"

# Set working directory
WORKDIR /app

# Copy TemStaPro repository code (copy before environment setup to use environment files if available)
COPY . /app

# Create conda environment - try using provided YML file first, fallback to manual setup
RUN if [ -f environment_GPU.yml ]; then \
    conda env create -f environment_GPU.yml; \
    else \
    conda create -n temstapro_env python=3.7 -y && \
    conda run -n temstapro_env conda install pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia -y && \
    conda run -n temstapro_env conda install -c conda-forge transformers -y && \
    conda run -n temstapro_env conda install -c conda-forge sentencepiece -y && \
    conda run -n temstapro_env conda install -c conda-forge matplotlib -y; \
    fi

# Ensure the TemStaPro script has execute permission
RUN chmod +x /app/temstapro

# Test CUDA availability in the environment
RUN conda run -n temstapro_env python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')" || true

# Test the setup (following docs recommendation) - may fail first time due to downloads
RUN conda run -n temstapro_env make clean || true
RUN conda run -n temstapro_env make all || (echo "First test run failed (likely due to downloads), trying again..." && conda run -n temstapro_env make clean && conda run -n temstapro_env make all)

# Copy and set up entrypoint script
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Set environment to automatically activate conda environment
ENV CONDA_DEFAULT_ENV=temstapro_env
ENV PATH="/opt/conda/envs/temstapro_env/bin:${PATH}"

ENTRYPOINT ["/app/entrypoint.sh"]