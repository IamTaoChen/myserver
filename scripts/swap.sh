#!/bin/bash
# example
# ./swap.sh [MODE] [SIZE] [SWAP_PATH] [BLOCK_SIZE]
#   Add 2GB
# ./swap.sh add_swap 2
# ./swap.sh del_swap


MODE=$1

# Function to get the default swap file path
function default_swap_path() {
    if [ -z "$1" ]; then
        echo "/var/swap"
    else
        echo "$1"
    fi
}

# Function to get the default swap size in GB
function default_size() {
    if [ -z "$1" ]; then
        echo 4
    else
        echo "$1"
    fi
}

# Function to get the default block size in bytes
function default_block_size() {
    if [ -z "$1" ]; then
        echo 512
    else
        echo "$1"
    fi
}

# Function to format the fstab entry for the swap
function fstab_entry() {
    local swap_path=$(default_swap_path "$1")
    echo -e "$swap_path\tswap\tswap\tdefaults\t0\t0"
}

# Function to calculate the count for 'dd' based on size and block size
function calculate_count() {
    local size_gb=$(default_size "$1")
    local block_size=$(default_block_size "$2")
    echo $((size_gb * 1024 * 1024 * 1024 / block_size))
}

# Function to delete the swap file
function delete_swap() {
    local swap_path=$(default_swap_path "$1")
    swapoff "$swap_path"
    rm -rf "$swap_path"
    local fstab_entry_text=$(fstab_entry "$swap_path" | sed 's/\//\\\//g')
    sed -i "0,/$fstab_entry_text/{//d}" /etc/fstab
    echo "Swap file $swap_path deleted successfully."
}

# Function to add a new swap file
function add_swap() {
    local size_gb=$(default_size "$1")
    local block_size=$(default_block_size "$2")
    local swap_path=$(default_swap_path "$3")
    local count=$(calculate_count "$size_gb" "$block_size")

    echo "Creating swap file of size ${size_gb}G at $swap_path with block size $block_size..."
    dd if=/dev/zero of="$swap_path" bs="$block_size" count="$count" status=progress
    mkswap "$swap_path"
    chmod 0600 "$swap_path"
    swapon "$swap_path"

    local fstab_entry_text=$(fstab_entry "$swap_path")
    echo "$fstab_entry_text" >> /etc/fstab
    echo "Swap file $swap_path added and activated."
}

# Set default mode if not provided
if [ -z "$MODE" ]; then
    MODE="add_swap"
fi

# Main logic for adding or deleting swap
case "$MODE" in
    add_swap|a|A|add)
        size=$(default_size "$2")
        swap_path=$(default_swap_path "$3")
        block_size=$(default_block_size 512)
        echo "Adding swap: ${size}G at $swap_path"
        add_swap "$size" "$block_size" "$swap_path"
        ;;
    del_swap|d|D|del)
        echo "Deleting swap: $2"
        delete_swap "$2"
        ;;
    *)
        echo "Invalid mode specified. Use 'add_swap' to add or 'del_swap' to delete."
        ;;
esac
