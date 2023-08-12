#! /bin/bash
PUB_KEY='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvgg4VkabGgHClQdXAhLSCy04VejRmm/yeepRgs68eV4wnLJrZIuqY/zGVqqCB5NR9LuNcLx6AFORp2PJLFzDzeEQ0xHxe13bGt+P6nWKYfY4GQKbnKdWRAAPr9iEyyyqvSTV13bAcrBjEy5AHRt7T8pjAA6DG+OBayW4Yb/+B9GzZDdZ3hIK72uiN6whQKlWjmTcJSPfzUJrdGxq5QAKx4KBiJ1XHIAEm6XIgAK3TxwYC9cXqu1oGYoDpYZSvJ/J/K1YvrUde82uXUjkKj2ouIRu3CK9LDYbU2HqvIxe4OvD4sDMSezmZGcvPobODZOPCxBn3+tEoIT/PdbNl18v9'

ROOT_DIR=$(dirname $(realpath $0))
USER=$(whoami)
PUB_FILE="$ROOT_DIR/id_rsa.pub"

while getopts ":u:f:" opt; do
  case $opt in
    u) USER="$OPTARG";;
    f) PUB_FILE="$OPTARG";;
    \?) echo "Invalid option -$OPTARG" >&2;;
    :) echo "Option -$OPTARG requires an argument." >&2
       exit 1;;
  esac
done

echo "ROOT_DIR: $ROOT_DIR"
echo "USER: $USER"
echo "PUB_FILE: $PUB_FILE"

[ -f "$PUB_FILE" ] && PUB_KEY=$(cat $PUB_FILE)
echo "PUB_KEY: $PUB_KEY"

HOME_DIR=$(eval echo ~$USER)
echo "HOME_DIR: $HOME_DIR"

SSH_DIR="$HOME_DIR/.ssh"
AUTH_KEY_FILE="$SSH_DIR/authorized_keys"

mkdir -p $SSH_DIR

[ -f "$AUTH_KEY_FILE" ] || touch $AUTH_KEY_FILE

if grep -qFx "$PUB_KEY" "$AUTH_KEY_FILE"; then
    echo "PUB_KEY already in $AUTH_KEY_FILE"
else
    echo "$PUB_KEY" >> "$AUTH_KEY_FILE"
    echo "Added PUB_KEY to $AUTH_KEY_FILE"
fi

chmod 600 $AUTH_KEY_FILE
chmod 700 $SSH_DIR
chown -R $USER:$USER $SSH_DIR

sshd_config() {
    SSHD_CONFIG_PATH="/etc/ssh/sshd_config"
    NEED_RESTART=0

    if grep -q "^PubkeyAuthentication no" $SSHD_CONFIG_PATH; then
        NEED_RESTART=1
        sed -i 's/^PubkeyAuthentication no/PubkeyAuthentication yes/' $SSHD_CONFIG_PATH
        echo "Changed PubkeyAuthentication to yes in $SSHD_CONFIG_PATH"
    elif ! grep -q "^PubkeyAuthentication" $SSHD_CONFIG_PATH; then
        NEED_RESTART=1
        echo "PubkeyAuthentication yes" >> $SSHD_CONFIG_PATH
        echo "Added PubkeyAuthentication to $SSHD_CONFIG_PATH"
    fi

    if [ $NEED_RESTART -eq 1 ]; then
        if systemctl is-active --quiet sshd; then
            systemctl restart sshd && echo "Restarted sshd using systemctl"
        elif service --status-all | grep -Fq 'sshd'; then
            service sshd restart && echo "Restarted sshd using service"
        else
            echo "Failed to restart sshd."
            return 1
        fi
    fi
    return 0
}

run_sshd_config() {
    if [ "$(id -u)" = "0" ]; then
        sshd_config
    elif command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
        sudo bash -c "sshd_config"
    else
        if sshd_config; then
            echo "sshd_config changed. Please restart the sshd service as root or using sudo."
        fi
    fi
}

run_sshd_config