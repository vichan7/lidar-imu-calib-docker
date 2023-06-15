FROM ros:melodic
RUN apt-get update && apt-get install -y \
    ros-melodic-desktop-full

# add a user with the same user_id as the user outside the container
# requires a docker build argument `user_id`
ARG user_id=$user_id
ENV USERNAME developer
RUN useradd -U --uid ${user_id} -ms /bin/bash $USERNAME \
 && echo "$USERNAME:$USERNAME" | chpasswd \
 && adduser $USERNAME sudo \
 && echo "$USERNAME ALL=NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME

# commands below run as the developer user
USER $USERNAME

# when running a container start in the developer's home folder
WORKDIR /home/$USERNAME

# installing libraries/tools
RUN sudo apt-get install -y python-catkin-tools \
  && sudo apt-get install -y ros-melodic-pcl-ros \
  && sudo apt-get install -y ros-melodic-velodyne-msgs \
  && sudo apt-get install -y libgl1-mesa-dev \
  && sudo apt-get install -y libglew-dev \
  && sudo apt-get install -y libgoogle-glog-dev libgflags-dev libatlas-base-dev \
  && sudo apt-get install -y vim

RUN mkdir deps
# installing ceres
WORKDIR /home/$USERNAME/deps
RUN git clone -b 1.14.0 https://ceres-solver.googlesource.com/ceres-solver
WORKDIR /home/$USERNAME/deps/ceres-solver
RUN mkdir ceres-bin
WORKDIR /home/$USERNAME/deps/ceres-solver/ceres-bin
RUN sudo cmake ..
RUN sudo make -j8
RUN sudo make install

# cloning ndt_omp
WORKDIR /home/$USERNAME/deps
RUN git clone https://github.com/APRIL-ZJU/ndt_omp.git

# fixing errors
RUN sudo mv /usr/include/flann/ext/lz4.h /usr/include/flann/ext/lz4.h.bak \
  && sudo mv /usr/include/flann/ext/lz4hc.h /usr/include/flann/ext/lz4.h.bak \
  && sudo ln -s /usr/include/lz4.h /usr/include/flann/ext/lz4.h \
  && sudo ln -s /usr/include/lz4hc.h /usr/include/flann/ext/lz4hc.h

ENV entrypoint_container_path /docker-entrypoint/
ADD entrypoints/ $entrypoint_container_path/

# execute entrypoint script
RUN sudo chmod +x -R $entrypoint_container_path/

WORKDIR /home/$USERNAME/
RUN rosdep update





