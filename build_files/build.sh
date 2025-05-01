# build_files/build.sh
#!/bin/bash

# Code from https://github.com/jerhage/bazzite-custom and https://github.com/EisregenHaha/fedora-hyprland

RELEASE="$(rpm -E %fedora)"
TEMP_DIR="/tmp/build-deps" # Use a temporary directory for downloads/builds
set -ouex pipefail

mkdir -p /etc/skel/.config
mkdir -p /etc/skel/.local

# Ensure temp dir exists and is clean
rm -rf "${TEMP_DIR}"
mkdir -p "${TEMP_DIR}"

enable_copr() {
    repo="$1"
    repo_with_dash="${repo/\//-}"
    # Use --retry-connrefused and timeout for robustness
    wget --retry-connrefused --waitretry=5 --tries=5 --timeout=30 \
        "https://copr.fedorainfracloud.org/coprs/${repo}/repo/fedora-${RELEASE}/${repo_with_dash}-fedora-${RELEASE}.repo" \
        -O "/etc/yum.repos.d/_copr_${repo_with_dash}.repo"
}

add_repo() {
    url="$1"
    filename="$2"
    wget --retry-connrefused --waitretry=5 --tries=5 --timeout=30 \
        "$url" -O "/etc/yum.repos.d/${filename}.repo"
}

### Install packages

# Enable necessary COPRs and Repos first
enable_copr solopasha/hyprland
enable_copr erikreider/SwayNotificationCenter # Kept from previous version
enable_copr pgdev/ghostty # Kept from previous version
enable_copr atim/starship
# Add the notekit repo - Adjust Fedora_Rawhide if targeting a specific release like $RELEASE
add_repo "https://download.opensuse.org/repositories/home:sp1rit:notekit/Fedora_Rawhide/home:sp1rit:notekit.repo" "home-sp1rit-notekit"
# --- Group 1: Core Wayland & Hyprland ---
dnf5 install -y --setopt=install_weak_deps=False \
    hyprcursor \
    hypridle \
    hyprlang-devel \
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
    hyprutils \
    hyprwayland-scanner \
    qt5-qtwayland \
    qt6-qtwayland \
    waybar \
    wl-clipboard \
    wlogout \
    xrandr # Often useful for display setup even in Wayland

# --- Group 2: Desktop Portals, Session & Auth ---
dnf5 install -y --setopt=install_weak_deps=False \
    mate-polkit \
    polkit-kde \
    sddm \
    xdg-desktop-portal \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal-hyprland \
    xdg-utils

# --- Group 3: Essential Utilities ---
dnf5 install -y --setopt=install_weak_deps=False \
    NetworkManager-tui \
    axel \
    brightnessctl \
    cliphist \
    clipman \
    coreutils \
    curl \
    ddcutil \
    fuzzel \
    gammastep \
    gojq \
    grim \
    grimblast \
    jq \
    libdbusmenu \
    libwebp-devel \
    network-manager-applet \
    npm \
    pamixer \
    parallel \
    pavucontrol \
    playerctl \
    ripgrep \
    rsync \
    slurp \
    swappy \
    swaylock-effects \
    swww \
    tesseract \
    tmux \
    unzip \
    upower \
    uv \
    wget \
    wf-recorder \
    wireplumber \
    wofi \
    yad \
    ydotool

# --- Group 4: Development Tools & Libraries ---
dnf5 install -y --setopt=install_weak_deps=False \
    appstream-util \
    blueprint-compiler \
    cargo \
    clang \
    file-devel \
    gjs-devel \
    gnome-bluetooth \
    gobject-introspection-devel \
    gtk-layer-shell-devel \
    gtk4-devel \
    gtksourceview3-devel \
    gtksourceviewmm3-devel \
    libadwaita-devel \
    libdbusmenu-devel \
    libdbusmenu-gtk3-devel \
    libdrm-devel \
    libsass-devel \
    libsoup-devel \
    libsoup3-devel \
    libxdp-devel \
    meson \
    pam-devel \
    pulseaudio-libs-devel \
    python3-devel \
    python3.11-devel \
    python3.12-devel \
    scdoc \
    tinyxml \
    tinyxml2-devel 

# --- Group 5: Python Packages (RPMs & Core) ---
dnf5 install -y --setopt=install_weak_deps=False \
    pyprland \
    python3 \
    python3-build \
    python3-cairo \
    python3-gobject \
    python3-gobject-devel \
    python3-libsass \
    python3-pillow \
    python3-pip \
    python3-psutil \
    python3-pywayland \
    python3-regex \
    python3-setuptools_scm \
    python3-wheel \
    python3.11 \
    python3.12

# --- Group 6: Theming, Appearance & Fonts ---
dnf5 install -y --setopt=install_weak_deps=False \
    SwayNotificationCenter \
    adw-gtk3-theme \
    aylurs-gtk-shell \
    dunst \
    eww-wayland \
    foot \
    gnome-themes-extra \
    jetbrains-mono-fonts \
    kvantum \
    kvantum-qt5 \
    nwg-drawer \
    nwg-look \
    qt5ct \
    qt6ct \
    rofi-wayland \
    starship \
    swaync 

