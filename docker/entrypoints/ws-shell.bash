#!/usr/bin/env bash
# //////////////////////////////////////////////////////////////////////////////
# docker entrypoint script
# //////////////////////////////////////////////////////////////////////////////
set -e
echo "Here"

usermod -u 1000 developer
echo "Here"
usermod -g 1000 developer

sudo chown -R developer ~/slam_ws/ 

# log message
echo " == Workspace Shell == "

# Install the deploy workspace
echo " ==  Install The KDC Workspace =="



# setup roscore IP/hostnames and source the project workspaces
_SET_ROSCORE=true
_SET_WS=true
_ROS_WS="\$ROS_SOURCED_WORKSPACE"
_ROS_DISTRO="\$ROS_DISTRO"
source /docker-entrypoint/roscore-env-setup.bash

# Should be done after the roscore setup - roscore setup removes mmpug setup
# source the bashrc again -- to set the added ros variables
source ~/.bashrc

# Disallow docker exit -- keep container running
echo "Entrypoint ended";

/bin/bash "$@"
