FROM ros:humble-perception
# set env var during docker build only
ARG DEBIAN_FRONTEND=noninteractive

# # add vulkan repo to apt
# RUN apt-get update && apt-get install -y wget
# RUN wget -qO- https://packages.lunarg.com/lunarg-signing-key-pub.asc | sudo tee /etc/apt/trusted.gpg.d/lunarg.asc
# RUN wget -qO /etc/apt/sources.list.d/lunarg-vulkan-jammy.list http://packages.lunarg.com/vulkan/lunarg-vulkan-jammy.list
# RUN apt-get update && apt-get install -y vulkan-sdk

# install deps via apt
RUN apt-get update && apt-get install -y \
    build-essential cmake git ccache wget ninja-build gdb doxygen \
    iputils-ping ros-humble-pcl-ros python3-pip \
    # Ouster
    ros-humble-rviz2 ros-humble-pcl-ros ros-humble-tf2-eigen libeigen3-dev libjsoncpp-dev \
    libspdlog-dev libcurl4-openssl-dev python3-colcon-common-extensions \
    # DLIO
    libomp-dev libpcl-dev libeigen3-dev \
    # LVR2
    build-essential cmake cmake-curses-gui libflann-dev libgsl-dev libeigen3-dev \
    libopenmpi-dev openmpi-bin opencl-c-headers ocl-icd-opencl-dev libcgal-dev libcgal-qt5-dev \
    libvtk9-dev libvtk9-qt-dev libboost-all-dev freeglut3-dev libhdf5-dev qtbase5-dev \
    libqt5opengl5-dev liblz4-dev libopencv-dev libyaml-cpp-dev libspdlog-dev \
    # VDBFusion
    libgflags-dev python3-openvdb
RUN rm -rf /var/lib/apt/lists/*

# rosbag converter tool
RUN pip install rosbags

# build OpenVDB, requirement for VDBFusion
# RUN git clone --depth 1 https://github.com/nachovizzo/openvdb.git -b nacho/vdbfusion && cd openvdb && mkdir build \
#     && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release -DOPENVDB_BUILD_PYTHON_MODULE=ON  \
#     && make -j$(nproc) && make install && cd ../.. && rm -rf openvdb


WORKDIR /root/repo/
ENTRYPOINT [ "/bin/bash", "/root/repo/scripts/.entrypoint.sh" ]
ENV ROSCONSOLE_FORMAT='[ROS${severity}]: ${message}'
ENV LIDAR_ADDR=192.168.168.128
ENV PCL_TOPIC=/ouster/points
ENV IMU_TOPIC=/ouster/imu
ENV RVIZ_OUSTER=false
ENV RVIZ_DLIO=false