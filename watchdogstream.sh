#!/bin/bash

stream="$(ps aux | grep "mjpg_streamer" -w| wc -l)"
echo "${stream}"

if [ ${stream} -ne 2 ]
then
        cd /home/pi/oeildtre/pst3oeildtrearduino
        pwd
        /usr/local/bin/mjpg_streamer -i "/usr/local/lib/input_file.so -f /run/shm/mjpeg -n cam.jpg" -o "/usr/local/lib/output_http.so -p 8090 -w /var/www/html"
fi
