#!/bin/bash

# Define the SSH banner content
SSH_BANNER_CONTENT="
*************************************************
*               RUPALI BANK PLC.                *
*           ICT OPERATIONS DIVISION             *
*************************************************
* This system is for authorized users only.     *
* Unauthorized access or use of this system is  *
* strictly prohibited and may be prosecuted to  *
* the fullest extent of the law.                *
*                                               *
* For any issues, contact:                      *
* Email: sysadmin@rupalibank.org                *
*************************************************
"

# Path to the SSH banner file
SSH_BANNER_FILE="/etc/ssh/sshd_banner"

# Create or overwrite the SSH banner file
echo "$SSH_BANNER_CONTENT" | sudo tee "$SSH_BANNER_FILE"

# Ensure SSH daemon is configured to use the banner
if ! grep -q "^Banner $SSH_BANNER_FILE" /etc/ssh/sshd_config; then
    echo "Banner $SSH_BANNER_FILE" | sudo tee -a /etc/ssh/sshd_config
fi

# Restart the SSH service to apply changes
sudo systemctl restart sshd

echo "SSH banner setup completed for RUPALI BANK PLC."

