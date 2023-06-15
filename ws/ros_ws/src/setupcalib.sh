#!/bin/bash

cd ../../../deps
mv ndt_omp ~/lidar_jay_ws/ros_ws/src

cd ~/lidar_jay_ws/ros_ws/src

# ndt_omp
wstool init
wstool merge lidar_IMU_calib/depend_pack.rosinstall
wstool update

# pangolin
cd lidar_IMU_calib
./build_submodules.sh

cd ../..
catkin_make
source devel/setup.bash
