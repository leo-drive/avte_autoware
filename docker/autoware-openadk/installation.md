# Open AD Kit Prerequisites Installation Guide

### Prerequisites
- Ubuntu 20.04 or 22.04
- Docker version >= 19.03 
- NVIDIA Linux drivers >= 418.81.07

### Installation
1. Nvidia driver Installation
    - For Jetson(arm64):  For jetson devices JetPack SDK would be sufficient as it is already has JetPack repo installed (https://docs.nvidia.com/jetson/jetpack/install-jetpack/index.html)
        ```bash
        sudo apt update
        sudo apt install nvidia-jetpack
        ```
    - For Ubuntu-amd64: 
        - First check if nvidia card is available and check driver usage
        ```bash
        lspci | grep VGA # Check if nvidia cards installed
        lsmod | grep nvidia # Check if nvidia drivers installed
        ```
        - We can install drivers either using Ubuntu Software&Update->Additional Drivers or using CLI 
        ```bash
        sudo apt install nvidia-driver-510 # can be 515,520 etc.
        sudo reboot
        ```

2. Install Nvidia Container Toolkit

    ```bash
    sudo apt-get update
    sudo apt-get install -y nvidia-container-toolkit
    sudo nvidia-ctk runtime configure --runtime=docker
    sudo systemctl restart docker
    ```

    On amd64 architecture test with nvidia-smi

    ```bash
    sudo docker run --rm --runtime=nvidia --gpus all nvidia/cuda:11.6.2-base-ubuntu20.04 nvidia-smi
    ```

    On arm64 architecture test with L4T container (https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-jetpack)

    ```bash
    sudo docker run -it --rm --net=host --runtime nvidia -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix nvcr.io/nvidia/l4t-base:r32.4.3
    ```
3. Fetch the runtime images for Open AD Kit
    - TO-DO !
4. Configure ROS and DDS settings
    - Set network interface on DDS settings if desired with cyclonedds.xml file:
    ```xml
    <?xml version="1.0" encoding="UTF-8" ?>
    <CycloneDDS xmlns="https://cdds.io/config" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="https://cdds.io/config https://raw.githubusercontent.com/eclipse-cyclonedds/cyclonedds/master/etc/cyclonedds.xsd">
    <Domain id="any">
        <General>
                <NetworkInterfaceAddress>wlp0s20f3</NetworkInterfaceAddress>
        </General>
    </Domain>
    </CycloneDDS>
    ```
    - Set the path for cyclonedds.xml with CYCLONEDDS_URI

5. Run the image using docker
    ```bash
    # Allow external applications to connect host's X display
    xhost + 

    # Run the container
    sudo docker run -it --rm --net=host --privileged --runtime nvidia -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix image:tag /bin/bash
    ```
6. Run the image using rocker
    ```bash
    rocker --nvidia --x11 --volume exact_path_to_dir image:tag /bin/bash
    ```
