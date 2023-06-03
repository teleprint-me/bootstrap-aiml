#!/bin/bash

# Exit if any commands return a non-zero exit code
set -e

# Create a virtual environment
python3 -m virtualenv .venv

# Activate the virtual environment
source .venv/bin/activate || exit 1

# Upgrade pip
pip install --upgrade pip

# Install PyTorch with ROCm support
pip install --upgrade torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.4.2

# Install other dependencies
pip install --upgrade python-dateutil python-dotenv pytz iso8601 requests numpy matplotlib sentencepiece nltk transformers sentence-transformers tiktoken chromadb pytorch-triton-rocm langchain pdfminer-six huggingface-hub

# Install bitsandbytes from git
pip install --upgrade git+https://github.com/broncotc/bitsandbytes-rocm@1b52f4243f94cd1b81dd1cad5a9465d9d7add858

# Install dev dependencies
pip install --upgrade bpython black flake8 flake8-black mkdocs pytest requests-mock isort

# Freeze the environment
pip freeze > requirements.txt

echo "Done"
exit 0
