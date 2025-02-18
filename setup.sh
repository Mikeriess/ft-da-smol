#!/bin/bash

# Check if Python 3.11 is installed
if ! command -v python3.11 &> /dev/null; then
    echo "Error: Python 3.11 is required but not installed"
    exit 1
fi

# Check if CUDA is available
if ! command -v nvcc &> /dev/null; then
    echo "Error: CUDA is required but not installed"
    exit 1
fi

# Create and activate virtual environment
echo "Creating virtual environment..."
python3.11 -m venv venv
source venv/bin/activate

# Install Axolotl with dependencies
echo "Installing Axolotl..."
pip3 install --upgrade pip
pip3 install --no-build-isolation axolotl[flash-attn,deepspeed]

# Fetch example configs
echo "Fetching example configs..."
axolotl fetch examples
axolotl fetch deepspeed_configs

echo "Setup complete! You can now:"
echo "1. Activate the environment: source venv/bin/activate"
echo "2. Start training: axolotl train configs/large.yml" 