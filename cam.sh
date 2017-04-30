#!/bin/bash

echo "'$1 $2 $3' > /var/www/html/camera/FIFO"
sudo echo "$1 $2 $3" > /var/www/html/camera/FIFO


