#!/bin/bash

servo="$(ps aux | grep "node servo.js" -w| wc -l)"
echo "${servo}"

if [ ${servo} -ne 2 ]
then
        cd /home/pi/oeildtre/pst3oeildtrearduino
        pwd
        /usr/local/bin/node servo.js
fi

