#!/bin/bash
# Playlist tool

prgdir=$HOME/KeypadSB
confdir=$prgdir/config
IFS=$'\t\n'

while true; do # Start prompt
  resp=$(zenity --info --no-wrap --window-icon=$confdir/PTicon.png --icon-name=audio-x-generic --title="Iliana's Soundpad - Playlist Tool" --text="Choose a playlist or create a new one?" --ok-label="Select" --extra-button="Create" --extra-button="Modify" --extra-button="Delete"); xv=$? # prompt for 4 actions or exit, ok and exit are "non-responses"

  if test -z "$resp"; then # if a response is NOT detected
    if [ $xv = 1 ]; then # check exit code - if window was closed
      echo exiting
      exit
    elif [ $xv = 0 ]; then # check exit code - if "select" was selected (OK button)
      spldir="$confdir/savedPlists/$(zenity --list --title="Playlist Selection" --text="Select a playlist" --hide-header --column="Playlists" $(ls $confdir/savedPlists/) )"; xc=$?
      if [ $xc = 1 ]; then continue; fi # if cancelled or closed, jump to start
      rm $confdir/currentPlist/* # remove contents of current playlist
      IFS=$' \t\n'
      find "$spldir" -maxdepth 1 -type l -printf "%f\n" | cat -n | while read num fn; do cp -Pf "$spldir/$fn" "$confdir/currentPlist/$num.lnk"; done # copy all playlist symlinks to current playlist with numbered names
      IFS=$'\t\n'
      cp -P -f $spldir/stopsnd/* $confdir/currentPlist/0.lnk # copy stop sound to 0.lnk symlink
      continue # jump to start
    else # if exit code is nonstandard (eg. 127) 
      echo Exit code error - ensure Zenity is installed!
      sleep 2
      exit
    fi
    
  elif [ $resp = Modify ]; then # if "modify" is selected
    spldir="$confdir/savedPlists/$(zenity --list --title="Playlist Selection" --text="Select a playlist to modify" --hide-header --column="Playlists" $(ls $confdir/savedPlists/) )"; xc=$? # prompt for playlist selection
    if [ $xc = 1 ]; then continue; fi # jump to start if cancelled or closed
    rm $spldir/*; rm $spldir/stopsnd/* # clear existing playlist
       
  elif [ $resp = Create ]; then  # if "create" is selected
    spldir="$confdir/savedPlists/$(zenity --entry --title="Name new playlist")"; xc=$? # prompt for a new name
    if [ $xc = 1 ]; then continue; fi # jump to start if cancelled or closed
    mkdir -p "$spldir/stopsnd/" # create new playlist directory
    
  elif [ $resp = Delete ]; then  # if "delete" is selected
    spldir="$confdir/savedPlists/$(zenity --list --title="Playlist Selection" --text="Select a playlist to delete" --hide-header --column="Playlists" $(ls $confdir/savedPlists/) )"; xc=$? # prompt for playlist selection
    if [ $xc = 1 ]; then continue; fi # go back to start if cancelled or closed
    if zenity --width=300 --title="Delete this playlist?" --question --text="Are you sure you want to delete $spldir" --default-cancel; then # double check with user
      rm -r $spldir/ # delete selected playlist and contents
    fi
    continue  # jump to start
    
  else # if selection error
    echo VariableError
    sleep 2
    exit

  fi

  srcdir=$HOME/Music   
  for n in {1..17}; do # run 17 cycles starting with 1
    sndsel=$(zenity --filename="${srcdir}/" --title="Select sound file $n" --file-selection); xc=$?
    if [ $xc = 1 ]; then # if cancelled
      zenity --warning --width=300 --title="Playlist incomplete" --text="The selected playlist is incomplete. You must modify this playlist again." # show warning
      break
    fi
    ln -sf "$sndsel" $spldir/ # create link for selected sound file
    srcdir="$(dirname "${sndsel}")" # set current location for next prompt
  done
  
  if zenity --title="Stop sound" --question --text="Use the default stop sound of choose a custom one?" --ok-label="Custom" --cancel-label="Default" --default-cancel  # if "custom" stop sound is selected
    then
    sndsel="$(zenity --filename="${prgdir}/sounds/" --title="Select stop sound" --file-selection)"; xc=$? # prompt for file
    if [ xc != 1 ]; then # if not cancelled
      cp -s "$sndsel" $spldir/stopsnd/ # copy chosen sound
      continue # jump to start prompt
    fi 
  fi
  cp -s $prgdir/sounds/misc/StopDJ.ogg $spldir/stopsnd/ # copy default stop sound
  continue  # jump to start prompt

done

echo BottomOfScriptError # should never get here
sleep 2
exit
