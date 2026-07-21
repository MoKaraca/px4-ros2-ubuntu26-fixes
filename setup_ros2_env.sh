#!/bin/bash
# Setup script for ROS 2 Humble using Micromamba on Ubuntu 26.04
# This script initializes the Micromamba environment and sources the ROS 2 setup.

export MAMBA_ROOT_PREFIX=~/micromamba
eval "$(~/.local/bin/micromamba shell hook -s bash)"
micromamba activate ros2_humble

if [ -f "$MAMBA_ROOT_PREFIX/envs/ros2_humble/setup.bash" ]; then
    source "$MAMBA_ROOT_PREFIX/envs/ros2_humble/setup.bash"
fi

echo "ROS 2 Humble (via Micromamba) activated successfully."
