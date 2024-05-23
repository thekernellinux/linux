#!/bin/bash

# Check if user exists
if id "sunny" &>/dev/null; then
    echo "User sunny already exists."
else
    # Create user sunny
    sudo adduser --quiet --disabled-password --gecos "" sunny

    # Set password for user sunny
    echo "DHAKA-METRO" | sudo chpasswd

    # Add user sunny to sudo group with NOPASSWD:ALL permissions
    echo "sunny ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/sunny
fi

