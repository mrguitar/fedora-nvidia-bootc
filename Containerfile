FROM quay.io/fedora/fedora-bootc

#copy configs & kmod script
COPY etc etc
COPY --chmod=755 kmod.sh /tmp

RUN <<EOF
set -euox pipefail

kver=$(cd /usr/lib/modules && echo *)
mkdir -p /var/roothome /data

dnf group install -y kde-desktop virtualization && \
    dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && 
    dnf group install -y multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin && \
    dnf install --best --allowerasing -y akmod-nvidia android-tools azure-cli bcache-tools btop bwm-ng cockpit cockpit-podman cockpit-storaged cockpit-ws cockpit-machines cockpit-selinux firefox firewalld ffmpeg fuse-exfat gamemode gdb gcc-c++ git guvcview gvfs htop java-headless kamera k3b kernel-devel kernel-headers libaacs libguestfs libinput-utils libva-utils lm_sensors nss-mdns nvidia-container-toolkit nvidia-vaapi-driver openrgb-udev-rules pcp powertop steam-devices subscription-manager thermald tree tuned unzip vdpauinfo v4l2loopback v4l-utils vim-enhanced wget xorg-x11-drv-nvidia zip && \
    dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld && \
    dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld && \
    dnf remove -y --no-autoremove plasma-discover-offline-updates plasma-discover-packagekit && \
    dnf clean all && \
    systemctl enable fstrim.timer podman-auto-update.timer cockpit.socket lm_sensors sysstat tuned libvirtd.socket && \
    systemctl set-default graphical.target && \

rm -rf /var/run*

#Build kmods
/tmp/kmod.sh

#added linting to catch basic issues
bootc container lint

EOF

#Configure Default SDDM background
COPY usr usr
