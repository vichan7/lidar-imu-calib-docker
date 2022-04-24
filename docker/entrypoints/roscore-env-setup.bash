#!/usr/bin/env bash


# //////////////////////////////////////////////////////////////////////////////
# ros workpace to source
# //////////////////////////////////////////////////////////////////////////////
# remove from config
remove_ros_ip_to_config() {
  # check if file exists
  if [ ! -f /$HOME/.$1 ]; then
    return;
  fi
  # remove ROS IP setup
  sed -i '/ROS Setup/d' /$HOME/.$1
  sed -i '/ROS_HOSTNAME/d' /$HOME/.$1
  sed -i '/ROS_MASTER_URI/d' /$HOME/.$1
  sed -i '/ROS_IP/d' /$HOME/.$1
}
# add to config
add_ros_ip_to_config() {
  # check if file exists
  if [ ! -f /$HOME/.$1 ]; then
    return;
  fi

  echo "# == ROS Setup == " >> /$HOME/.$1

  # add the ros ip
  if [ "${_ROSCORE_LOCAL}" = true ] ; then
    export ROS_IP=${ROS_MASTER_IP}
    echo "export ROS_IP=${ROS_MASTER_IP}" >> /$HOME/.$1
  fi;

  # add the ros hosname to bashrc
  export ROS_HOSTNAME=${ROS_HOSTNAME}
  echo "export ROS_HOSTNAME=${ROS_HOSTNAME}" >> /$HOME/.$1

  # add the ros master uri
  echo "export ROS_MASTER_URI=http://${ROS_MASTER_IP}:11311" >> /$HOME/.$1
  export ROS_MASTER_URI="http://${ROS_MASTER_IP}:11311"
}

# Add the roscore configured setup variables
if [ "${_SET_ROSCORE}" = true ] ; then
  # remove any previous alias
  remove_ros_ip_to_config "zshrc"
  remove_ros_ip_to_config "bashrc"

  # script add to zsh, bash configs
  add_ros_ip_to_config "zshrc"
  add_ros_ip_to_config "bashrc"

  echo "roscore setup done."
fi

# //////////////////////////////////////////////////////////////////////////////
# ros workpace to source
# //////////////////////////////////////////////////////////////////////////////
# remove from config
remove_ros_top_level_ws() {
  # check if file exists
  if [ ! -f /$HOME/.$1 ]; then
    return;
  fi
  # remove ROS IP setup
  sed -i '/Source ROS/d' /$HOME/.$1
  sed -i '/source/d' /$HOME/.$1
}

# add to config
add_ros_top_level_ws() {
  # check if file exists
  if [ ! -f /$HOME/.$1 ]; then
    return;
  fi
  # Append to bash rc
  echo "source /opt/ros/melodic/setup.bash" >> /$HOME/.$1
  echo "# Source ROS Top Level Workspace " >> /$HOME/.$1
  if [[ ! -z $_ROS_DISTRO ]]; then
    echo "source /opt/ros/$_ROS_DISTRO/setup.bash " >> /$HOME/.$1
  fi
  echo "source $_ROS_WS " >> /$HOME/.$1
}

# Add the ros workspace to be sourced
if [ "${_SET_WS}" = true ] ; then
  # remove any previous alias
  remove_ros_top_level_ws "zshrc"
  remove_ros_top_level_ws "bashrc"

  # add source path to zsh, bash configs
  add_ros_top_level_ws "zshrc"
  add_ros_top_level_ws "bashrc"
fi

# //////////////////////////////////////////////////////////////////////////////
echo "ROS environment setup completed."
