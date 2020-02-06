#!/bin/bash
#
# iCapture & iCaptureDuo
#
# Designed by Flex.
# Written by Flex from FleXoft.
#   (flex@fleischmann.hu)
#
# Original idea came from: kkovacs  | http://www.kkovacs.hu/item/1426
#
# v1.02, 2018.05.23. Budapest, FleXoft
#	Chg: codebrush and HD Ready ;-)
#	Upd: old links
#
# v1.01, 2008.05.22. Budapest, FleXoft
#    Add:    dual monitor support
#
# v1.00, 2007.05.05. Budapest, FleXoft
#    Rls:    first release
#
# Requirements:
# -------------
#
#                imagesnap   |	download it from https://github.com/rharder/imagesnap, compile and put somewhere in the PATH           
#													or
#								https://github.com/FleXoft/imagesnap for macOS Catalina support
#
#                imagemagick | 	brew install ImageMagick
#
#
# Documentation:
# --------------
#
#  -
#
#
# TODO:
# -----
#
#  -
#
#
# =========================================================================
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; see the file COPYING.  If not, write to
# the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
#
# *************************************************************************
#
#       XXXXXXX    XXX             XXX XXX             XXX       X
#        XX   X     XX              XX XX             XX XX     XX
#        XX X       XX     XXXXX     XXX      XXXX    XX       XXXXX
#        XXXX       XX    XX    X     X      XX  XX  XXXXX      XX
#        XX X       XX    XXXXXXX    XXX     XX  XX   XX        XX
#        XX         XX    XX        XX XX    XX  XX   XX        XX XX
#       XXXX       XXXX    XXXXX   XXX XXX    XXXX   XXXX        XXX
#
# *************************************************************************

echo "░▀█▀░█▀▀░█▀█░█▀█░▀█▀░█░█░█▀▄░█▀▀░░░░█▀▀░█░█"
echo "░░█░░█░░░█▀█░█▀▀░░█░░█░█░█▀▄░█▀▀░░░░▀▀█░█▀█"
echo "░▀▀▀░▀▀▀░▀░▀░▀░░░░▀░░▀▀▀░▀░▀░▀▀▀░▀░░▀▀▀░▀░▀"

# Variables
sleepTime=120	# wait 120s

#
pwd=$(pwd)

# set lastNumberFilename
lastNumberFilename=$pwd/capture.last.number

#
# Create temporary filename variables
#
iSightFilename=$pwd/tmp\_iSight.jpg
screenshotFilename1=$pwd/tmp\_screenshot_1.jpg
screenshotFilename2=$pwd/tmp\_screenshot_2.jpg

# Load counter if already exist or set it to 1
if [ -f $lastNumberFilename ]; then
	fileCounter=`cat $lastNumberFilename`
else
	fileCounter=1
fi

# main(); Loop forever...
while true; do

	if [ ! -f pause ]; then # Skip if "pause" file exists

    	# Print counter
    	filename=`printf "%06g" $fileCounter`
    	echo -n "[$filename]"

	    #
	    # Capture pictures from iSight camera and from the screens (2 screens only!)
	    #
	    echo -n ", capturing (1, "
	    imagesnap -w 2 $iSightFilename > /dev/null 2>&1
	    echo -n "2, "
	    screencapture -T0 -x -tjpg "$screenshotFilename1" "$screenshotFilename2" > /dev/null 2>&1
	   
	    # Do it if at least $iSightFilename and one $screenshotFilename exist
	    if [ -f $iSightFilename ] && [ -f $screenshotFilename1 ]; then
  		
	    	if [ ! -f "$screenshotFilename2" ]; then  
	    	
	    		echo -n "?)"
	    		convert -size 1920x1080 xc:black "$screenshotFilename2"
	    	
	    	else
	    	
	    		echo -n "3)"	
	    	
	    	fi

			#
			# Picture manipulations...
			#
			echo -n ", manipulating (1, "
			convert -geometry x360 -border 10x13 -bordercolor \#000000 "$iSightFilename" "$iSightFilename"
			echo -n "2, "
			convert -geometry x360 -border 10x13 -bordercolor \#000000 "$screenshotFilename1" "$screenshotFilename1"
			echo -n "3, "
			convert -geometry x360 -border 10x13 -bordercolor \#000000 "$screenshotFilename2" "$screenshotFilename2"
			echo -n "4)"
			convert +append "$iSightFilename" "$screenshotFilename1" "$screenshotFilename2" "$pwd/$filename"\_final.jpg

			# and delete the temporary files
			rm "$iSightFilename" "$screenshotFilename1" "$screenshotFilename2"

			#
			# Next filenumber
			#
			fileCounter=`expr $fileCounter + 1`
			#
			# Save last number
			#
			echo $fileCounter > $lastNumberFilename

    	else
    
      		echo -n "No screen???, ScreenSaver or Screen is disabled. Bzzz..."
      
    	fi
    
	else
  
    	echo -n "Skip toggle ON, pause file exists!!!"
    
  	fi

	#
	# Wait a bit and do it again and again...
	#
	echo ", sleep..."
	sleep $sleepTime

done