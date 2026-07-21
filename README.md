# PX4 ROS 2 Ubuntu 26 Fixes

This repository contains the workaround and setup scripts used to configure ROS 2 Humble for PX4 on Ubuntu 26.04 (Resolute).

## Problem
Ubuntu 26.04 ships with GCC 15 and Python 3.14. However, ROS 2 Humble strictly requires Ubuntu 22.04 dependencies like Python 3.10 and older standard libraries. Attempting to install it natively via `apt` breaks the system's dependencies.

## Fix
Instead of relying on `apt` or Docker, we utilize **RoboStack** and **Micromamba** to provision an isolated, native-feeling ROS 2 Humble environment directly in the user directory.

## Usage
Run `source setup.sh` to initialize the ROS 2 environment for your shell.

**Building PX4 SITL with Gazebo:**
Because Ubuntu 26 natively lacks the exact Gazebo simulation dependencies required by PX4, this conda environment also packs `gz-sim`, `gz-sensors`, `Protobuf` and other Gazebo components. 
You must run your `make px4_sitl gz_advanced_plane` commands **from within this activated environment** so CMake can find the dependencies!
