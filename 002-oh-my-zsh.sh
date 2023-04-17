#!/bin/bash
###
 # @Descripttion: 
 # @version: 
 # @Author: Tao Chen
 # @Date: 2023-02-01 16:33:26
 # @LastEditors: Tao Chen
 # @LastEditTime: 2023-04-03 14:34:27
### 

add_plug(){
    sed -i "s/^plugins=(/plugins=(\n\t$1/g" ~/.zshrc
}

plugin_list=(zsh-autosuggestions zsh-syntax-highlighting)

git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh &&

cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc &&


ZSH_SHELL=`which zsh`
chsh -s ${ZSH_SHELL}
# usermod -s ${ZSH} ${USER}
# sed -i "1iexport SHELL=/usr/bin/zsh" ~/.bashrc
# sed -i "2iexec /usr/bin/zsh -l" ~/.bashrc

PLUGINS_LOCATION=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/
GIT_BASE=https://github.com/zsh-users

# zsh-autosuggestions
# git clone ${GIT_BASE}/zsh-autosuggestions ${PLUGINS}/zsh-autosuggestions

add_plug " "
add_plug sudo
add_plug z
for plugin in ${plugin_list[@]}
#也可以写成for element in ${array[*]}
do
    git clone ${GIT_BASE}/${plugin} ${PLUGINS_LOCATION}/${plugin}
    add_plug ${plugin}
done


# plugins=()
# # sed -i 's/plugins=(/plugins=(\n\tzsh-autosuggestions/g' 
# add_plug zsh-autosuggestions

# # zsh-syntax-highlighting
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# add_plug zsh-syntax-highlighting
