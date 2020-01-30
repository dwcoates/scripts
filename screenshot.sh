#!/usr/bin/env bash

NAME="$(date +%F-%H-%M-%S).png"
OUTPUT="$HOME/Screenshots/$NAME"

read -r X Y W H G ID < <(slop -f "%x %y %w %h %g %i")
shutter --select="[$X,$Y,$W,$H]" --exit_after_capture --min_at_startup --output="$OUTPUT"

notify-send --icon=$OUTPUT --urgency=low "Screenshot taken" "size: $(du -h $OUTPUT | awk '{print $1}')\nname: $NAME"
