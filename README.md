# lidar-imu-calib-docker
A ROS repository that performs Lidar-IMU calibration using a modified version of [APRIL Lab's lidar_IMU_calib](https://github.com/APRIL-ZJU/lidar_IMU_calib) repository. The outline of this repository is taken from [orb-slam-16833](https://github.com/Prassi07/orb-slam-16833) and [16833_superodom](https://github.com/JayMaier/16833_superodom/tree/vins-fusion). This repository contains the dockerfile that downloads dependencies needed for the modified lidar_IMU_calib repository and serves as a wrapper repository.

Made for the MMPUG project at the CMU Biorobotics Lab.

## Cloning Repositories
Clone this repository and the [modified lidar_IMU_calib repository](https://github.com/vichan7/lidar_IMU_calib) with the following commands.
```
git clone git@github.com:vichan7/lidar-imu-calib-docker.git
cd ws/ros_ws/src
git clone git@github.com:vichan7/lidar_IMU_calib.git
```
Also, make sure that docker is installed and accessible 

-----
## Building Docker Image and Container
Starting from the `lidar-imu-calib-docker` directory, build the docker image
```
cd docker
docker-compose build
```
Run the docker image with
```
export HOSTNAME=$HOSTNAME
docker-compose up
```
Once the environment setup is successful, press `Ctrl + C` to exit the container gracefully. Start and run the container.
```
docker start lidar_jay_ros
docker exec -it lidar_jay_ros bash
```
------

## Using lidar_IMU_calib
Once inside the docker container, run the setup script for calibration.
```
cd lidar_jay_ws/ros_ws/src
bash ./setupcalib.sh
```
Run the gui using the following command.
```
cd lidar_IMU_calib
./calib.sh
```



