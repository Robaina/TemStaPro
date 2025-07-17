#!/bin/bash
set -e

# Activate conda environment
source /opt/conda/etc/profile.d/conda.sh
conda activate temstapro_env

# Handle special case: if first argument is --help, just pass it through
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    exec /app/temstapro --help
fi

# Accept the ProtTrans model directory via environment variable or first argument
MODEL_PATH="${MODEL_DIR:-$1}"

# Shift off the first argument if it was used for model path
if [ "$1" == "$MODEL_PATH" ] && [ -n "$MODEL_PATH" ]; then
    shift
fi

# Check that model path is provided
if [ -z "$MODEL_PATH" ]; then
    echo "Error: No ProtTrans model directory specified."
    echo "Please set the MODEL_DIR environment variable or provide the model path as the first argument."
    echo ""
    echo "Usage examples:"
    echo "  docker run --gpus all -v /host/ProtTrans:/models -v /host/data:/data temstapro /models -f /data/input.fasta --mean-output /data/output.tsv"
    echo "  docker run --gpus all -e MODEL_DIR=/models -v /host/ProtTrans:/models -v /host/data:/data temstapro -f /data/input.fasta --mean-output /data/output.tsv"
    echo ""
    echo "To see all options:"
    echo "  docker run temstapro --help"
    exit 1
fi

# Verify CUDA is available (optional check)
echo "Checking CUDA availability..."
python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}'); print(f'CUDA devices: {torch.cuda.device_count()}')" || echo "Warning: Could not check CUDA status"

# Run the TemStaPro prediction script with the correct parameter name
# Using -d for ProtTrans directory as shown in the documentation
# Note: TemStaPro is executed as ./temstapro, not as a Python script
exec /app/temstapro -d "$MODEL_PATH" "$@"