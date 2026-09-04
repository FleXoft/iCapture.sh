#!/bin/bash
# iCapture & iCaptureDuo - Tuned Edition 2026

# Beállítások
sleepTime=120
lastNumberFilename="$PWD/capture.last.number"

# Takarítás kilépéskor
trap "rm -f /tmp/tmp_iSight.jpg /tmp/tmp_screenshot_*.jpg; exit" SIGINT SIGTERM

# Számláló betöltése
[[ -f "$lastNumberFilename" ]] && fileCounter=$(cat "$lastNumberFilename") || fileCounter=1

echo "░▀█▀░█▀▀░█▀█░█▀█░▀█▀░█░█░█▀▄░█▀▀░░░░█▀▀░█░█"
echo "░░█░░█░░░█▀█░█▀▀░░█░░█░█░█▀▄░█▀▀░░░░▀▀█░█▀█"
echo "░▀▀▀░▀▀▀░▀░▀░▀░░░░▀░░▀▀▀░▀░▀░▀▀▀░▀░░▀▀▀░▀░▀"

while true; do
    if [[ ! -f pause ]]; then
        filename=$(printf "%010g" $fileCounter)
        echo -n "[$filename] capturing... "

        # Capture - temp mappába a lemez kímélése érdekében
        imagesnap -w 2 /tmp/tmp_iSight.jpg > /dev/null 2>&1
        screencapture -T0 -x -t jpg /tmp/tmp_screenshot_1.jpg /tmp/tmp_screenshot_2.jpg > /dev/null 2>&1

		if [[ -f /tmp/tmp_iSight.jpg && -f /tmp/tmp_screenshot_1.jpg ]]; then
            [[ ! -f /tmp/tmp_screenshot_2.jpg ]] && magick -size 1920x1080 xc:black /tmp/tmp_screenshot_2.jpg

            echo -n "manipulating... "

            # Egy sorban, hogy a Bash ne zavarodjon össze a sortöréseken
            magick \( /tmp/tmp_iSight.jpg -geometry x360 -border 10x13 -bordercolor black \) \( /tmp/tmp_screenshot_1.jpg -geometry x360 -border 3x13 -bordercolor black \) \( /tmp/tmp_screenshot_2.jpg -geometry x360 -border 10x13 -bordercolor black \) +append "$PWD/${filename}_final.jpg"

            rm -f /tmp/tmp_iSight.jpg /tmp/tmp_screenshot_*.jpg
            ((fileCounter++))
            echo $fileCounter > "$lastNumberFilename"
            echo "done."
        else
            echo "Error: Capture failed (ScreenSaver active?)"
        fi
    else
        echo "Paused - 'pause' file exists."
    fi

    sleep $sleepTime
done