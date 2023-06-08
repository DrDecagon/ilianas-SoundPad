#!/bin/bash

# Disable keyboard char entries into X
xinput --disable 'keyboard:2.4G Mouse'

# Make a fifo pipe file for swapping playlists (depreciated)
## mkfifo /tmp/soundboardfifo

# Run MPV with custom config listening to /tmp/mpvsocket
mpv --config-dir=$HOME/Music/Keypad/config &

# Run actkbd on the choosen keyboard
actkbd -D -q -c ~/Music/Keypad/config/actkbd.conf -d /dev/input/by-id/usb-1ea7_2.4G_Mouse-event-kbd
