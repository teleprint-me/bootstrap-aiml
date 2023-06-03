#!/bin/bash
# scripts/setup_amd_pytorch.sh

echo "Updating system..."
sudo pacman -Syu || exit 1

echo "Installing necessary system packages..."
if sudo pacman -S base-devel git cmake python ninja python-pip python-yaml python-cffi python-setuptools python-wheel; then
    echo "System packages installed successfully."
else
    echo "System packages installation failed."
    exit 2
fi

echo "Installing ROCm packages..."
if sudo pacman -S rocm-dev rocm-libs rocm-utils rocm-profiler cxlactivitylogger miopengemm miopen-hip miopen-opencl rocblas hipcub rocrand rocthrust rocfft rocsolver rocprim rocr-debug-agent rocm-gdb rocm-smi-lib64; then
    echo "ROCm installed successfully."
else
    echo "ROCm installation failed."
    exit 3
fi

echo "Cloning PyTorch..."
if git clone --recursive https://github.com/pytorch/pytorch; then
    echo "PyTorch repository cloned successfully."
else
    echo "Failed to clone the PyTorch repository."
    exit 4
fi

echo "Changing into the PyTorch directory..."
cd pytorch

echo "Creating a Python virtual environment..."
if python -m virtualenv .env; then
    echo "Python virtual environment created successfully."
else
    echo "Failed to create the Python virtual environment."
    exit 5
fi

echo "Activating the virtual environment..."
if source .env/bin/activate; then
    echo "Virtual environment activated successfully."
else
    echo "Failed to activate the virtual environment."
    exit 6
fi

echo "Upgrading pip..."
if pip install --upgrade pip; then
    echo "Pip upgraded successfully."
else
    echo "Failed to upgrade pip."
    exit 7
fi

echo "Installing Python dependencies..."
if pip install numpy pyyaml mkl mkl-include setuptools cmake cffi typing_extensions future six requests dataclasses; then
    echo "Python dependencies installed successfully."
else
    echo "Failed to install Python dependencies."
    exit 8
fi

echo "Setting necessary environment variables..."
export PATH=/opt/rocm/bin:$PATH
export HIP_PLATFORM=hcc
export HCC_AMDGPU_TARGET=gfx900
export MAX_JOBS=16

echo "Building PyTorch..."
if python setup.py install; then
    echo "PyTorch build completed successfully."
else
    echo "PyTorch build failed."
    exit 9
fi

echo "Freezing Python dependencies to requirements.txt..."
pip freeze > requirements.txt

echo "Verifying the installation..."
python -c "import torch; print(torch.__version__)"

echo "Deactivating the virtual environment..."
deactivate

echo "Done."
exit 0
