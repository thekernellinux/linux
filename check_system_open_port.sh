#!/bin/bash

# Function to check open ports
check_open_ports() {
    echo "Checking open ports..."
    ss -tuln
    echo "--------------------------------"
}

# Function to list running services
list_running_services() {
    echo "Listing running services..."
    systemctl list-units --type=service --state=running
    echo "--------------------------------"
}

# Function to show connected network interfaces
show_network_interfaces() {
    echo "Showing network interfaces..."
    ip -br a
    echo "--------------------------------"
}

# Main script execution
echo "System Information Script"
echo "========================="
echo

# Check open ports
check_open_ports

# List running services
list_running_services

# Show connected network interfaces
show_network_interfaces

echo "Script execution completed."