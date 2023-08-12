#!/bin/bash

# Constants
# you can change the following lines
PRE_INSTALL=(zsh git)
PLUGIN_LIST=(zsh-autosuggestions zsh-syntax-highlighting)
# you should not change the following lines
ZSHRC_PATH="$HOME/.zshrc"
PLUGINS_LOCATION=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/
GIT_BASE="https://github.com/zsh-users"

# Functions
# define a fucntion to check your privileges
check_privileges() {
    if [ "$(id -u)" = "0" ]; then
        echo "root"
    elif command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
        echo "sudo"
    else
        echo "regular"
    fi
}


install_programs() {
    local programs=("$@")
    local privileges=$(check_privileges)
    
    for program in "${programs[@]}"; do
        if ! command -v $program >/dev/null 2>&1; then
            echo "Attempting to install $program..."
            case $privileges in
                "root")
                    apt-get update && apt-get install $program
                    ;;
                "sudo")
                    sudo apt-get update && sudo apt-get install $program
                    ;;
                "regular")
                    echo "You need to be root or have sudo privileges to install software."
                    exit 1
                    ;;
            esac
        fi
    done
}

add_plug() {
    PLUGIN=$1

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
    BEGIN { added=0 }
    /plugins=\(/ {
        sub(/\)/, " " plugin " &")
        added=1
    }
    { print; }
    END {
        if (added == 0) {
            print "plugins=(" plugin ")"
        }
    }
    ' $ZSHRC_PATH > "${ZSHRC_PATH}.tmp" && mv "${ZSHRC_PATH}.tmp" $ZSHRC_PATH

    echo "Plugin $PLUGIN added successfully."
}



# Main Script Execution
PRIVILEGES=$(check_privileges)

install_programs "${PRE_INSTALL[@]}"

if ! [ -d "$HOME/.oh-my-zsh" ]; then
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh || {
        echo "Failed to clone oh-my-zsh repository. Exiting..."
        exit 1
    }
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
fi

# Change default shell to zsh
ZSH_SHELL=$(which zsh)
case $PRIVILEGES in
    "root")
        chsh -s ${ZSH_SHELL}
        ;;
    "sudo")
        sudo chsh -s ${ZSH_SHELL} $USER
        ;;
    "regular")
        BASHRC="$HOME/.bashrc"
        # Check if ~/.bashrc exists, if not, create it
        [ ! -f $BASHRC ] && touch $BASHRC

        # Check if the line exists, if not, prepend it
        if ! grep -Fxq "export SHELL=${ZSH_SHELL}" $BASHRC; then
            # Backup original .bashrc
            cp $BASHRC "$BASHRC.backup"

            # Prepend lines to the beginning and write the content back to .bashrc
            echo -e "export SHELL=${ZSH_SHELL}\nexec ${ZSH_SHELL} -l" > $BASHRC
            cat "$BASHRC.backup" >> $BASHRC

            # Remove the backup file (optional)
            rm "$BASHRC.backup"
        fi
        ;;
esac



# Install Plugins and Add to .zshrc
add_plug " "
add_plug sudo
add_plug z
for plugin in "${PLUGIN_LIST[@]}"; do
    if ! [ -d "${PLUGINS_LOCATION}/${plugin}" ]; then
        git clone ${GIT_BASE}/${plugin} ${PLUGINS_LOCATION}/${plugin} || {
            echo "Failed to clone ${plugin}. Continuing..."
            continue
        }
    fi
    add_plug ${plugin}
done