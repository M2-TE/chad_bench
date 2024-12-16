FROM ros:humble-perception
# set env var during docker build only
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y

## Dependencies
# Core:
RUN apt-get install -y build-essential cmake git ccache wget ninja-build gdb doxygen
RUN apt-get install -y iputils-ping ros-humble-pcl-ros python3-pip && pip install rosbags
# Vulkan:
RUN wget -qO- https://packages.lunarg.com/lunarg-signing-key-pub.asc | sudo tee /etc/apt/trusted.gpg.d/lunarg.asc
RUN wget -qO /etc/apt/sources.list.d/lunarg-vulkan-jammy.list http://packages.lunarg.com/vulkan/lunarg-vulkan-jammy.list
RUN apt update && apt install -y vulkan-sdk
# Ouster:
RUN apt-get install -y ros-humble-rviz2 ros-humble-pcl-ros ros-humble-tf2-eigen libeigen3-dev libjsoncpp-dev libspdlog-dev libcurl4-openssl-dev python3-colcon-common-extensions
# DLIO:
RUN apt-get install -y libomp-dev libpcl-dev libeigen3-dev
# # LVR2:
RUN apt-get install -y build-essential cmake cmake-curses-gui libflann-dev libgsl-dev libeigen3-dev
RUN apt-get install -y libopenmpi-dev openmpi-bin opencl-c-headers ocl-icd-opencl-dev libcgal-dev
RUN apt-get install -y libvtk9-dev libvtk9-qt-dev libboost-all-dev freeglut3-dev libhdf5-dev qtbase5-dev
RUN apt-get install -y libqt5opengl5-dev liblz4-dev libopencv-dev libyaml-cpp-dev libspdlog-dev
# # Voxblox:
# RUN apt-get install -y python3-wstool python3-catkin-tools ros-noetic-cmake-modules protobuf-compiler autoconf
# RUN git clone https://github.com/catkin/catkin_simple.git
# RUN cd catkin_simple && bash -c ". /opt/ros/noetic/setup.bash && cmake -B build && cmake --build build && cmake --install build"
# # VDBFusion:
# RUN apt-get install -y libgflags-dev

WORKDIR /root/repo/
ENTRYPOINT [ "/bin/bash", "/root/repo/scripts/.entrypoint.sh" ]
ENV ROSCONSOLE_FORMAT='[ROS${severity}]: ${message}'
ENV LIDAR_ADDR=192.168.168.128
ENV PCL_TOPIC=/ouster/points
ENV IMU_TOPIC=/ouster/imu
ENV RVIZ_OUSTER=false
ENV RVIZ_DLIO=false