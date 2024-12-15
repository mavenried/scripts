#! /bin/env python3
import os 
files = [file for file in os.listdir('/home/maverikio/Music/All2/')]
for file in os.listdir('/home/maverikio/Music/All/'):
    if file not in files:
        print(file)
