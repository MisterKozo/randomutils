#!/bin/bash

################################################
# This is a small bash script that automatically pulls files from an Android device with ADB enabled upon connection
# You can do this with MTP too
################################################

extensions=( "jpg" "png" "gif" "txt" )
directories=( "/sdcard/DCIM/Screenshots" "/sdcard/dirIdontCareFor" )

found=-2

while true
do

	if adb get-state 1>/dev/null 2>&1
	then

		if [[ $found == 0 || $found == -2 ]]
		then

			echo "Device found! Pulling..."

			timestamp=$(date +%s)
			mkdir $timestamp

			for ext in "${extensions[@]}"
			do

				for dir in "${directories[@]}"
				do

					for file in $(adb shell ls $dir | grep '.'$ext'$')
					do

						file=$(echo -e $file | tr -d "\r\n")
						adb pull $dir/$file $timestamp/$file

					done

				done

			done

#			HOST_DIR=$timestamp
#			DEVICE_DIR=/sdcard/dirIdontCareFor
#			EXTENSION=".png"
#
#			for file in $(adb shell ls $DEVICE_DIR | grep $EXTENSION'$')
#			do
#
#				file=$(echo -e $file | tr -d "\r\n")
#				adb pull $DEVICE_DIR/$file $HOST_DIR/$file
#
#			done
#
#			EXTENSION=".jpg"
#			for file in $(adb shell ls $DEVICE_DIR | grep $EXTENSION'$')
#			do
#
#				file=$(echo -e $file | tr -d "\r\n")
#				adb pull $DEVICE_DIR/$file $HOST_DIR/$file
#
#			done

			found=1

			echo "Done transferring! Please disconnect the device..."

		fi


	else

		if [[ $found == -2 ]]
		then
			found=-1
		fi

		if [[ $found == -1 ]]
		then

			echo "Waiting for device..."
			found=0

		fi

		if [[ $found == 1 ]]
		then

			echo "Device disconnected."
			found=-1

		fi

	fi

done
