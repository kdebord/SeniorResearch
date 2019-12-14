#!/bin/bash

# $1 = Satellite Name
# $2 = frequency
# $3 = filename base
# $4 = tle file
# $5 = epoc start time
# $6 = time to capture

#create folder for passes
NOW=$(date +%m-%d-%Y_%H-%M)
mkdir /home/pi/weather/${NOW}



sudo timeout $6 rtl_fm -f ${2}M -s 60k -g 45 -p 55 -E wav -E deemp -F 9 - | sox -traw -r60k -es -b16 - $3.wav rate 11025

PassStart=`expr $5 + 90`

if [ -e $3.wav ]
	then
		/usr/local/bin/wxmap -T "${1}" -H $4 -p 0 -l 4 -o $PassStart ${3}-map.png
		/usr/local/bin/wxtoimg -m ${3}-map.png -e ZA $3.wav $3.png
		/usr/local/bin/wxtoimg -m ${3}-map.png -e NO $3.wav $3.NO.png
		/usr/local/bin/wxtoimg -m ${3}-map.png -e MCIR $3.wav $3.MCIR.png
		/usr/local/bin/wxtoimg -m ${3}-map.png -e MSA $3.wav $3.MSA.png

fi

cp /home/pi/weather/*.png /home/pi/weather/${NOW}/
# rm /home/pi/weather/${NOW}/*-map.png
# rm /home/pi/weather/*.pngrm /home/pi/weather/*.wav
