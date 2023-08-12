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

add_plug() {
    PLUGIN=$1
    ZSHRC_PATH="$HOME/.zshrc"

    # check if plugin is already defined
    PLUGIN_EXISTS=$(awk -v plugin="$PLUGIN" '
    BEGIN { found = 0; in_plugins = 0; }
    /plugins=\(/ { in_plugins = 1; }
    in_plugins && /\)/ { in_plugins = 0; }
    in_plugins && $0 ~ plugin { found = 1; exit; }
    END { print found }
    ' $ZSHRC_PATH)

    if [ "$PLUGIN_EXISTS" = "1" ]; then
        echo "Plugin $PLUGIN is already defined."
        return
    fi

    # add plugin to .zshrc
    awk -v plugin="$PLUGIN" '
    /plugins=\(/ { print; print "\t" plugin; next; }
    { print; }
    ' $ZSHRC_PATH > "${ZSHRC_PATH}.tmp" && mv "${ZSHRC_PATH}.tmp" $ZSHRC_PATH

    echo "Plugin $PLUGIN added successfully."
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
    check_privileges
    local privileges=$?
    
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

git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && \
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \

check_privileges
PRIVILEGES=$?
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
