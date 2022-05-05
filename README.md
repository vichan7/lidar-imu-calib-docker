# orb-slam-16833
A ROS repository that performs ORB-SLAM2 on monocular camera and can account for motion blur. This repository is fully functional using Docker. This repository has two submodules in the ws folder. The first one is the [ORB-SLAM2](https://github.com/Prassi07/ORB_SLAM2) implementation that is slightly modified to account for dependency changes and callibration files for custom robots. The second is the [deblur package](https://github.com/Prassi07/orbslam-deblur-pkg) which sharpens an image if the motion of the robot is significant and causes motion blur. This repository is part of the 16833 Robot Localization and Mapping class at the Robotics Institute. The authors of this repository are @Prassi07, @Akshayaks and @winnkuang.

-----------------------
## Building the docker-image
The requirements for this are `ROS:melodic/noetic` on Linux, `docker` and `docker-compose`. To install this repository, please follow the commands below.

```console
git clone https://github.com/Prassi07/orb-slam-16833.git
cd orb-slam-16833
git submodule update --init --recursive
cd docker
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
This will build the ORB-SLAM2 package and the deblur package and get them ready to run.

--------------

## Running ORB-SLAM2

To run orb-slam with the deblurring on, run
```console
roslaunch deblur_pkg orb_slam.launch
```
ORB-SLAM2 requires a settings file for the camera. Check for the format in `ws/ORB_SLAM2/Examples/ROS/ORB_SLAM2/settings/`. The path for this file has to be set correctly in the orb_slam.launch file. The path is relative to the `ROS/ORB_SLAM2` directory.

The deblur package also has a number of parameters and the rostopics you can cofigure at `orbslam-deblur-pkg/config/config.yaml`. 

- The default input topic for the image has to be set to the param `image_in_topic`. 
- The output of the deblur-pkg is `image_out_topic`. The default of the out topic is `/camera/image_raw` which is the input the ORB_SLAM2 package. 
- You can enable or disable deblur using the `deblur` param. 
- You can add a patch on the bottom of image using the `crop_bottom` parameter (Useful for certain camera which have artifacts in the bottom part of the image. 
- The deblur threshold can be set `deblur_thresh` param. Higher the threshold, lower is the metric for the image to be considered blurred.
- You can also set rosrates using 'ros_rate' param and enable printing blur values using `debug` param

--------------------------

## Extra Information

- The docker images don't run on NVIDIA GPUs, ensure you're primary display manager is not NVIDIA. Set the GPU profile to either `on-demand` or `Intel` on nvidia-smi on ubuntu. The package will throw a X11 error otherwise.
- The ros-master is shared with the PC outside the docker. You can run any other package outside the container and send it to the ROS running inside the container.
