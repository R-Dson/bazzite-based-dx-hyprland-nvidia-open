#!/bin/bash

# Code from https://github.com/jerhage/bazzite-custom

RELEASE="$(rpm -E %fedora)"
set -ouex pipefail

enable_copr() {
    repo="$1"
    repo_with_dash="${repo/\//-}"
    wget "https://copr.fedorainfracloud.org/coprs/${repo}/repo/fedora-${RELEASE}/${repo_with_dash}-fedora-${RELEASE}.repo" \
        -O "/etc/yum.repos.d/_copr_${repo_with_dash}.repo"
}


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos

enable_copr solopasha/hyprland
enable_copr erikreider/SwayNotificationCenter
enable_copr pgdev/ghostty
enable_copr che/nerd-fonts
enable_copr lizardbyte/beta
enable_copr atim/starship

wget -O https://download.opensuse.org/repositories/shells:zsh-users:zsh-autosuggestions/Fedora_Rawhide/shells:zsh-users:zsh-autosuggestions.repo \
    -O /etc/yum.repos.d/zsh-autosuggest.repo

dnf5 install -y --setopt=install_weak_deps=False \
    ImageMagick \
    NetworkManager-tui \
    SwayNotificationCenter \
    blueman \
    aquamarine \
    hyprlang \
    hyprcursor \
    hyprutils \
    hyprgraphics \
    brightnessctl \
    cliphist \
    clipman \
    dunst \
    eww-wayland \
    ffmpegthumbs \
    ghostty \
    grim \
    grimblast \
    hyprcursor \
    hypridle \
    hyprland \
    hyprland-qt-support \
    hyprland-qtutils \
    hyprlock \
    hyprpaper \
    hyprpicker \
    hyprpolkitagent \
    hyprshot \
    hyprsunset \
    hyprsysteminfo \
    jq \
    kde-cli-tools \
    kvantum \
    network-manager-applet \
    nwg-drawer \
    nwg-look \
    pamixer \
    parallel \
    pavucontrol \
    polkit-kde \
    pyprland \
    python3 \
    python3-cairo \
    python3-gobject \
    python3-pip \
    qt5-qtgraphicaleffects \
    qt5-qtimageformats \
    qt5-qtquickcontrols \
    qt5-qtquickcontrols2 \
    qt5-qtwayland \
    qt5ct \
    qt6-qtwayland \
    qt6ct \
    rofi \
    rofi-wayland \
    sddm \
    slurp \
    swappy \
    swaylock-effects \
    swaync \
    swww \
    tmux \
    waybar \
    wdisplays \
    wl-clipboard \
    wlogout \
    wofi \
    xdg-desktop-portal \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal-hyprland\
    zsh \
    zsh-autosuggestions \
    tmux \
    cascadia-code-nf-fonts \
    cascadia-mono-nf-fonts \
    nerd-fonts \
    starship \
    sunshine     


# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging
# dnf5 -y copr disable solopasha/hyprland
# dnf5 -y copr disable erikreider/SwayNotificationCenter
# dnf5 -y copr disable pgdev/ghostty


#### Example for enabling a System Unit File

systemctl enable podman.socket

# experimenting to get hyprlock to work
# echo "auth required pam_unix.so" >/etc/pam.d/hyprlock
# echo "auth include system-auth" >/etc/pam.d/hyprlock
# systemctl enable podman.socket
mkdir -p /nix/var/nix/gcroots/per-user/bazzite