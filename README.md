# -------------------------- 
#Iliana's Soundpad on Linux
Linux setup for using a wireless numpad as a music / sound / dj pad
# --------------------------

install the folowing dependancies
actkbd, mpv, socat

copy keyboard rule to /etc/udev/rules.d/70-hotkey-pad.rules
copy actkbd config file to /etc/actkbd.conf

run "crontab -e" without quotes
then add "@reboot sh $HOME/Music/Keypad/soundpad.sh" without quotes
