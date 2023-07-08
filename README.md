# ILIANA'S SOUNDPAD FOR LINUX

A collection of tools and scripts for using a standard wireless numpad as a music / sound / dj pad

This application allows you to use a standard external numpad as a dedicated and isolated input device for playing music or sounds, while leaving the other inputs devices (like keyboard or media remote) free to control the OS normally.

I use this to allow my kids to play music and sound effects I have pre-selected, at the volume I choose, while keeping them from messing up my media center.  This could be used to play sound effects transitions while streaming and recording, or even as a cheap DJ Launchpad.



## Standard Installation (Debian, Ubuntu, Mint)

* sudo apt install git
* git clone https://github.com/DrDecagon/ilianas-SoundPad.git
* cd ilianas-soundpad
* sh install.sh

After installation, there should be a shortcut on the desktop named Iliana's SP Playlist Tool. Run this to set sound lists for the numpad.



## Manual Installation (depreciated)

* Install the folowing dependancies: actkbd, mpv, socat, zenity
* Download the MInst.tar.xz release
* Extract the package
* modify the 70-hotkey-pad.rules file to match your numpad's device IDs and then copy it to /etc/udev/rules.d/
* add soundpad.sh to the list of startup applications (debian, ubuntu, etc) - OR -
  * run # crontab -e
  * then add "@reboot sh $HOME/Music/Keypad/soundpad.sh" without quotes
* Modify the $HOME/KeypadSB/soundpad.sh file to use your model of numpad. Run 'xinput list' to find device name. Look in /dev/input/by-id for device ID
  * xinput --disable 'keyboard:YOUR_DEVICE_NAME_HERE'
  * actkbd -D -q -c $HOME/KeypadSB/config/actkbd.conf -d /dev/input/by-id/YOUR_DEVICE_ID_HERE



## Attributions

Special thanks to
* Theodoros Kalamatianos https://github.com/thkala/actkbd
* mrb0nk500 https://github.com/mrb0nk500/actkbd 
* The Socat project http://www.dest-unreach.org/socat/
* The MPV project https://mpv.io/

Icons in the project were created by deemakdaksina - <a href="https://www.flaticon.com/free-icons/keypad" title="keypad icons">Flaticon</a> 

The file *sounds.tar.xz* contains content covered under Section 107 of the Copyright Act in the United States. See LICENSE for disclaimer.

The rest of this project is released under the terms of the BSD 3-Clause License
