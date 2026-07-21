# PX4 ROS 2 Ubuntu 26 Fixes

This repository contains the workaround and setup scripts used to configure ROS 2 Humble for PX4 on Ubuntu 26.04 (Resolute).

## Problem
Ubuntu 26.04 ships with GCC 15 and Python 3.14. However, ROS 2 Humble strictly requires Ubuntu 22.04 dependencies like Python 3.10 and older standard libraries. Attempting to install it natively via `apt` breaks the system's dependencies.

## Fix
Instead of relying on `apt` or Docker, we utilize **RoboStack** and **Micromamba** to provision an isolated, native-feeling ROS 2 Humble environment directly in the user directory.

## Usage
Run `source setup_ros2_env.sh` to initialize the ROS 2 environment for your shell.
