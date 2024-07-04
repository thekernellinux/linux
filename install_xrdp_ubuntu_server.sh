#!/bin/bash

# Update package index
sudo apt update

# Install xrdp and related packages
sudo apt install -y xrdp

# Start and enable xrdp service
sudo systemctl start xrdp
sudo systemctl enable xrdp

# Configure firewall to allow RDP port (3389/tcp)
sudo ufw allow 3389/tcp

# Optional: Install a desktop environment (e.g., Xfce) if not already installed
# Uncomment the following lines if you want to install a desktop environment
# sudo apt install -y xfce4 xfce4-goodies

# Optional: Configure xrdp session to use Xfce (replace xfce-session with your preferred desktop environment)
#sudo sed -i 's/^.*session.*$/&\nxfce-session/' /etc/xrdp/startwm.sh

# Restart xrdp service for changes to take effect
sudo systemctl restart xrdp

echo "xrdp installation and configuration completed."
echo "You can now connect to your Ubuntu server using an RDP client."