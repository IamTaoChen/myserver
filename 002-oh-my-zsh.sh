#!/bin/bash
###
 # @Descripttion: 
 # @version: 
 # @Author: Tao Chen
 # @Date: 2023-02-01 16:33:26
 # @LastEditors: Tao Chen
 # @LastEditTime: 2023-04-03 14:34:27
### 

plugin_list=(zsh-autosuggestions zsh-syntax-highlighting)
PRE_INSTALL=(zsh git)

add_plug(){
    sed -i "s/^plugins=(/plugins=(\n\t$1/g" ~/.zshrc
}

check_privileges() {
    if [ "$(id -u)" = "0" ]; then
        return 0  # root
    elif command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
        return 1  # sudo
    else
        return 2  # regular user
    fi
}

# Function to check if a list of programs is installed
check_programs_installed() {
    local programs=("$@")
    for program in "${programs[@]}"; do
        if ! command -v $program >/dev/null 2>&1; then
            echo "$program is not installed"
            return 1
        fi
    done
    echo "All programs are installed"
    return 0
}

install_programs() {
    local programs=("$@")
    local privileges=$(check_privileges)
    
    for program in "${programs[@]}"; do
        if ! command -v $program >/dev/null 2>&1; then
            echo "Attempting to install $program..."
            case $privileges in
                0) # root
                    # Choose the appropriate package manager for your system
                    # Debian, Ubuntu etc:
                    apt-get update && apt-get install $program
                    # Or for CentOS, RHEL etc:
                    # yum install $program
                    # Or for Fedora:
                    # dnf install $program
                    ;;
                1) # sudo
                    # Choose the appropriate package manager for your system
                    # Debian, Ubuntu etc:
                    sudo apt-get update && sudo apt-get install $program
                    # Or for CentOS, RHEL etc:
                    # sudo yum install $program
                    # Or for Fedora:
                    # sudo dnf install $program
                    ;;
                2) # regular user
                    echo "You need to be root or have sudo privileges to install software."
                    exit 1
                    ;;
            esac
        fi
    done
}


install_programs "${PRE_INSTALL[@]}"

git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh &&

cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc &&

PRIVILEGES=$(check_privileges)
ZSH_SHELL=$(which zsh)
case $PRIVILEGES in
    0)
        echo "User is root."
        chsh -s ${ZSH_SHELL}
        # usermod -s ${ZSH} ${USER}
        ;;
    1)
        echo "User has sudo privileges."
        sudo chsh -s ${ZSH_SHELL} $USER
        # Add operations to be performed if the user has sudo privileges here
        ;;
    2)
        echo "User is a regular user."
        sed -i "1iexport SHELL=${ZSH_SHELL}" ~/.bashrc
        sed -i "2iexec ${ZSH_SHELL} -l" ~/.bashrc
        ;;
esac


PLUGINS_LOCATION=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/
GIT_BASE=https://github.com/zsh-users

# zsh-autosuggestions
# git clone ${GIT_BASE}/zsh-autosuggestions ${PLUGINS}/zsh-autosuggestions

add_plug " "
add_plug sudo
add_plug z
for plugin in ${plugin_list[@]}
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