# --- Group 7: Specific Applications ---
dnf5 install -y --setopt=install_weak_deps=False \
    blueman \
    ghostty \
    gjs \
    wdisplays

### Handle Manual Installations ###
# TODO later.
#mkdir /usr/local/bin
#echo "Attempting manual installation of cliphist"
#cd "${TEMP_DIR}"
#wget https://github.com/sentriz/cliphist/releases/download/v0.6.1/v0.6.1-linux-amd64 -O cliphist
#chmod +x cliphist
## Check if an RPM didn't already install it
#if [[ ! -f /usr/bin/cliphist ]]; then
#    cp cliphist /usr/local/bin/cliphist
#else
#    echo "cliphist already installed via RPM, skipping manual copy."
#fi

#echo "Attempting manual installation of dart-sass"
#cd "${TEMP_DIR}"
#wget https://github.com/sass/dart-sass/releases/download/1.87.0/dart-sass-1.87.0-linux-x64.tar.gz -O dart-sass.tar.gz
#tar -xzf dart-sass.tar.gz
## Check if an RPM didn't already install it
#if [[ ! -f /usr/bin/dart-sass ]] && [[ ! -f /usr/local/bin/dart-sass ]]; then
#    # Copying directly to /usr/local/bin is generally okay for self-contained binaries
#    cp -rf dart-sass/* /usr/local/bin/
#else
#     echo "dart-sass appears to be already installed, skipping manual copy."
#fi


#echo "Attempting manual build/install of anyrun"
#cd "${TEMP_DIR}"
## Check if cargo was installed
#if command -v cargo &> /dev/null; then
#    # Check if rust/cargo setup is needed (might be required in some build envs)
#    # export CARGO_HOME="/path/to/build/cargo/home"
#    # export RUSTUP_HOME="/path/to/build/rustup/home"
#    # curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
#    # source "$CARGO_HOME/env"
#
#    git clone https://github.com/anyrun-org/anyrun.git
#    cd anyrun
#    cargo build --release --target-dir target # Build all the packages, specify target dir
#    # Install the anyrun binary to /usr/local/bin instead of relying on user's $HOME/.cargo
#    cp target/release/anyrun /usr/local/bin/
#
#    # The following steps are user-specific and should ideally be done post-install
#    # mkdir -p ~/.config/anyrun/plugins # Create the config directory and the plugins subdirectory
#    # cp target/release/*.so ~/.config/anyrun/plugins # Copy all of the built plugins to the correct directory
#    # cp examples/config.ron ~/.config/anyrun/config.ron # Copy the default config file
#    echo "Anyrun binary built and copied to /usr/local/bin."
#    echo "Plugins and default config were NOT copied to user directory during build."
#    echo "Plugins are available in ${TEMP_DIR}/anyrun/target/release/*.so"
#    # Optionally copy plugins to a system location? e.g., /usr/lib/anyrun/plugins
#    mkdir -p /usr/lib/anyrun/plugins
#    cp target/release/*.so /usr/lib/anyrun/plugins/
#    echo "Anyrun plugins copied to /usr/lib/anyrun/plugins/"
#else
#    echo "Cargo not found, skipping anyrun build."
#fi

mkdir -p /etc/skel/.config/
mkdir -p /etc/skel/.local/
#rsync -rvK /ctx/system_files/etc /etc

mkdir -p "${TEMP_DIR}/fedora-hyprland"
git clone https://github.com/EisregenHaha/fedora-hyprland "${TEMP_DIR}/fedora-hyprland"
cd "${TEMP_DIR}/fedora-hyprland"
cp -Rf .config/* /etc/skel/.config/
cp -Rf .local/* /etc/skel/.local/


# Font installation from end4fonts git repo needs separate handling.
# Example:
# cd "${TEMP_DIR}"
# git clone https://github.com/EisregenHaha/end4fonts
# mkdir -p /usr/share/fonts/end4fonts # Install system-wide
# cp -R end4fonts/fonts/* /usr/share/fonts/end4fonts/
# fc-cache -fv # Update font cache


# Clean up temporary build directory
rm -rf "${TEMP_DIR}"

# Clean up added repo definitions if desired (optional, COPRs are often disabled later)
# rm -f /etc/yum.repos.d/home-sp1rit-notekit.repo

# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging
# dnf5 -y copr disable solopasha/hyprland
# dnf5 -y copr disable erikreider/SwayNotificationCenter
# dnf5 -y copr disable pgdev/ghostty
# dnf5 -y copr disable atim/starship
# Consider disabling the manually added repo too if not needed on final image
# dnf config-manager --set-disabled home-sp1rit-notekit # Alternative way

#### Example for enabling a System Unit File

systemctl enable podman.socket

# Check if gammastep service exists and enable if desired
# systemctl enable gammastep.service # Or gammastep-systemd-user.service? Needs investigation.

# // ... rest of the script ...

# The `ln -sf /tmp/.ydotool_socket ...` command from the original script
# creates a user-specific link and cannot be reliably done during image build.
# This should be handled by user login scripts or configuration.

mkdir -p /nix/var/nix/gcroots/per-user/bazzite
