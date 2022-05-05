# orb-slam-16833
A ROS repository that performs ORB-SLAM2 on monocular camera and can account for motion blur. This repository is fully functional using Docker. This repository has two submodules in the ws folder. The first one is the [ORB-SLAM2](https://github.com/Prassi07/ORB_SLAM2) implementation that is slightly modified to account for dependency changes and callibration files for custom robots. The second is the [deblur package](https://github.com/Prassi07/orbslam-deblur-pkg) which sharpens an image if the motion of the robot is significant and causes motion blur. This repository is part of the 16833 Robot Localization and Mapping class at the Robotics Institute. 

-----------------------
## Building the docker-image
The requirements for this are any version of `ROS1` on Linux, `docker` and `docker-compose`. To install this repository, please follow the commands below.

```console
git clone https://github.com/Prassi07/orb-slam-16833.git
cd orb-slam-16833
git submodule update --init --recursive
docker-compose build
```

This will take a significant amount of time as this will install 'Pangolin', 'openCV', and 'Eigen3' which is required by the ORB-SLAM2 package. This might throw warnings or some failures might occur. This is fine as long as image gets built. After this is done, please do the following,

```console
export HOSTNAME=$HOSTNAME
docker-compose up
```

Once this is completed, the docker image will be running. Please press `Ctrl + C` to exit the container gracefully. This completes the Docker container setup. We can now start the container and get a bash terminal by using the commands 
```console
docker start orb_slam_ros
docker exec -it orb_slam_ros bash
```
The later command can be used on different terminal to get more terminal access inside the container. Once you are inside the docker you'll see the shell say `developer@hostname$`.

---------------------
## Building the Packages
We need to build the code once for the first time. Once inside the docker container do,
```console
cd slam_ws/ORB_SLAM2
./build.sh
./build_ros.sh
cd ~/slam_ws/ros_ws/
catkin_make
source ~/.bashrc
```
This will build the ORBSLAM2 package and the deblur package and get them ready to run.

--------------

## Running ORB-SLAM2

To run orb-slam with the deblurring on, run
```console
roslaunch deblur_pkg orb_slam.launch
