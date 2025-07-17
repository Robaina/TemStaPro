# TemStaPro Docker Usage Guide

## Building the Docker Image

```bash
# Clone the TemStaPro repository first
git clone https://github.com/ievapudz/TemStaPro.git
cd TemStaPro

# Copy the corrected Dockerfile and entrypoint.sh to the repository directory
# Then build the image
docker build -t temstapro .
```

## Preparing ProtTrans Models

You need to download the ProtTrans models separately. The documentation doesn't specify where to get them, but you'll need to mount this directory when running the container.

## Running the Container

### Basic Usage

```bash
# Run with ProtTrans models mounted from host
docker run --gpus all -v /host/path/to/ProtTrans:/models \
  -v /host/path/to/data:/data \
  temstapro /models -f /data/input.fasta --mean-output /data/output.tsv
```

### Using Environment Variable

```bash
# Set MODEL_DIR environment variable
docker run --gpus all -e MODEL_DIR=/models \
  -v /host/path/to/ProtTrans:/models \
  -v /host/path/to/data:/data \
  temstapro -f /data/input.fasta --mean-output /data/output.tsv
```

### Different Output Modes

```bash
# Per-residue predictions with plots
docker run --gpus all -v /host/path/to/ProtTrans:/models \
  -v /host/path/to/data:/data \
  temstapro /models -f /data/input.fasta \
  -p /data/ --per-res-output /data/output_per_res.tsv

# Per-segment predictions with smoothening
docker run --gpus all -v /host/path/to/ProtTrans:/models \
  -v /host/path/to/data:/data \
  temstapro /models -f /data/input.fasta \
  --curve-smoothening -p /data/ \
  --per-segment-output /data/output_segments.tsv
```

### With Embeddings Caching

```bash
# Cache embeddings for repeated runs
docker run --gpus all -v /host/path/to/ProtTrans:/models \
  -v /host/path/to/data:/data \
  -v /host/path/to/cache:/cache \
  temstapro /models -f /data/input.fasta \
  -e /cache/ --mean-output /data/output.tsv
```

## Important Notes

1. **GPU Support**: Use `--gpus all` to enable GPU acceleration
2. **Volume Mounts**: You need to mount:
   - ProtTrans models directory
   - Input/output data directory
   - Cache directory (if using `-e` option)
3. **Performance**: GPU version is ~60x faster than CPU-only
4. **File Paths**: All file paths inside the container should use the mounted paths

## Getting Help

```bash
# See all available options
docker run temstapro --help
```

## Troubleshooting

If you encounter issues:

1. **CUDA not available**: Ensure you have nvidia-docker installed and are using `--gpus all`
2. **Permission issues**: Make sure the mounted directories have appropriate permissions
3. **Memory issues**: Large protein sequences may require significant GPU memory