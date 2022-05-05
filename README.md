# orb-slam-16833
A ROS repository that performs ORB-SLAM2 on monocular camera and can account for motion blur. This repository is fully functional using Docker. This repository has two submodules in the ws folder. The first one is the [ORB-SLAM2](https://github.com/Prassi07/ORB_SLAM2) implementation that is slightly modified to account for dependency changes and callibration files for custom robots. The second is the [deblur package](https://github.com/Prassi07/orbslam-deblur-pkg) which sharpens an image if the motion of the robot is significant and causes motion blur. This repository is part of the 16833 Robot Localization and Mapping class at the Robotics Institute. 

-----------------------

The requirements for this are any version of `ROS1` on Linux, `docker` and `docker-compose`. To install this repository, please follow the commands below.

```console
git clone https://github.com/Prassi07/orb-slam-16833.git
cd orb-slam-16833
git submodule update --init --recursive
docker-compose build
```

This will take a significant amount of time as this will install 'Pangolin', 'openCV', and 'Eigen3' which is required by the ORB-SLAM2 package. After this is done, please do the following,

```console
export HOSTNAME=$HOSTNAME
docker-compose up
```

Once this is completed, the docker image will be running. Please press `Ctrl + C` to exit the container gracefully. Once this is completed, you can go inside the 
