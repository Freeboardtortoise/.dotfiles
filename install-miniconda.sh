#!/bin/bash

# Exit on errors
set -e

# Define Miniconda installer URL
INSTALLER_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
INSTALLER_PATH="$HOME/miniconda_installer.sh"

# Check if Conda is already installed
if command -v conda &> /dev/null; then
    echo "[INFO] Conda is already installed. Skipping installation."
else
    echo "[INFO] Downloading Miniconda installer..."
    wget "$INSTALLER_URL" -O "$INSTALLER_PATH"
    
    echo "[INFO] Running Miniconda installer..."
    bash "$INSTALLER_PATH" -b -p "$HOME/miniconda"
    rm "$INSTALLER_PATH"

    echo "[INFO] Initializing Conda..."
    "$HOME/miniconda/bin/conda" init
fi

# Load Conda environment
export PATH="$HOME/miniconda/bin:$PATH"
source "$HOME/.bashrc"

# Verify installation
if ! command -v conda &> /dev/null; then
    echo "[ERROR] Conda installation failed. Exiting." >&2
    exit 1
fi

# Fix common issues
echo "[INFO] Checking for common Conda issues..."
if [ ! -d "$HOME/miniconda" ]; then
    echo "[ERROR] Miniconda directory not found!" >&2
    exit 1
fi

if ! grep -q "conda initialize" "$HOME/.bashrc"; then
    echo "[WARNING] Conda initialization missing in .bashrc. Adding it manually."
    echo "source $HOME/miniconda/bin/activate" >> "$HOME/.bashrc"
fi

# Update Conda and install basic packages
echo "[INFO] Updating Conda..."
conda update -n base -c defaults conda -y

# Install NVIDIA drivers and CUDA
echo "[INFO] Installing NVIDIA drivers and CUDA..."
sudo pacman -Sy --noconfirm nvidia nvidia-utils nvidia-dkms cuda cuda-tools

# Load NVIDIA modules
sudo modprobe nvidia

# Verify NVIDIA installation
echo "[INFO] Checking NVIDIA installation..."
nvidia-smi || { echo "[ERROR] NVIDIA-SMI failed! Check drivers."; exit 1; }

# Check for common NVIDIA issues
echo "[INFO] Checking for NVIDIA module issues..."
if ! lsmod | grep -q nvidia; then
    echo "[ERROR] NVIDIA module is not loaded. Trying to fix..."
    sudo modprobe nvidia || { echo "[ERROR] Unable to load NVIDIA module. Try rebooting."; exit 1; }
fi

if ! command -v nvcc &> /dev/null; then
    echo "[ERROR] CUDA is not installed properly. Try reinstalling CUDA."
    exit 1
fi

# Install CuPy
