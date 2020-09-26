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

echo "Creating suspend/resume script for capslock behavior..."
FIX_CAPS_COMMANDS="/usr/bin/setxkbmap -option ctrl:swapcaps && /usr/bin/xcape -e \'Control_L=Escape\'"

function add_fix_caps_on_login() {
    if ! grep -q $FIX_CAPS_COMMANDS "$1"; then
        echo $FIX_CAPS_COMMANDS >> "$1"
    fi
}

add_fix_caps_on_login $HOME/.bashrc
add_fix_caps_on_login $HOME/.bash_profile
add_fix_caps_on_login $HOME/.profile

# Fix caps on system resume
CAPS_SCRIPT="case \'\$1\' in\n    resume)\n\t\t$FIX_CAPS_COMMANDS\nesac\n"
CAPS_SCRIPT_PATH="/usr/lib/pm-utils/sleep.d/1000fix-capslock"
printf '#!/bin/bash\n\n' > /tmp/caps_script
printf "$CAPS_SCRIPT" >> /tmp/caps_script
sudo mv /tmp/caps_script $CAPS_SCRIPT_PATH

echo "Done."
