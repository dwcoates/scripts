#!/usr/bin/env bash

BRIGHTNESS_VALUE=`xrandr --verbose | grep -m 1 -i brightness | cut -f2 -d ' '`
OUTPUT_NAME=`xrandr -q | sed -n  "s/\(.*\) connected primary.*/\1/p"`
NEW_BRIGHTNESS=`bc -l <<< "${BRIGHTNESS_VALUE} + ${1}"`

if (( `bc -l <<< "$NEW_BRIGHTNESS < 0.5"` )); then
    NEW_BRIGHTNESS=0.0
elif (( `bc -l <<< "$NEW_BRIGHTNESS > 1.0"` )); then
    NEW_BRIGHTNESS=1.0
    notify-send --urgency=critical --hint=string:x-dunst-stack-tag:max "At maximum brightness"
else
    notify-send --urgency=low --hint=string:x-dunst-stack-tag:normal $(printf "Brightness: %.2f" $NEW_BRIGHTNESS)
fi

# Set brightness
xrandr --output $OUTPUT_NAME --brightness $NEW_BRIGHTNESS
