#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source /opt/ros/humble/setup.bash
source ${SCRIPT_DIR}/../install/setup.bash
# ros2 launch direct_lidar_inertial_odometry dlio.launch.py rviz:=${RVIZ_DLIO} pointcloud_topic:=${PCL_TOPIC} imu_topic:=${IMU_TOPIC}
ros2 launch direct_lidar_inertial_odometry dlio.launch.py rviz:=${RVIZ_DLIO} pointcloud_topic:=/os1_points imu_topic:=/imu/data_raw