#!/bin/bash

# Define the path for the SSH banner
SSH_BANNER="/etc/ssh/sshd_banner"

# Create or overwrite the SSH banner file
sudo tee "$SSH_BANNER" > /dev/null <<EOF
*************************************************
*               WARNING: Authorized Access     *
*************************************************
* This system is for authorized users only.    *
* Unauthorized access or use of this system is *
* strictly prohibited and may be prosecuted to *
* the fullest extent of the law.               *
*************************************************
  ______     ______     __    __     ______     ______   __         ______    
 /\  ___\   /\  == \   /\ "-./  \   /\  ___\   /\__  _\ /\ \       /\  ___\   
 \ \ \____  \ \  __<   \ \ \-./\ \  \ \  __\   \/_/\ \/ \ \ \____  \ \  __\   
  \ \_____\  \ \_\ \_\  \ \_\ \ \_\  \ \_____\    \ \_\  \ \_____\  \ \_____\ 
   \/_____/   \/_/ /_/   \/_/  \/_/   \/_____/     \/_/   \/_____/   \/_____/ 
                                                                              
EOF

# Restart the SSH service to apply the changes
sudo systemctl restart sshd