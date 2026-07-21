# PX4 ROS 2 Ubuntu 26 Fixes

This repository contains the workaround and setup scripts used to configure ROS 2 Humble for PX4 on Ubuntu 26.04 (Resolute).

## Problem
Ubuntu 26.04 ships with GCC 15 and Python 3.14. However, ROS 2 Humble strictly requires Ubuntu 22.04 dependencies like Python 3.10 and older standard libraries. Attempting to install it natively via `apt` breaks the system's dependencies.

## Fix
Instead of relying on `apt` or Docker, we utilize **RoboStack** and **Micromamba** to provision an isolated, native-feeling ROS 2 Humble environment directly in the user directory.

## Automated Installation (For Fresh Installs)
If you are running a fresh Ubuntu 26 system, simply clone this repository and run the installation script. This script will automatically download Micromamba, create an isolated ROS 2 environment, download PX4, compile the firmware and ROS workspaces, and automatically patch the QGroundControl AppImage to prevent segmentation faults.

```bash
cd px4_fix
chmod +x install.sh
./install.sh
```

## Daily Usage
Once installed, you must activate the environment in every new terminal before running PX4 or ROS commands:
```bash
px4_env
```
*(This uses the alias automatically added to your `~/.bashrc` during installation).*
