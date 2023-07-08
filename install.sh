#!/bin/bash
# Iliana's Soundpad Install Script

# Install dependancies 
if command -v apt &> /dev/null; then
  sudo apt install zenity mpv socat git gcc make
  
elif command -v zenity &> /dev/null; then
  zenity --info --width 350 --title="Dependancies" --text="Install mpv, socat, git, make, and gcc via your package manager, Ubuntu Software Center, or from source.  Press OK once dependancies are installed"
  
else
  echo "Install zenity via your package manager, Ubuntu Software Center, or from source"
  sleep 5
  exit
  
fi

# Install actkbd
if command -v git &> /dev/null; then
  sudo rm -rf actkbd
  git clone https://github.com/mrb0nk500/actkbd.git
  cd actkbd
  make
  sudo make install
  cd ..
  
elif command -v zenity &> /dev/null; then
  zenity --info --width 300 --title="Install aptkbd" --text="Manually install aptkbd | https://github.com/mrb0nk500/actkbd"
  
else
  echo "Manually install actkbd | https://github.com/mrb0nk500/actkbd"
  sleep 3
  
fi

modprobe evdev

# make app home directory and required subdirectories
mkdir -p $HOME/KeypadSB/config/currentPlist

# extract demo files
tar -xf sounds.tar.xz --directory=$HOME/KeypadSB/

# Copy config files
cp ./config/* ~/KeypadSB/config/
chmod a+x ~/KeypadSB/config/plistTool.sh

# Choose device to be used
#while true; do 
#  aDev="/dev/input/by-id/$(zenity --list --title="Select keypad" --text="WARNING: this will BLOCK regular input from selected device" --hide-header --column="devices" $(ls /dev/input/by-id/) )"
#  cat $aDev
#  if zenity --question --title="Was this your keypad" --text="Did you see random characters when you pressed keys?" --default-cancel
#    then break
#  fi
#done

aDev="/dev/input/by-id/$(zenity --list --title="Select keypad" --text="WARNING: this will BLOCK regular input from selected device" --hide-header --column="devices" $(ls /dev/input/by-id/) )"
vID=$(udevadm info $aDev | grep -F 'ID_VENDOR_ID=' | cut -d'=' -f2)
pID=$(udevadm info $aDev | grep -F 'ID_MODEL_ID=' | cut -d'=' -f2)

if [ $XDG_SESSION_TYPE == "wayland" ]; then
  xincom="#xinput disable command not needed. System using wayland"
else
  xincom="xinput disable 'keyboard:$(udevadm info -a $aDev | grep -F -w 'ATTRS{name}==' | cut -d'"' -f2)'"
fi

# Create startup script
cat > $HOME/KeypadSB/soundpad.sh<< EOF
#!/bin/bash
# Disable keyboard via xinput entries into X
$xincom
# Run MPV with custom config listening to /tmp/mpvsocket
mpv --config-dir=$HOME/KeypadSB/config &
# Run actkbd on the choosen keyboard in daemon mode
actkbd -D -q -c $HOME/KeypadSB/config/actkbd.conf -d $aDev
EOF

chmod a+x ~/KeypadSB/soundpad.sh

# Create rule for keypad       !!!!!!! allow selection of keyboard
cat > 70-hotkey-pad.rules<< EOF
# /etc/udev/rules.d/70-hotkey-pad.rules
# Rules for numpad soundboard
ACTION=="add|change", \
SUBSYSTEMS=="usb", \
ATTRS{idVendor}=="$vID", \
ATTRS{idProduct}=="$pID", \
OWNER="$USER", \
ENV{LIBINPUT_IGNORE_DEVICE}="1"
EOF

sudo cp 70-hotkey-pad.rules /etc/udev/rules.d/

# Create desktop icon
cat > $HOME/Desktop/IlianaSP.desktop<< EOF
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=$HOME/KeypadSB/config/plistTool.sh
Name=Iliana's SP Playlist Tool
Comment=Iliana's soundpad playlist management tool
Icon=$HOME/KeypadSB/icon.png
EOF

gio set $HOME/Desktop/IlianaSP.desktop metadata::trusted true
chmod a+x $HOME/Desktop/IlianaSP.desktop

# Autostart Soundpad
mkdir $HOME/.config/autostart/

cat > $HOME/.config/autostart/soundpad.sh.desktop<< EOF
[Desktop Entry]
Type=Application
Exec=sh $HOME/KeypadSB/soundpad.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Iliana's Soundpad
Comment=Autostart Iliana's Soundpad application
EOF

echo Installation Complete!
