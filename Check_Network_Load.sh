#!/bin/bash

# Check if vnstat is installed
if ! command -v vnstat &> /dev/null
then
    echo "vnstat is not installed. Please install it and try again."
    exit 1
fi

# Get the network interface
INTERFACE=${1:-eth0}

# Get current network load
echo "Checking network load for interface: $INTERFACE"
vnstat -i "$INTERFACE" -tr 5

# Display network statistics
echo "Daily network statistics for interface: $INTERFACE"
vnstat -i "$INTERFACE" --oneline | awk -F ';' '{print "Date: " $3 ", RX: " $4 " MiB, TX: " $5 " MiB"}'

# Display real-time traffic information
echo "Real-time traffic for interface: $INTERFACE (last 5 seconds)"
vnstat -i "$INTERFACE" -l 5