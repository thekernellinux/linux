#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Variables
NTP_SERVER_IP="192.168.1.1"  # Replace with the IP address of your Chrony NTP server

# Install Chrony package
echo "Installing Chrony package..."
apt update
apt install -y chrony

# Configure Chrony as an NTP client
echo "Configuring Chrony as an NTP client..."
cat <<EOL > /etc/chrony/chrony.conf
# Use specified NTP server
server $NTP_SERVER_IP iburst

# Default settings
driftfile /var/lib/chrony/chrony.drift
logdir /var/log/chrony

# Allow Chrony to correct large time differences
makestep 1.0 3
EOL

# Restart Chrony service
echo "Restarting Chrony service..."
systemctl restart chrony

# Enable Chrony service to start on boot
echo "Enabling Chrony service to start on boot..."
systemctl enable chrony

# Display Chrony synchronization status
echo "Chrony synchronization status:"
chronyc tracking