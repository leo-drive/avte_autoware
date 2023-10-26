# Autoware Open AD Kit

The [Open AD Kit](https://www.autoware.org/autoware-open-ad-kit) is a collaborative project developed by the [Autoware Foundation](https://www.autoware.org/) and its member companies and alliance partners. It aims to bring software-defined best practices to the [Autoware project](https://autowarefoundation.github.io/autoware-documentation/main/) and to enhance the [Autoware ecosystem](https://www.autoware.org/autoware-members) and capabilities by partnering with other organizations that share the goal of creating software-defined vehicles.

The Open AD Kit utilizes Autoware components, which are built using the [ROS2 framework](https://docs.ros.org/en/humble/index.html) and the SOAFEE reference implementation [EWAOL](https://gitlab.com/soafee/ewaol/meta-ewaol), to create a practical application demonstrating how [SOAFEE](https://www.soafee.io/)'s vision of software-defined vehicles can be realized. ROS2, with its nodes architecture, provides the foundation for having distinct functional containerized runtime modules. Open AD Kit application can also communicate with other containerized applications to support various functionalities, such as providing a bi-directional data pipeline and providing up-to-date maps to be consumed within the Open AD Kit application.

Open AD kit solution built upon the [AVA Developer Platform](https://www.adlinktech.com/Products/Computer_on_Modules/COM-HPC-Server-Carrier-and-Starter-Kit/AVA_Developer_Platform) from ADLINK, which is a high-performance, high-density, and high-reliability ARM Neoverse N1-based server carrier board. Both AVA Developer Platform and EWAOL lays the foundation for the Open AD Kit to be deployed as a lightweight and scalable software-defined vehicle platform.

Open AD Kit is also capable of getting OTA updates by using [eSync Alliance's](https://www.esyncalliance.org/) technology. eSync is a secure, scalable, and reliable OTA update solution that can be used to update the Open AD Kit application and its dependencies. eSync is also capable of updating the Open AD Kit application and its dependencies on the fly, which means that the Open AD Kit application can be updated without having to restart the vehicle.

## Open AD Kit Architecture
![AD Kit Architecture](https://user-images.githubusercontent.com/21222428/231436248-f745830d-a74f-42e0-8afe-fd58f6dbc8fc.jpg)

## Using Open AD Kit

### Hardware Prerequisites

Open AD Kit as a software-defined vehicle platform is built upon the [AVA Developer Platform](https://www.adlinktech.com/Products/Computer_on_Modules/COM-HPC-Server-Carrier-and-Starter-Kit/AVA_Developer_Platform) from ADLINK, but for demonstration purposes it can be deployed on NVIDIA GPU enabled x86_64 and ARM64 platforms. The following table shows the minimum hardware requirements for Open AD Kit.

| Hardware | Minimum Requirements |
| --- | --- | 
| CPU | 8 cores, 2.0 GHz |
| Memory | 16 GB |
| Storage | 128 GB |
| GPU | NVIDIA GPU with CUDA support |

### Software Prerequisites

Open AD Kit built upon [EWAOL](https://gitlab.com/soafee/ewaol/meta-ewaol) which provides all the necessary software dependencies. But it can be deployed on a platform which meets the hardware prerequisites. The following table shows the minimum software requirements for Open AD Kit.

| Software | Minimum Requirements |
| --- | --- |
| OS | Ubuntu 20.04 |
| NVIDIA Linux drivers | 418.81.07 |
| NVIDIA Container Toolkit | 1.3.0 |
| Docker | 19.03.13 |
| Docker Compose | 1.27.4 |

Detailed instructions on how to install the software prerequisites can be found in the [Open AD Kit Prerequisites Installation Guide](https://github.com/leo-drive/avte_autoware/blob/main/docker/autoware-openadk/docs/installation.md).

### Build

To build the Open AD Kit application, run the following command:

```bash
cd docker/autoware-openadk
./build.sh # can give --module <module_name> to build a specific module, by default monolithic build is performed
```

### Run

To run the Open AD Kit monolithic docker image:

```bash
cd docker/autoware-openadk
./run.sh
```

### Test

To test the Open AD Kit monolithic image using pre-installed simulation data, once you enter the docker container:

- Run the following command for the planning simulation:

  ```bash
  awf-launch-sample-planning-sim
  ```

- For the rosbag replay simulation, run the following command:

  ```bash
  awf-launch-sample-replay-sim
  ```

  - And to replay the sample rosbag from another terminal:

    ```bash
    awf-replay-sample-rosbag
    ```

## Further Documentation

To learn more technical details about Autoware,SOAFEE refer to the [Autoware documentation site](https://autowarefoundation.github.io/autoware-documentation/main/), [SOAFEE documentation site](https://gitlab.com/soafee/blueprints).

## Contributing

- [There is no formal process to become a contributor](https://github.com/autowarefoundation/autoware-projects/wiki#contributors) - you can comment on any [existing issues](https://github.com/autowarefoundation/autoware.universe/issues) or make a pull request on any Autoware repository!
  - Make sure to follow the [Contribution Guidelines](https://autowarefoundation.github.io/autoware-documentation/main/contributing/).
  - Take a look at Autoware's [various working groups](https://github.com/autowarefoundation/autoware-projects/wiki#working-group-list) to gain an understanding of any work in progress and to see how projects are managed.
- If you have any technical questions, you can start a discussion in the [Q&A category](https://github.com/autowarefoundation/autoware/discussions/categories/q-a) to request help and confirm if a potential issue is a bug or not.

## Useful resources
- [AVA Developer Platform](https://www.adlinktech.com/Products/Computer_on_Modules/COM-HPC-Server-Carrier-and-Starter-Kit/AVA_Developer_Platform)
- [ARM Software Defined Vehicle](https://www.arm.com/blogs/blueprint/software-defined-vehicle)
- [Autoware Foundation homepage](https://www.autoware.org/)
- [Support guidelines](https://autowarefoundation.github.io/autoware-documentation/main/support/support-guidelines/)
