#!/bin/bash

# Variables
USERNAME="username"           # Replace with your desired username
SSH_PORT="2222"               # Replace with your desired SSH port
PUBLIC_KEY="ssh-rsa AAAA..."  # Replace with your actual public key

# Update and upgrade the system
apt update && apt upgrade -y

# Create a new user
adduser $USERNAME
usermod -aG sudo $USERNAME

# Secure SSH
sed -i "s/^#Port 22/Port $SSH_PORT/" /etc/ssh/sshd_config
sed -i "s/^PermitRootLogin.*/PermitRootLogin no/" /etc/ssh/sshd_config
echo "AllowUsers $USERNAME" >> /etc/ssh/sshd_config
sed -i "s/^#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config

# Set up SSH key-based authentication
mkdir -p /home/$USERNAME/.ssh
echo "$PUBLIC_KEY" > /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys

# Restart SSH service
systemctl restart ssh

# Set up firewall
ufw allow $SSH_PORT/tcp
ufw enable

# Install and configure Fail2Ban
apt install fail2ban -y
cat > /etc/fail2ban/jail.local <<EOL
[sshd]
enabled = true
port = $SSH_PORT
EOL
systemctl restart fail2ban

# Install Google Authenticator
apt install libpam-google-authenticator -y
su - $USERNAME -c "google-authenticator -t -d -f -r 3 -R 30 -W"

# Configure PAM for Google Authenticator
echo "auth required pam_google_authenticator.so" >> /etc/pam.d/sshd

# Enable Challenge-Response Authentication
sed -i "s/^#ChallengeResponseAuthentication.*/ChallengeResponseAuthentication yes/" /etc/ssh/sshd_config

# Restart SSH service
systemctl restart ssh

echo "Bastion host setup is complete."
echo "Don't forget to configure your SSH client to use the new port $SSH_PORT."