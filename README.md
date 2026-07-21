# PX4 ROS 2 Ubuntu 26 Fixes

This repository contains the workaround and setup scripts used to configure ROS 2 Humble for PX4 on Ubuntu 26.04 (Resolute).

## The Problem
Ubuntu 26.04 ships with GCC 15 and Python 3.14. However, ROS 2 Humble strictly requires Ubuntu 22.04 dependencies like Python 3.10 and older standard libraries. Attempting to install it natively via `apt` breaks the system's dependencies. Additionally, the QGroundControl AppImage natively crashes (segmentation fault) on Ubuntu 26 due to library conflicts.

## The Fix
Instead of relying on `apt` or Docker, we utilize **RoboStack** and **Micromamba** to provision an isolated, native-feeling ROS 2 Humble environment directly in the user directory.

---

## 1. Automated Installation (For Fresh Installs)
If you are setting up a completely fresh Ubuntu 26 system, simply open a terminal and run the following commands to bootstrap the entire environment:

```bash
# 1. Clone this repository
git clone https://github.com/MoKaraca/PX4-Ubuntu-26.04-Enviroment.git px4_fix

# 2. Enter the directory and make the script executable
cd px4_fix
chmod +x install.sh

# 3. Run the automated installer
./install.sh
```

**What the installer does automatically:**
- Installs the Micromamba package manager.
- Creates the `ros2_humble` environment with all dependencies (including ROS 2, Gazebo `gz-sim`, Protobuf, Java, etc.).
- Clones the `PX4-Autopilot` repository and compiles the SITL firmware.
- Clones your `px4_msgs` and `px4_ros_com` into `~/ros_ws` and compiles them.
- Downloads the QGroundControl AppImage and **automatically patches it** to prevent the segmentation fault.
- Adds the `px4_env` shortcut to your `~/.bashrc`.

---

## 2. Daily Usage Instructions

### Activating the Environment
Because everything is safely containerized inside Micromamba, your terminal does not have access to ROS 2 by default.
**Every time you open a new terminal**, you must type:
```bash
px4_env
```

### Launching the PX4 Gazebo Simulator
The PX4 build command is also the launch command. Once your environment is activated, simply run:
```bash
cd ~/PX4-Autopilot
make px4_sitl gz_advanced_plane
```
*(Note: It only "builds" the first time. On subsequent runs, it will instantly verify the build and launch the simulator).*

### Compiling your ROS 2 Workspace
Whenever you make changes to your custom ROS 2 packages, compile them from within the activated environment:
```bash
cd ~/ros_ws
colcon build
```

### Launching QGroundControl
The installer places the patched AppImage directly in your home folder. You can launch it by double-clicking it, or via terminal:
```bash
cd ~
./QGroundControl-x86_64.AppImage
```
