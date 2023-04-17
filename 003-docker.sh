#!/bin/bash
###
 # @Descripttion: 
 # @version: 
 # @Author: Tao Chen
 # @Date: 2023-04-15 05:58:41
 # @LastEditors: Tao Chen
 # @LastEditTime: 2023-04-17 12:58:10
### 
DC_VSESION="v2.17.2"
function isCmdExist() {
	local cmd="$1"
  	if [ -z "$cmd" ]; then
		echo "Usage isCmdExist yourCmd"
		return 1
	fi

	which "$cmd" >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		return -1
	fi

	return 0
}

DOCKER_EXIST=$(isCmdExist docker)
DOCKER_COMPOSE_EXIST=$(isCmdExist docker-compose)

# install docker and docker-compose
if [ $DOCKER_EXIST -lt 0 ]; then
    echo "INSTALL DOCKER"   
    curl -fsSL https://get.docker.com | bash -s docker
else
    echo "DOCKER EXIST"
fi

if [ $DOCKER_EXIST -lt 0 ]; then
    echo "INSTALL DOCKER_COMPSE"
    curl -L "https://github.com/docker/compose/releases/download/$DC_VSESION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
else
    echo "DOCKER-COMPOSE EXIST"
    # echo "REINSTALL DOCKER_COMPSE"
    # rm $(which docker-compose)
fi



# curl -fsSL https://get.docker.com | bash -s docker 
# # curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun


# # sudo usermod -aG mri docker

# # 下载docker-compose
# curl -L "https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
# && chmod +x /usr/local/bin/docker-compose



# sudo docker run \
#             -d \
#             -p 8000:8000 \
#             -p 9000:9000 \
#             --name protainer \
#             --restart=always \
#             -v /var/run/docker.sock:/var/run/docker.sock \
#             -v /home/protainer/data:/data \
#             portainer/portainer-ce

# ufw allow 9000



# Remove the old-version Docker
# sudo apt-get remove docker \
#                     docker-engine \
#                     docker.io 


# # Update Source
# sudo apt-get update

# # Install some packages
# sudo apt-get -y install 
#      apt-transport-https \
#      ca-certificates \
#      curl \
#      gnupg \
#      lsb-release


# #Add GPG-key
# curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg


# # add docker-source into sources.list

# echo \
#   "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.aliyun.com/docker-ce/linux/debian \
#   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null



# # Install docker
# $ sudo apt-get update
# $ sudo apt-get install docker-ce docker-ce-cli containerd.io