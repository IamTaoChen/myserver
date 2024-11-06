#!/bin/bash

SSH_RSA_FILE="$HOME/.ssh/id_rsa"

# Check if SSH key already exists
if [ ! -f "$SSH_RSA_FILE" ]; then
    # Generate a new RSA key if it doesn't exist
    ssh-keygen -t rsa -b 4096 -f "$SSH_RSA_FILE"
else
    echo "SSH key already exists at $SSH_RSA_FILE"
fi

echo "Public Key is:"
cat "$SSH_RSA_FILE.pub"