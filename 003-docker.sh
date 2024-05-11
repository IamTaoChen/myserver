
# Install Docker and Docker-Compose

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
    curl -fsSL https://get.docker.com | bash -s docker
else
    echo "DOCKER EXIST"
fi

DOCKER_COMPOSE_EXIST=$(command -v docker-compose)
if [ -z "$DOCKER_COMPOSE_EXIST" ]; then
    echo "INSTALL DOCKER_COMPSE"
    curl -L "https://github.com/docker/compose/releases/download/$DC_VSESION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
else
    echo "DOCKER-COMPOSE EXIST"
    # echo "REINSTALL DOCKER_COMPSE"
    # rm $(which docker-compose)
fi
