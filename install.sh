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

# Create startup script        !!!!!!! choose dev input
cat > $HOME/KeypadSB/soundpad.sh<< EOF
#!/bin/bash
# Disable keyboard char entries into X
xinput --disable 'keyboard:2.4G Mouse'
# Run MPV with custom config listening to /tmp/mpvsocket
mpv --config-dir=$HOME/KeypadSB/config &
# Run actkbd on the choosen keyboard in daemon mode
actkbd -D -q -c $HOME/KeypadSB/config/actkbd.conf -d /dev/input/by-id/usb-1ea7_2.4G_Mouse-event-kbd
EOF

chmod a+x ~/KeypadSB/soundpad.sh

# Create rule for keypad       !!!!!!! allow selection of keyboard
rm 70-hotkey-pad.rules
cat > 70-hotkey-pad.rules<< EOF
# /etc/udev/rules.d/70-hotkey-pad.rules
# Rules for numpad soundboard
ATTRS{idVendor}=="1ea7",
ATTRS{idProduct}=="0066",
OWNER="$USER"
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
Exec=$HOME/KeypadSB/soundpad.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Iliana's Soundpad
Comment=Autostart Iliana's Soundpad application
EOF

echo Installation Complete!
