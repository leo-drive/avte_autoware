# Milestones
- HEDEF: roscube-rqx-58g ile rosbag toplanıp AVA-dev-platform(arm neoverse armv8)'a gönderilecek orada sens/pers container çalıştırılacak

- awf local image ı build edildi. 14 GB tutuyor.
- local image üzerinde planning ve replay simulator çalıştırıldı.
- custom image için çalışmalara başlandı.
    - rosdep dependency type ları değiştirilmesi gerekebilir şuanda hepsi runtime olarak yükleniyor. Bu da boyutu yükseltiyor
    - cuda ve diğer kütüphanelerin sadece runtime ları yüklenmeli.
    - cuda ve diğer kütüphanelerin runtime ları için nvidia-cuda image ları kullanılabilir.
    - doc, include ve static library ler runtime da kullanılmayacağı için silinebilir.

# Questions
- nvidia-cuda image larını kullanmak süreci daha hızlı ve daha verimli hale getirebilir ? https://hub.docker.com/r/nvidia/cuda
- Foxglove kullanacak mıyız ?


# Hints and Tips
- rosdep install --ignore-src --dependency-types exec --from-paths src --reinstall --simulate 
- Use multi-stage builds to reduce the size of the final image.
- Try to consolidate RUN commands into a single command to reduce the number of layers in the image.
- Use the --no-cache option when building images to ensure that you are always working with the latest versions of packages.
- Use the --squash option when building images to reduce the size of the image layers.
- Use the --pull option when building images to ensure that you are always working with the latest versions of base images.
- Use the --rm option when building images to ensure that you are not leaving behind any intermediate containers.
- Use the --compress and --parallel option ?
- Use "RUN --mount=type=bind instruction" instead of COPY as it is more efficient. 
- Always run an NTP client on the Docker host and within each container process and sync them all to the same NTP server. If you use swarm services, also ensure that each Docker node syncs its clocks to the same time source as the containers.
- RESOURCES
    - https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
    - https://docs.docker.com/develop/dev-best-practices/

## TO-DO
- [ ] Add a script to build docker images
- [ ] Add a script to run docker images with nvidia-docker and X11 forwarding
- [ ] QEMU docker image for ARM64v8 for ARM neoverse based platforms
- [ ] Create new ros2 launch files for docker images
- [ ] Create new docker-compose files for docker images

## Roadmap
- 3rd parties: 
    - CUDA, TensorRT, cudnn: Use nvidia-cuda-cudnn image or build from scratch ?
        - tensorrt: https://docs.nvidia.com/deeplearning/tensorrt/install-guide/index.html
        - CUDA: https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html
        https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=aarch64-jetson&Compilation=Native&Distribution=Ubuntu&target_version=20.04&target_type=deb_local
        - cudnn: https://docs.nvidia.com/deeplearning/cudnn/install-guide/index.html
    - rmw implementation: Use rmw_cyclonedds_cpp or rmw_fastrtps_cpp ?
    - ros2 humble-desktop or humble-base ?
    - geographiclib-tools
    - egm2008-1
- BASE IMAGE:
    - ubuntu 22.04

- DEVEL IMAGE:
    - BASE IMAGE
    - ROS2 humble-desktop
    - devel CUDA, TensorRT, cudnn
    - 3rd parties-devel
    - rosdep update&install
    - pull autoware source

- BUILD IMAGE:
    - DEVEL IMAGE
    - build whole autoware or only specific modules (e.g. perception) specified by user

- RUNTIME IMAGE:
    - BASE IMAGE
    - ROS2 humble-base or desktop (Rviz yada başka tool runtime da kullanılacak mı ?)
    - runtime CUDA, TensorRT, cudnn
    - 3rd parties-runtime
    - copy src&install files from build image
    - rosdep update&install --dependency-type exec
    - clear intermediary files (e.g. include files, .a files)
    - autoware launch or launch specific modules specified by user