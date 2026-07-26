#!/bin/bash
set -e

echo "=========================================================="
echo " PX4 & ROS 2 Humble Automated Setup for Ubuntu 26 (Resolute)"
echo "=========================================================="
echo "This script will completely provision an isolated ROS 2"
echo "environment to bypass Ubuntu 26's system library conflicts."

# 1. Prerequisites (git, wget, curl)
echo ">>> Checking prerequisites..."
if ! command -v curl &> /dev/null || ! command -v wget &> /dev/null || ! command -v git &> /dev/null; then
    echo "Basic tools missing. Attempting to install via apt..."
    sudo apt update && sudo apt install -y curl wget git
fi

# 2. Micromamba Installation
echo ">>> Installing Micromamba..."
export MAMBA_ROOT_PREFIX=~/micromamba
if [ ! -f ~/.local/bin/micromamba ]; then
    curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba -C ~/.local/
fi
eval "$(~/.local/bin/micromamba shell hook -s bash)"

# 3. Create Environment and Install Dependencies
echo ">>> Creating 'ros2_humble' environment..."
# Loop to retry downloading in case of network timeouts
until micromamba create -n ros2_humble -c robostack-staging -c conda-forge \
    ros-humble-desktop colcon-common-extensions compilers cmake ninja \
    gz-sim gz-sensors gz-plugin gz-transport libprotobuf openjdk \
    pyside6 qt6-webengine -y; do
    echo "Retrying micromamba install due to potential network timeout..."
    sleep 2
done

# Activate environment for the rest of the script
micromamba activate ros2_humble

echo ">>> Installing pip dependencies (YOLO/ultralytics)..."
pip install ultralytics

# 4. Clone and Build PX4
echo ">>> Setting up PX4-Autopilot..."
cd ~
if [ ! -d "PX4-Autopilot" ]; then
    git clone https://github.com/PX4/PX4-Autopilot.git --recursive
fi
cd ~/PX4-Autopilot
echo ">>> Building PX4 SITL Gazebo Simulator..."
make px4_sitl gz_advanced_plane

# 5. Clone and Build ROS 2 Workspace
echo ">>> Setting up ROS 2 Workspace (~/ros_ws)..."
mkdir -p ~/ros_ws/src
cd ~/ros_ws/src
if [ ! -d "px4_msgs" ]; then
    git clone https://github.com/PX4/px4_msgs.git
fi
if [ ! -d "px4_ros_com" ]; then
    git clone https://github.com/PX4/px4_ros_com.git
fi
cd ~/ros_ws
echo ">>> Building ROS Workspace..."
colcon build --cmake-args -DPython3_EXECUTABLE=$(which python3) -DPython3_INCLUDE_DIR=$CONDA_PREFIX/include/python3.12 -DPython_EXECUTABLE=$(which python3) -DPython_INCLUDE_DIR=$CONDA_PREFIX/include/python3.12

# 6. Download and Patch QGroundControl
echo ">>> Setting up QGroundControl..."
cd ~
if [ ! -f "QGroundControl-x86_64.AppImage" ]; then
    wget https://github.com/mavlink/qgroundcontrol/releases/download/Stable_V4.4.2/QGroundControl-x86_64.AppImage -O QGroundControl-x86_64.AppImage
    chmod +x QGroundControl-x86_64.AppImage
fi

echo ">>> Patching QGroundControl for Ubuntu 26..."
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -O appimagetool
chmod +x appimagetool
./QGroundControl-x86_64.AppImage --appimage-extract
rm -f squashfs-root/usr/plugins/platformthemes/libqgtk3.so
export ARCH=x86_64
./appimagetool squashfs-root QGroundControl-x86_64-fixed.AppImage
mv QGroundControl-x86_64-fixed.AppImage QGroundControl-x86_64.AppImage
chmod +x QGroundControl-x86_64.AppImage
rm -rf squashfs-root appimagetool

# 7. Setup bash alias
echo ">>> Setting up aliases..."
if ! grep -q 'alias px4_env="source ~/px4_fix/setup.sh"' ~/.bashrc; then
    echo 'alias px4_env="source ~/px4_fix/setup.sh"' >> ~/.bashrc
fi

echo "=========================================================="
echo " INSTALLATION COMPLETE!"
echo " Please restart your terminal or run: source ~/.bashrc"
echo " From now on, just type 'px4_env' to activate the environment."
echo "=========================================================="
