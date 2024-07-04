#!/bin/bash

# Function to log actions
log_action() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a /var/log/server_security.log
}

# Update the system
log_action "Updating the system..."
apt-get update && apt-get upgrade -y

# Install UFW
log_action "Installing UFW (Uncomplicated Firewall)..."
apt-get install ufw -y

# Configure UFW
log_action "Configuring UFW..."
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw enable

# Install Fail2ban
log_action "Installing Fail2ban..."
apt-get install fail2ban -y

# Configure Fail2ban
log_action "Configuring Fail2ban..."
cat <<EOT > /etc/fail2ban/jail.local
[DEFAULT]
ignoreip = 127.0.0.1/8

[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
maxretry = 5
EOT

systemctl restart fail2ban

# Secure SSH
log_action "Securing SSH..."
sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd

log_action "Security measures applied successfully."

# End of script
log_action "Script execution completed."