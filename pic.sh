#!/bin/bash

echo 'im 1' > /var/www/html/camera/FIFO

sleep 0.2

path="/var/www/html/media/"
cd /var/www/html/media/

th=((ls *.jpg -rt | head -1))
img=((ls *.jpg -rt | head -2 | tail -n 1))

mv ${th} path/${1}/
mv ${img} path/${1}/