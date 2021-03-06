#!/bin/bash

TMPFILE="$(mktemp -t screencast-XXXXXXX).mkv"
OUTPUT="$HOME/Screenshots/$(date +%F-%H-%M-%S)"

read -r X Y W H G ID < <(slop -f "%x %y %w %h %g %i")
ffmpeg -f x11grab -s "$W"x"$H" -i ":1+$X,$Y" "$TMPFILE"

ffmpeg -y -i "$TMPFILE"  -vf fps=10,palettegen /tmp/palette.png
ffmpeg -i "$TMPFILE" -i /tmp/palette.png -filter_complex "paletteuse" $OUTPUT.gif
mv $TMPFILE $OUTPUT.mkv

notify-send "Screencast finished" "size $(du -h $OUTPUT.gif | awk '{print $1}')"

eog $OUTPUT.gif

trap "rm -f '$TMPFILE'" 0
