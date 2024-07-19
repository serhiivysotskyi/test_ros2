# Use an official ROS 2 base image for Iron
FROM ros:iron-ros-base

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install additional dependencies
RUN apt-get update && \
    apt-get install -y \
    python3-vcstool \
    python3-colcon-common-extensions \
    python3-rosdep \
    libgoogle-glog-dev \
    libunwind-dev \
    libceres-dev \
    ros-iron-slam-toolbox \
    && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init && rosdep update

# Set up the workspace
RUN mkdir -p /ros2_ws/src

# Copy the source.repos file and import packages
COPY source.repos /ros2_ws/
WORKDIR /ros2_ws
RUN vcs import src < source.repos

# Install ROS 2 dependencies
RUN rosdep install --from-paths src --ignore-src -r -y

# Build the packages
RUN colcon build

# Create deb package
RUN mkdir -p /ros2_deb_package/DEBIAN && \
    echo "Package: ros2-iron-packages" > /ros2_deb_package/DEBIAN/control && \
    echo "Version: 1.0" >> /ros2_deb_package/DEBIAN/control && \
    echo "Section: base" >> /ros2_deb_package/DEBIAN/control && \
    echo "Priority: optional" >> /ros2_deb_package/DEBIAN/control && \
    echo "Architecture: amd64" >> /ros2_deb_package/DEBIAN/control && \
    echo "Maintainer: Your Name <your.email@example.com>" >> /ros2_deb_package/DEBIAN/control && \
    echo "Description: ROS2 Iron packages" >> /ros2_deb_package/DEBIAN/control && \
    mkdir -p /ros2_deb_package/opt/ros2_ws && \
    cp -r install/* /ros2_deb_package/opt/ros2_ws/ && \
    dpkg-deb --build /ros2_deb_package

# Output the deb package
RUN mv /ros2_deb_package.deb /ros2_iron_packages.deb
