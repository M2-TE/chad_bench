FROM ros:humble-perception

# set env var during docker build only
ARG DEBIAN_FRONTEND=noninteractive

# install deps via apt
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    build-essential cmake git wget gdb doxygen \
    iputils-ping ros-humble-pcl-ros python3-pip \
    # Ouster
    ros-humble-rviz2 ros-humble-pcl-ros ros-humble-tf2-eigen libeigen3-dev libjsoncpp-dev \
    libspdlog-dev libcurl4-openssl-dev python3-colcon-common-extensions \
    # DLIO
    libomp-dev libpcl-dev libeigen3-dev \
    # VDBFusion
    build-essential cmake git python3 python3-dev python3-pip libjemalloc-dev libtbb-dev ros-humble-openvdb-vendor libboost-iostreams-dev libblosc-dev
    
# rosbag converter tool
RUN pip install rosbags

# clean up image to reduce size
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /root/repo/
ENTRYPOINT [ "/bin/bash", "/root/repo/scripts/.entrypoint.sh" ]
ENV ROSCONSOLE_FORMAT='[ROS${severity}]: ${message}'
ENV LIDAR_ADDR=192.168.168.128
ENV PCL_TOPIC=/ouster/points
ENV IMU_TOPIC=/ouster/imu
ENV RVIZ_OUSTER=false
ENV RVIZ_DLIO=false
# cuda specific
# ENV CUDA_PATH=/usr/local/cuda
# ENV CUDA_BIN_PATH=/usr/local/cuda/bin
# ENV CUDA_LIB_PATH=/usr/local/cuda/lib64
# ENV CUDA_INCLUDE_PATH=/usr/local/cuda/include
# ENV PATH=$PATH:/usr/local/cuda/bin
# ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64