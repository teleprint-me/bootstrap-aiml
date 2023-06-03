#!/bin/bash

# Exit on any error
set -e

# Update system
sudo pacman -Syu

# Install dependencies
sudo pacman -S base-devel cmake python python-pip rocm-dkms

# Clone PyTorch
git clone --recursive https://github.com/pytorch/pytorch

# Change to the PyTorch directory
cd pytorch

# Create a Python virtual environment
python -m venv .env

# Activate the virtual environment
source .env/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install Python dependencies
pip install numpy pyyaml mkl mkl-include cffi typing_extensions future six requests dataclasses

# Set environment variables
export CMAKE_PREFIX_PATH=$(dirname $(which python))/../
export USE_ROCM=1

# Build PyTorch
python setup.py install

# Test PyTorch
python -c "import torch; print(torch.__version__)"
