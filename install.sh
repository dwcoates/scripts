#!/usr/bin/env bash

binary_path="$HOME/bin"
declare -a scripts=(screenshot.sh screencast.sh starbucks_wifi_connect.sh backlight_brightness_inc.sh)

echo "Adding scripts files to $binary_path: ${scripts[@]}"
for c in "${scripts[@]}"; do
    C=$(echo "$c" | sed -rn 's/(.*)\.sh/\1/p')
    P="$binary_path/$C"

    if [ -L ${P} ]; then
        echo "Removing old symlink: $C..."
        rm $P
    fi

    ln -s $(readlink -f $(dirname "$0"))/$c $P
    echo "Added new symlink: $C."
done

read -p "Install dependencies (Y/n)?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Install shutter
    sudo add-apt-repository ppa:linuxuprising/shutter
    sudo apt install shutter
fi
