#!/bin/bash

IP_ADDRESS="10.10.0.3"
ETH="eth1"
NETMASK="255.255.255.0"
# Check if the user is root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

# Configure the IP address and netmask for eth1 interface
cat >> /etc/network/interfaces << EOF

auto $ETH
iface $ETH inet static
address $IP_ADDRESS
netmask $NETMASK
EOF

# Enable the eth1 interface
ifdown $ETH
ifup $ETH
