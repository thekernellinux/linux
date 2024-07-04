#!/bin/bash

# Update package lists
apt update

# Install necessary packages
apt install -y \
    openssh-server \   # SSH server for remote access
    vim \              # Text editor (optional)
    htop \             # Interactive process viewer (optional)
    wget \             # Command-line tool for downloading files
    curl \             # Command-line tool for transferring data with URLs
    git \              # Version control system
    net-tools \        # Collection of tools including ifconfig and netstat
    nmon \             # Performance monitoring tool
    traceroute \       # Network diagnostic tool for displaying route and packet information
    telnet \           # User interface to the TELNET protocol
    nano \             # Text editor (optional)
    cmatrix \          # Terminal-based "Matrix" screensaver
    terminator \       # Terminal emulator with useful features
    nload \            # Real-time network traffic monitor

# Print completion message
echo "Installation completed."
