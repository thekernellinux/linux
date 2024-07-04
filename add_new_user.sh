#!/bin/bash

# Add user if not exists
if ! id "sysadmin" &>/dev/null; then
    useradd -m -s /bin/bash newuser
    echo "newuser:password" | chpasswd
    usermod -aG sudo newuser
    echo "User newuser created and added to sudo group."
else
    echo "User newuser already exists."
fi