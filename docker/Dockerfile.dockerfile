FROM ros:melodic
RUN apt-get update && apt-get install -y \
    ros-melodic-desktop-full


# Add a user with the same user_id as the user outside the container
# Requires a docker build argument `user_id`
ARG user_id=$user_id
ENV USERNAME developer
RUN useradd -U --uid ${user_id} -ms /bin/bash $USERNAME \
 && echo "$USERNAME:$USERNAME" | chpasswd \
 && adduser $USERNAME sudo \
 && echo "$USERNAME ALL=NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME

# Commands below run as the developer user
USER $USERNAME

# When running a container start in the developer's home folder
WORKDIR /home/$USERNAME

   
RUN sudo apt install -y ros-melodic-mav-msgs ros-melodic-rosmon python-wstool python-jinja2  ros-melodic-geographic-msgs  libgeographic-dev  geographiclib-tools

RUN sudo apt-get install -y openssh-server python-dev python3-pip software-properties-common less vim gdb python-catkin-tools python-pip python-wheel

RUN pip install numpy toml future

RUN git clone --recursive https://github.com/stevenlovegrove/Pangolin.git
RUN cd Pangolin 

# Install dependencies (as described above, or your preferred method)
RUN ./scripts/install_prerequisites.sh recommended -Y

# Configure and build
RUN mkdir build && cd build
RUN cmake ..
RUN cmake --build .


ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all 

ENV entrypoint_container_path /docker-entrypoint/
ADD entrypoints/ $entrypoint_container_path/

# execute entrypoint script
RUN sudo chmod +x -R $entrypoint_container_path/



