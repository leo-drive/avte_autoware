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
    - For Ubuntu: 
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
    
    - If you have multiple cards or an on-board gpu, you can select the nvidia card as default with prime-select
        ```bash
        sudo prime-select nvidia
        sudo reboot
        ```

    - To Check if the driver is installed correctly
        ```bash
        nvidia-smi
        ```

    - You can remove the old drivers and all dependencies with the following commands \
      to install other driver
        ```bash 
        sudo apt-get-autoremove --purge '^nvidia-.*'
        sudo apt-get-autoremove --purge '^libnvidia-.*'
        sudo apt-get-autoremove --purge '^cuda-.*'
        ```

2. Install Docker and Nvidia Container Toolkit

    ```bash
    setup-dev-env.sh docker
    ```
3. Fetch the runtime images for Open AD Kit
    - Fetch planning demo containers before and after OTA update
       ```bash
        docker pull ghcr.io/oguzkaganozt/autoware-openadk:planning-demo-before-ota-amd64
        docker pull ghcr.io/oguzkaganozt/autoware-openadk:planning-demo-after-ota-amd64
       ```

       For aarch64 architecture
       ```bash
       docker pull ghcr.io/oguzkaganozt/autoware-openadk:planning-demo-before-ota-aarch64
       docker pull ghcr.io/oguzkaganozt/autoware-openadk:planning-demo-after-ota-aarch64
       ```
          
5. Run the image using docker - No CUDA support needed for planning demo
    ```bash
    # Allow external applications to connect host's X display
    xhost + 

    # Run the container
    sudo docker run -it --rm --net=host image:tag /bin/bash
    
    # Run the container with CUDA support
    sudo docker run -it --rm --net=host --gpus all --runtime nvidia -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix image:tag /bin/bash
