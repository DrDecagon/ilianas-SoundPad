# -----------------------------------------
# Iliana's Soundpad on Linux
- Linux setup for using a wireless numpad as a music / sound / dj pad
# -----------------------------------------
-
- Install the folowing dependancies
- actkbd, mpv, socat, zenity
-
- copy keyboard rule to /etc/udev/rules.d/70-hotkey-pad.rules
-
- To autostart:
- add soundpad.sh to the list of startup applications (debian, ubuntu, etc)
-
- -OR-
-
- run # crontab -e
- then add "@reboot sh $HOME/Music/Keypad/soundpad.sh" without quotes
