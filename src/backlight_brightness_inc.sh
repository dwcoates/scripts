#!/usr/bin/env bash

BRIGHTNESS_VALUE=`xrandr --verbose | grep -m 1 -i brightness | cut -f2 -d ' '`
OUTPUT_NAME=`xrandr -q | sed -n  "s/\(.*\) connected primary.*/\1/p"`
NEW_BRIGHTNESS=`bc -l <<< "${BRIGHTNESS_VALUE} + ${1}"`
MIN_BRIGHTNESS=0.25
MAX_BRIGHTNESS=1.0
CRITICAL_BRIGHTNESS=0.85 # Too high of a brightness is no bueno long-term for OLED displays

if (( `bc -l <<< "$NEW_BRIGHTNESS < $MIN_BRIGHTNESS"` )); then
    NEW_BRIGHTNESS=$MIN_BRIGHTNESS
elif (( `bc -l <<< "$NEW_BRIGHTNESS > $MAX_BRIGHTNESS"` )); then
    NEW_BRIGHTNESS=$MAX_BRIGHTNESS
else
    notify-send --urgency=low --hint=string:x-dunst-stack-tag:normal $(printf "Brightness: %.2f" $NEW_BRIGHTNESS)
fi

if (( `bc -l <<< "$NEW_BRIGHTNESS > $CRITICAL_BRIGHTNESS"` )); then
    notify-send --urgency=critical --hint=string:x-dunst-stack-tag:max "Warning: At very high brightness"
fi

# Set brightness
xrandr --output $OUTPUT_NAME --brightness $NEW_BRIGHTNESS
