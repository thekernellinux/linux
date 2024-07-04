#!/bin/bash

# Add user if not exists
if ! id "sysadmin" &>/dev/null; then
    useradd -m -s /bin/bash newuser
    echo "sysadmin:password" | chpasswd
    usermod -aG sudo sysadmin
    echo "User sysadmin created and added to sudo group."
else
    echo "User sysadmin already exists."
fi