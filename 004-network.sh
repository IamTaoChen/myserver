#!/bin/bash

IP_ADDRESS="10.10.0.3"

# Check if the user is root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

# Configure the IP address and netmask for eth1 interface
ip addr add $IP_ADDRESS/24 dev eth1

# Enable the eth1 interface
ip link set eth1 up