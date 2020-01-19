#!/usr/bin/env bash

binary_path="$HOME/bin"
declare -a scripts=(screenshot.sh screencast.sh starbucks_wifi_connect.sh)

echo "Adding scripts files to $binary_path: ${scripts[@]}"
for c in "${scripts[@]}"; do
    C=$(echo "$c" | sed -rn 's/(.*)\.sh/\1/p')
    P="$binary_path/$C"

    if [ -L ${P} ]; then
        echo "Removing old symlink: $C"
        rm $P
    fi

    ln -s $(dirname "$0")/$c $P
done
