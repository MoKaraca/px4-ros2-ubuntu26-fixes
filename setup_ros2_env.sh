#!/bin/bash
# Setup script for ROS 2 Humble using Micromamba on Ubuntu 26.04
# This script initializes the Micromamba environment and sources the ROS 2 setup.

export MAMBA_ROOT_PREFIX=~/micromamba
eval "$(~/.local/bin/micromamba shell hook -s bash)"
micromamba activate ros2_humble

if [ -f "$MAMBA_ROOT_PREFIX/envs/ros2_humble/setup.bash" ]; then
    source "$MAMBA_ROOT_PREFIX/envs/ros2_humble/setup.bash"
fi

# Alias colcon to automatically use the Conda python executable to avoid CMake errors
alias colcon="colcon build --cmake-args -DPython3_EXECUTABLE=\$(which python3) -DPython3_INCLUDE_DIR=\$CONDA_PREFIX/include/python3.12 -DPython_EXECUTABLE=\$(which python3) -DPython_INCLUDE_DIR=\$CONDA_PREFIX/include/python3.12"

echo "ROS 2 Humble (via Micromamba) activated successfully."
