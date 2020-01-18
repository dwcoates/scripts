#!/usr/bin/env bash

TMPFILE="$(mktemp -t screenshot-XXXXXXX).png"
OUTPUT="$HOME/Screenshots/$(date +%F-%H-%M-%S)"

notify-send "starting..."

read -r X Y W H G ID < <(slop -f "%x %y %w %h %g %i")
shutter --select="[$X,$Y,$W,$H]"

notify-send "Screenshot taken"

notify-send "size $(du -h $OUTPUT.gif | awk '{print $1}')"

eog $OUTPUT.gif

trap "rm -f '$TMPFILE'" 0
