#!/bin/bash

# Prompt the user for the network interface name
read -p "Enter the network interface name (e.g., eth0, ens33): " interface

# Check if the interface exists
if ! ip link show "$interface" > /dev/null 2>&1; then
    echo "Interface $interface does not exist."
    exit 1
fi

# Assign static IP address, gateway, and DNS
sudo tee /etc/netplan/01-netcfg.yaml > /dev/null <<EOT
network:
  version: 2
  ethernets:
    $interface:
      dhcp4: no
      addresses: [192.168.80.163/24]
      gateway4: 192.168.80.1
      nameservers:
          addresses: [8.8.8.8]
EOT

# Apply the netplan configuration
sudo netplan apply

echo "Static IP address assigned to $interface."