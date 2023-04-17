#!/bin/bash
###
 # @Author: DevinChan DevinChan@fudan.edu.cn
 # @Date: 2022-11-19 17:51:16
 # @LastEditors: Tao Chen
 # @LastEditTime: 2023-04-04 12:02:08
 # @FilePath: \undefinedc:\Users\Devin\OneDrive\CodeStudy\install_docker.sh
 # @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
### 


curl -fsSL https://get.docker.com | bash -s docker 
# curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun


# sudo usermod -aG mri docker

# 下载docker-compose
curl -L "https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
&& chmod +x /usr/local/bin/docker-compose



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