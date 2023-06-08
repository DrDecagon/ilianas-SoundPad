# ILIANA'S SOUNDPAD FOR LINUX

A collection of tools and scripts for using a wireless numpad as a music / sound / dj pad

This application allows you to use a standard external numpad as a dedicated and isolated input device for playing music or sounds, while leaving the other inputs devices (like keyboard or media remote) free to control the OS normally.

I use this to allow my kids to play music and sound effects I have pre-selected, at the volume I choose, while keeping them from messing up my media center.  This could be used to play sound effects transitions while streaming and recording, or even as a cheap DJ Launchpad.



## Standard Installation

* Download this repo -OR-
  * git clone https://github.com/DrDecagon/ilianas-SoundPad.git
* open the newly created directory
* run ./installer.sh

After installation, there should be a shortcut on the desktop named IlianaSP. Run this to set sound lists for a standard 17 button numpad.

You may have to manually modify /etc/udev/rules.d/70-hotkey-pad.rules to include your device ID.
You may have to manually modify the $HOME/KeypadSB/soundpad.sh file to use your model of numpad. The following lines will need to be tweaked:
  * xinput --disable 'keyboard:2.4G Mouse'
  * actkbd -D -q -c $HOME/KeypadSB/config/actkbd.conf -d /dev/input/by-id/usb-1ea7_2.4G_Mouse-event-kbd

I plan to implement a selector for these last 2 steps in the future.



## Manual Installation (depreciated)

* Download the MInst.tar.xz release
* Install the folowing dependancies: actkbd, mpv, socat, zenity
* modify the 70-hotkey-pad.rules file to match your numpad's device IDs and then copy it to /etc/udev/rules.d/
* add soundpad.sh to the list of startup applications (debian, ubuntu, etc) - OR -
  * run # crontab -e
  * then add "@reboot sh $HOME/Music/Keypad/soundpad.sh" without quotes



## Attributions

Special thanks to
* Theodoros Kalamatianos https://github.com/thkala/actkbd
* mrb0nk500 https://github.com/mrb0nk500/actkbd 

and the following open source projects
* http://www.dest-unreach.org/socat/
* https://mpv.io/

Icons in the project were created by deemakdaksina - <a href="https://www.flaticon.com/free-icons/keypad" title="keypad icons">Flaticon</a> 

The file *sounds.tar.xz* contains content covered under Section 107 of the Copyright Act in the United States. 

The rest of this project is released under the terms of the BSD 3-Clause License
