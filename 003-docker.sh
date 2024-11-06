#!/bin/bash

set -e

# Install Docker and Docker-Compose
ROOT_DIR=$(dirname $(realpath $0))

DOCKER_EXIST=$(command -v docker)
if [ -z "$DOCKER_EXIST" ]; then
    echo "INSTALL DOCKER"   
    # try to install docker using official script
    if ! curl -fsSL https://get.docker.com | bash -s docker; then
        echo "Failed to install Docker using official script, try to install Docker using aliyun mirror."
        # try to install docker using aliyun mirror
        if ! bash $ROOT_DIR/scripts/get-docker.sh --mirror Aliyun; then
            echo "Failed to install Docker using aliyun mirror, exit."
            exit 1
        else
            echo "Docker installed using aliyun mirror."
        fi
    fi
else
    echo "DOCKER EXIST"
fi

echo "Alias Docker Compose"
ALIAS_DC_FILE="$HOME/.docker_aliases"
cat << EOF > $ALIAS_DC_FILE
# Aliases for Docker Compose
alias dc='docker compose'
alias dcp='docker compose ps -a'
alias dcu='docker compose up'
alias dcud='docker compose up -d'
alias dcd='docker compose down'
alias dcs='docker compose stop'
alias dcrm='docker compose rm'
alias dcr='docker compose restart'
alias dcl='docker compose logs'
EOF

RC_APPEND="[ -f $ALIAS_DC_FILE ] && source $ALIAS_DC_FILE"

echo "$RC_APPEND" >> ~/.zshrc
echo "$RC_APPEND" >> ~/.bashrc


echo "Install Docker finlish"