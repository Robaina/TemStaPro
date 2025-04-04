# TemStaPro - classification of proteins based on thermostability

🚨 **Docker Image for GPU Predictions** 🚨

This fork of TemStaPro now provides a pre-configured Docker image to run predictions with GPU (CUDA) support. The Docker image is built on a CUDA-compatible base, ensuring efficient GPU-accelerated performance. Importantly, the image is kept lightweight by excluding the large protein model weights. Instead, you can supply the model weights at runtime via a mounted volume or environment variable, avoiding repeated downloads. Refer to the [Docker Usage](#docker-usage) section for build and run instructions.

## Hardware requirements

Any modern CPU can be used for calculations. Although, have 
in mind that average laptop CPU (e.g. Intel i7-8565U), 
will take ~60 times longer (~10 hours) to predict thermostability of 1000 sequences (average length of 
1137 residues, using `--portion-size 0`), 
compared to a GPU 
version of a program (~10 minutes)
running on a system with NVIDIA GeForce RTX 2080 Ti 
and Intel i9-9900K CPU.

Other hardware systems, which were used to successfully run the program:

- CPU: Intel Xeon Silver 4110 (2,10 GHz)
- GPU: NVIDIA A100 80GB PCIe

## Environment requirements

Before starting up Anaconda or Miniconda should be installed
in the system. Follow instructions given in 
[Conda's documentation.](https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html)

Setting up the environment can be done in one of the following ways.

### From YML file

In this repository two YML files can be found: one YML file
has the prerequisites for the environment that exploits only 
CPU ([`environment_CPU.yml`](./environment_CPU.yml)), another one to exploit both CPU 
GPU ([`environment_GPU.yml`](./environment_GPU.yml)).

This approach was tested with Conda 4.10.3 and 4.12.0 versions.

Run the following command to create the environment from a 
YML file:
