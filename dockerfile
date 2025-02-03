FROM ros:humble-perception

# set env var during docker build only
ARG DEBIAN_FRONTEND=noninteractive

# add vulkan repo to apt
RUN apt-get update && apt-get install -y wget
RUN wget -qO- https://packages.lunarg.com/lunarg-signing-key-pub.asc | sudo tee /etc/apt/trusted.gpg.d/lunarg.asc
RUN wget -qO /etc/apt/sources.list.d/lunarg-vulkan-jammy.list http://packages.lunarg.com/vulkan/lunarg-vulkan-jammy.list
RUN apt-get update && apt-get install -y vulkan-sdk

# install deps via apt
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    build-essential cmake git wget gdb doxygen \
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
    build-essential cmake git python3 python3-dev python3-pip libjemalloc-dev libtbb-dev ros-humble-openvdb-vendor libboost-iostreams-dev libblosc-dev

# # CUDA deps for nvblox
# RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb \
#     && dpkg -i cuda-keyring_1.1-1_all.deb \
#     && apt-get update && apt-get -y install cuda-toolkit-12-8 \
#     && apt-get install -y libgoogle-glog-dev libgtest-dev libgflags-dev python3-dev libsqlite3-dev libbenchmark-dev

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