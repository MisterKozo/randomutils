#!/bin/bash

function merge {
  source=$1
  dest=$2

  if [ ! -d "$dest"  ]; then
    mkdir $dest
  fi

  mv -n "$source"/* $dest
  for f in "$source"/*
  do
    filename=$(basename "$f")
    extension="${filename##*.}"
    filename="${filename%.*}"

    #file or folder has an extension
    echo "$source"/"$filename"."$extension"

    if [  -f "$source"/"$filename"."$extension"  ]; then
      mv -n $f "$dest"/"$(date +%s)"."$filename"."$extension"
    fi
    if [  -d "$source"/"$filename"."$extension"  ]; then
      merge $f "$dest"/"$filename"."$extension"
      #rm -rf $f
    fi

    #file or folder has no extension
    if [ ! -f "$source"/"$filename"."$extension"  ] && [ ! -d "$source"/"$filename"."$extension"  ]; then
      if [  -f $f  ]; then
        mv -n $f "$dest"/"$(date +%s)"."$filename"
      fi
      if [  -d $f  ]; then
        merge $f "$dest"/"$filename"
        #rm -rf $f
      fi
    fi
  done
}

merge $1 $2

# If a filename is already present, the copied file will look like this:
# /path/to/EPOCHTIME.filename<.extension if applies>

#-------------------------------
# A nice little implementation:
# For each folder in the array, merge respective folder in your SD card
# I use this combined with Tasker and it's run automatically every day at night
#-------------------------------

#Android implementation (change the paths to your liking

#internal=/sdcard
#external=/storage/externalsd
#
#folders=( "Download" "Telegram" "WhatsApp" "Kik" "oandbackups" )
#
#for i in "${folders[@]}"
#do
#  merge "$internal"/"$i" "$external"/"$i"
#done
