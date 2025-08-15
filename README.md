# fedora-nvidia-bootc

This repository provides the tools and instructions to create a Fedora bootc image with NVIDIA drivers pre-installed. Using bootc, this image can be directly installed and run on bare metal or in a virtual machine, creating a fully functional system that I use every day.
![Screenshot of Wicklow](https://github.com/mrguitar/fedora-nvidia-bootc/blob/main/usr/share/backgrounds/wicklow.jpg)


## Steps
1. clone this repo
2. Make any needed changes to the Containerfile  
3. Build the container image using
   ```
   sudo podman build -f Containerfile -t [registry]/[user]/[image]:[tag]
   ```
4. Create an installer image:
   ```
    sudo podman run \
    --rm \
    -it \
    --privileged \
    --security-opt label=type:unconfined_t \
    -v ./config.toml:/config.toml:ro \
    -v ./output:/output \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    quay.io/centos-bootc/bootc-image-builder:latest \
    --type anaconda-iso \
    --rootfs btrfs
	--use-librepo=True \
    [registry]/[user]/[image]:[tag]
    ```
5. Boot the ISO and install!
