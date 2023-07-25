# lib embree

This role installs [Embree](https://github.com/embree/embree) from Intel.

## Inputs

None.

## Manual Installation

```bash
# Taken from https://github.com/autowarefoundation/autoware.universe/issues/1912#issuecomment-1254722000
sudo add-apt-repository ppa:kisak/kisak-mesa -y
sudo apt install libegl-mesa0 libglfw3-dev -y

git clone https://github.com/oneapi-src/oneTBB -b v2021.3.0
cd ~/oneTBB
mkdir build & cd build & cmake -DCMAKE_CXX_STANDARD=20 -DCMAKE_BUILD_TYPE=debug -DCMAKE_CXX_COMPILER=g++ -DCMAKE_C_COMPILER=gcc -DTBB_CPF='ON' -DTBB_TEST=OFF .. & make & sudo make install

git clone https://github.com/embree/embree -b v3.13.0
cd ~/embree
mkdir build && cd build && cmake ../ -DEMBREE_ISPC_SUPPORT=OFF && make && sudo make install
```
