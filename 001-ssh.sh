#! /bin/bash
PUB_KEY='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvgg4VkabGgHClQdXAhLSCy04VejRmm/yeepRgs68eV4wnLJrZIuqY/zGVqqCB5NR9LuNcLx6AFORp2PJLFzDzeEQ0xHxe13bGt+P6nWKYfY4GQKbnKdWRAAPr9iEyyyqvSTV13bAcrBjEy5AHRt7T8pjAA6DG+OBayW4Yb/+B9GzZDdZ3hIK72uiN6whQKlWjmTcJSPfzUJrdGxq5QAKx4KBiJ1XHIAEm6XIgAK3TxwYC9cXqu1oGYoDpYZSvJ/J/K1YvrUde82uXUjkKj2ouIRu3CK9LDYbU2HqvIxe4OvD4sDMSezmZGcvPobODZOPCxBn3+tEoIT/PdbNl18v9'

ROOT_DIR=$(dirname $(realpath $0))
USER=$(whoami)
PUB_FILE=$ROOT_DIR/id_rsa.pub

# get options
# use -u to specify user, default is current user
# use -f to specify pub file, default is id_rsa.pub in current dir
while getopts ":u:f:" opt; do
  case $opt in
    u) USER="$OPTARG"
    ;;
    f) PUB_FILE="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
    :) echo "Option -$OPTARG requires an argument." >&2
       exit 1
    ;;
  esac
done
echo  "ROOT_DIR: $ROOT_DIR"
echo "USER: $USER"
echo "PUB_FILE: $PUB_FILE"

if [ ! -f "$PUB_FILE" ]; then
    echo "$PUB_FILE NOT EXIST"
    echo "Use default PUB_KEY"
else
    echo "PUB_FILE EXIST"
    PUB_KEY=$(cat $PUB_FILE)
fi
echo "PUB_KEY: $PUB_KEY"

# get home dir
HOME_DIR=$(getent passwd $USER | cut -d: -f6)
if [ -z "$HOME_DIR" ]; then
    echo "HOME_DIR NOT FOUND"
    exit 1
else
    echo "HOME_DIR: $HOME_DIR"
fi


# get .ssh dir
SSH_DIR=$HOME_DIR/.ssh
AUTH_KEY_FILE=$SSH_DIR/authorized_keys

# create .ssh if not exist
mkdir -p $SSH_DIR

# create authorized_keys if not exist
if [ -f "$AUTH_KEY_FILE" ]; then
    echo "$AUTH_KEY_FILE EXIST"
else
    echo "$AUTH_KEY_FILE NOT EXIST, CREATE"
    touch $AUTH_KEY_FILE
fi

# add pub_key to authorized_keys if not exist
if grep -q "$PUB_KEY" "$AUTH_KEY_FILE"; then
    echo "PUB_KEY EXIST, SKIP"
else
    echo $PUB_KEY >> $AUTH_KEY_FILE
    echo "ADD PUB_KEY TO $AUTH_KEY_FILE"
fi

# change authorized_keys permission to 600
chmod 600 $AUTH_KEY_FILE
chmod 700 $SSH_DIR
chown -R $USER:$USER $SSH_DIR