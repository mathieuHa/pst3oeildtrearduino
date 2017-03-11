#!/usr/bin/env python
# -*- coding: utf-8 -*-


import serial  # bibliothèque permettant la communication série
import time    # pour le délai d'attente entre les messages
import sys

print("IN python");
print(sys.argv[1]);


ser = serial.Serial('/dev/ttyUSB0', 9600)
time.sleep(1)   #on attend un peu, pour que l'Arduino soit prêt.
ser.write(sys.argv[1]);

print("OUT python");