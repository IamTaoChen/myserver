
# Install Docker and Docker-Compose
ROOT_DIR=$(dirname $(realpath $0))
# Try to get the latest version of docker-compose
DC_VSESION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)

# if failed to get the latest version, use default version
if [ -z "$DC_VSESION" ]; then
    echo "Failed to get the latest version of docker-compose, using default version"
    DC_VSESION="v2.27.0"
fi

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

DOCKER_COMPOSE_EXIST=$(command -v docker-compose)
if [ -z "$DOCKER_COMPOSE_EXIST" ]; then
    echo "INSTALL DOCKER_COMPSE"
    DOCKER_COMPOSE_DOWNLOAD_URL="https://github.com/docker/compose/releases/download/$DC_VSESION/docker-compose-$(uname -s)-$(uname -m)"
    echo "DOCKER_COMPOSE_DOWNLOAD_URL: $DOCKER_COMPOSE_DOWNLOAD_URL"
    curl -L $DOCKER_COMPOSE_DOWNLOAD_URL -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
else
    echo "DOCKER-COMPOSE EXIST"
    # echo "REINSTALL DOCKER_COMPSE"
    # rm $(which docker-compose)
fi
