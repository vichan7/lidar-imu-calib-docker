# lidar-imu-calib-docker
A ROS repository that performs Lidar-IMU calibration using a modified version of [APRIL Lab's lidar_IMU_calib](https://github.com/APRIL-ZJU/lidar_IMU_calib) repository. The outline of this repository is taken from [orb-slam-16833](https://github.com/Prassi07/orb-slam-16833) and [16833_superodom](https://github.com/JayMaier/16833_superodom/tree/vins-fusion). This repository contains the Dockerfile that downloads dependencies needed for the modified [lidar_IMU_calib](https://github.com/vichan7/lidar_IMU_calib) repository and serves as a wrapper repository.

Made for the MMPUG project at the CMU Biorobotics Lab. Tested only with Ubuntu. If your device has an Nvidia GPU, see the [nvidia-gpu branch](https://github.com/vichan7/lidar-imu-calib-docker/tree/nvidia-gpu).

## Prerequesites 
[Docker](https://www.docker.com/)

## Cloning Repositories
Clone this repository and our modified [lidar_IMU_calib](https://github.com/vichan7/lidar_IMU_calib) repository with the following commands.
```
git clone git@github.com:vichan7/lidar-imu-calib-docker.git
cd lidar-imu-calib-docker/ws/ros_ws/src
git clone git@github.com:vichan7/lidar_IMU_calib.git
```

## Building Docker Image and Container
Starting from the `lidar-imu-calib-docker` directory, build the docker image.
```
cd docker
docker compose build
```
Run the docker image with
```
export HOSTNAME=$HOSTNAME
docker compose up
```
Once the environment setup is successful, press `Ctrl C` to exit the container gracefully. Start and run the container.
```
docker start lidar_jay_ros
docker exec -it lidar_jay_ros bash
```


## Running lidar_IMU_calib
Once inside the docker container, run the setup script for calibration.
```
cd lidar_jay_ws/ros_ws/src
bash ./setupcalib.sh
```
Run the GUI using the following command. Note the topic names in `calib.sh` and `licalib_gui.launch` are formatted to work with bags that MMPUG produces, and may need to be changed to run other datasets.
```
cd lidar_IMU_calib
./calib.sh
```


## Once the GUI runs...
Details of the calibration process are in the README of [APRIL Lab's lidar_IMU_calib](https://github.com/APRIL-ZJU/lidar_IMU_calib), but here are some takeaways we got from using it.
* Follow steps in [lidar_IMU_calib](https://github.com/APRIL-ZJU/lidar_IMU_calib) README
  * Can see in terminal when each step is done running
* Can’t run multiple steps at the same time
* Running multiple rosbags:
  * After the first bag runs, quit the GUI (`Ctrl C` in terminal) and the next bag will start running 


## Adding New Data
* When importing new bag files, add them to `ros_ws/li_data_calib`
* In `ros_ws/src/lidar_IMU_calib/calib.sh` replace the names of the bags
* Change the topic names in `calib.sh` and `licalib_gui.launch` to match the format of the bag you want to use
* Saved maps can be found in `ros_ws/li_data_calib` under a folder that shares a name with the `.bag` file

## Common Errors
* Don't forget to run `catkin_make` in `ros_ws` after changing C++ code
* If you get a `BagFormatException`, try reindexing the rosbag with the command `rosbag reindex <bag_name>.bag`





