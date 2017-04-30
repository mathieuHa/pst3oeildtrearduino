#!/bin/bash

echo "'$1 $2' > /var/www/html/camera/FIFO"
sudo echo "$1 $2" > /var/www/html/camera/FIFO


