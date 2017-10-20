#!/bin/bash
#toggles, by order: monitor, audio, pointer, state

pts=/path/to/script
state=$(head -n 1 -c 3 "$pts"/monitor/state)

if grep -xq "on" "$pts"/monitor/state
then
	pactl set-sink-mute 0 1
	xrandr --output LVDS1 --off
	xinput disable 2
	echo off > "$pts"/monitor/state
else
	pactl set-sink-mute 0 0
	xrandr --output LVDS1 --auto
	xrandr --dpi 96
	xinput enable 2
	echo on > "$pts"/monitor/state
fi
