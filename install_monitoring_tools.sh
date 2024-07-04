#!/bin/bash

# Function to install monitoring tools on Ubuntu
install_on_ubuntu() {
    echo "Updating package list..."
    sudo apt-get update -y

    echo "Installing monitoring tools on Ubuntu..."
    sudo apt-get install -y htop iftop nload sysstat dstat
    echo "Installation completed on Ubuntu."
}

# Function to install monitoring tools on AlmaLinux
install_on_almalinux() {
    echo "Updating package list..."
    sudo yum update -y

    echo "Installing EPEL repository..."
    sudo yum install -y epel-release

    echo "Installing monitoring tools on AlmaLinux..."
    sudo yum install -y htop iftop nload sysstat dstat
    echo "Installation completed on AlmaLinux."
}

# Function to detect the OS and install packages
install_monitoring_tools() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu)
                install_on_ubuntu
                ;;
            almalinux)
                install_on_almalinux
                ;;
            *)
                echo "Unsupported OS: $ID"
                exit 1
                ;;
        esac
    else
        echo "Cannot determine the operating system."
        exit 1
    fi
}

# Main script execution
echo "Server Monitoring Tools Installation Script"
echo "==========================================="
echo

install_monitoring_tools

echo "Script execution completed."