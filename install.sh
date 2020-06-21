#!/usr/bin/env bash

binary_path="$HOME/bin"
script_path="$(readlink -f $(dirname "$0"))/src"

echo "Adding scripts files to $binary_path: ${scripts[@]}"
for c in `ls "$script_path"`; do
    C=$(echo "$c" | sed -rn 's/(.*)\.sh/\1/p')
    P="$binary_path/$C"

    if [ -L ${P} ]; then
        echo "Removing old symlink: $C..."
        rm $P
    fi

    ln -s $script_path/$c $P
    echo "Added new symlink: $C."
done

read -p "Install dependencies (Y/n)? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Install shutter
    sudo add-apt-repository ppa:linuxuprising/shutter
    sudo apt install shutter
    sudo apt install xcape
fi
