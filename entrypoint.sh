#!/usr/bin/env bash
set -e

# Accept the ProtTrans model directory via an environment variable or first argument
MODEL_PATH="${MODEL_DIR:-$1}"

# Shift off the first argument if it was used for model path
if [ "$1" == "$MODEL_PATH" ]; then
    shift
fi

# Check that model path is provided
if [ -z "$MODEL_PATH" ]; then
    echo "Error: No ProtTrans model directory specified."
    echo "Please set the MODEL_DIR environment variable or provide the model path as the first argument."
    exit 1
fi

# Run the TemStaPro prediction script with the provided model path and any additional arguments
# --PT-directory tells TemStaPro where to find the ProtTrans model weights
exec python3 /app/temstapro --PT-directory "$MODEL_PATH" "$@"
