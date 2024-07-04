#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Variables
JRE_VERSION="8u291"  # Update to the latest version as needed
JRE_BUILD="b10"      # Update to the latest build as needed
TOMCAT_VERSION="9.0.54"  # Update to the latest version as needed
TOMCAT_USER="tomcat"
TOMCAT_GROUP="tomcat"
INSTALL_DIR="/opt"
TOMCAT_DIR="$INSTALL_DIR/tomcat"

# Install required packages
apt update
apt install -y wget tar

# Download and install Oracle JRE
echo "Downloading Oracle JRE..."
JRE_TAR="jdk-${JRE_VERSION}-linux-x64.tar.gz"
JRE_URL="https://download.oracle.com/otn/java/jdk/${JRE_VERSION}-${JRE_BUILD}/${JRE_TAR}"
wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" $JRE_URL -O /tmp/$JRE_TAR

echo "Extracting JRE..."
tar -zxvf /tmp/$JRE_TAR -C $INSTALL_DIR

# Set JRE environment variables
JRE_HOME=$(find $INSTALL_DIR -maxdepth 1 -type d -name "jdk*" | head -n 1)
echo "export JAVA_HOME=$JRE_HOME" >> /etc/environment
echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/environment
source /etc/environment

# Verify JRE installation
java -version

# Download and install Apache Tomcat
echo "Downloading Apache Tomcat..."
TOMCAT_TAR="apache-tomcat-${TOMCAT_VERSION}.tar.gz"
TOMCAT_URL="https://downloads.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/${TOMCAT_TAR}"
wget $TOMCAT_URL -O /tmp/$TOMCAT_TAR

echo "Extracting Tomcat..."
mkdir -p $TOMCAT_DIR
tar -zxvf /tmp/$TOMCAT_TAR -C $TOMCAT_DIR --strip-components=1

# Create a Tomcat user and group
groupadd $TOMCAT_GROUP
useradd -r -s /bin/false -g $TOMCAT_GROUP -d $TOMCAT_DIR $TOMCAT_USER

# Set permissions
chown -R $TOMCAT_USER:$TOMCAT_GROUP $TOMCAT_DIR

# Create systemd service file for Tomcat
echo "Creating systemd service file for Tomcat..."
cat <<EOL > /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

User=$TOMCAT_USER
Group=$TOMCAT_GROUP

Environment=JAVA_HOME=$JAVA_HOME
Environment=CATALINA_PID=$TOMCAT_DIR/temp/tomcat.pid
Environment=CATALINA_HOME=$TOMCAT_DIR
Environment=CATALINA_BASE=$TOMCAT_DIR
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=$TOMCAT_DIR/bin/startup.sh
ExecStop=/bin/kill -15 \$MAINPID

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd and start Tomcat
echo "Reloading systemd daemon..."
systemctl daemon-reload

echo "Starting Tomcat service..."
systemctl start tomcat

echo "Enabling Tomcat service to start on boot..."
systemctl enable tomcat

# Verify Tomcat installation
echo "Tomcat installation completed. Access it at http://<your_server_ip>:8080"

# Clean up
rm /tmp/$JRE_TAR
rm /tmp/$TOMCAT_TAR