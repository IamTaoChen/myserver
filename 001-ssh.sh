#! /bin/bash
###
 # @Descripttion: 
 # @version: 
 # @Author: Tao Chen
 # @Date: 2023-04-03 14:33:54
 # @LastEditors: Tao Chen
 # @LastEditTime: 2023-04-03 14:39:46
### 

USER=root
PUB_KEY='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvgg4VkabGgHClQdXAhLSCy04VejRmm/yeepRgs68eV4wnLJrZIuqY/zGVqqCB5NR9LuNcLx6AFORp2PJLFzDzeEQ0xHxe13bGt+P6nWKYfY4GQKbnKdWRAAPr9iEyyyqvSTV13bAcrBjEy5AHRt7T8pjAA6DG+OBayW4Yb/+B9GzZDdZ3hIK72uiN6whQKlWjmTcJSPfzUJrdGxq5QAKx4KBiJ1XHIAEm6XIgAK3TxwYC9cXqu1oGYoDpYZSvJ/J/K1YvrUde82uXUjkKj2ouIRu3CK9LDYbU2HqvIxe4OvD4sDMSezmZGcvPobODZOPCxBn3+tEoIT/PdbNl18v9'
SHELLN=/bin/zsh

if [ $USER != "root" ]; then
    HOME=/home/$USER
else
    HOME=/root
fi
SSH_DIR=$HOME/.ssh


AUTH_KEY_FILE=$SSH_DIR/authorized_keys

mkdir -p $SSH_DIR
echo $PUB_KEY >> $AUTH_KEY_FILE

# change authorized_keys permission to 600
chmod 600 $AUTH_KEY_FILE
chmod 700 $SSH_DIR
chown -R $NAME:$NAME $SSH_DIR