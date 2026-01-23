#!/usr/bin/env bash

set -e

# Usage:
#   ./install_ros2.sh [ROS_DISTRO] [ROS_PACKAGE] [AUTO_SOURCE]
#   ROS_DISTRO   - e.g. rolling, jazzy, humble, iron (default: rolling)
#   ROS_PACKAGE  - e.g. desktop, ros-base (default: desktop)
#   AUTO_SOURCE  - true|false to add sourcing to ~/.bashrc (default: false)

ROS_DISTRO="${1:-rolling}"
ROS_PACKAGE="${2:-desktop}"
# Allow enabling bashrc sourcing via 3rd arg or env var
AUTO_SOURCE="${3:-${ROS_AUTO_SOURCE:-false}}"

echo "Installing ROS 2 '${ROS_DISTRO}' (${ROS_PACKAGE})"

sudo apt update

# set locale
sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# Enable required repositories
sudo apt install -y software-properties-common
sudo add-apt-repository universe

sudo apt install -y curl
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb"
sudo dpkg -i /tmp/ros2-apt-source.deb

# Install development tools [optional]
sudo apt update && sudo apt install -y ros-dev-tools

# Install ROS 2 (any distro)
sudo apt update
sudo apt install -y "ros-${ROS_DISTRO}-${ROS_PACKAGE}"

# Optionally add ROS 2 environment to bashrc of the primary user
case "${AUTO_SOURCE}" in
  1|true|TRUE|yes|YES)
    # - If run with sudo, update the invoking user's ~/.bashrc
    # - Otherwise, update the current $HOME/.bashrc
    TARGET_BASHRC="${HOME}/.bashrc"
    if [ -n "${SUDO_USER:-}" ] && [ "${SUDO_USER}" != "root" ]; then
        TARGET_BASHRC="$(getent passwd "${SUDO_USER}" | cut -d: -f6)/.bashrc"
    fi

    if [ -w "$(dirname "${TARGET_BASHRC}")" ]; then
        # Only append if not already present
        if ! grep -Fq "source /opt/ros/${ROS_DISTRO}/setup.bash" "${TARGET_BASHRC}" 2>/dev/null; then
            {
                echo ""
                echo "# ROS 2 ${ROS_DISTRO} environment"
                echo "if [ -f /opt/ros/${ROS_DISTRO}/setup.bash ]; then"
                echo "  source /opt/ros/${ROS_DISTRO}/setup.bash"
                echo "fi"
            } >> "${TARGET_BASHRC}"
        fi
    fi
    ;;
esac