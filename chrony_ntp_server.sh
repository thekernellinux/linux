#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Install Chrony package
echo "Installing Chrony package..."
apt update
apt install -y chrony

# Configure Chrony as an NTP server
echo "Configuring Chrony as an NTP server..."
cat <<EOL > /etc/chrony/chrony.conf
# Use local system time
server 127.127.1.0 iburst
fudge 127.127.1.0 stratum 10

# Allow NTP client access from local network
allow 192.168.1.0/24

# Specify NTP servers to sync with
server 0.ubuntu.pool.ntp.org iburst
server 1.ubuntu.pool.ntp.org iburst
server 2.ubuntu.pool.ntp.org iburst
server 3.ubuntu.pool.ntp.org iburst

# Drift file
driftfile /var/lib/chrony/chrony.drift

# Log file
logdir /var/log/chrony
EOL

# Restart Chrony service
echo "Restarting Chrony service..."
systemctl restart chrony

# Enable Chrony service to start on boot
echo "Enabling Chrony service to start on boot..."
systemctl enable chrony

# Display Chrony server status
echo "Chrony server status:"
systemctl status chrony