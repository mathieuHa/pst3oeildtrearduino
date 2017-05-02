#!/bin/bash

app="$(ps aux | grep "node app.js" -w| wc -l)"
echo "${app}"

if [ ${app} -ne 2 ]
then
        cd /home/pi/oeildtre/pst3oeildtrearduino
        pwd
        /usr/bin/node app.js
fi
