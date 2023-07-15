#!/bin/bash

# Ensure that the scipt executes in current directory
cd "$(dirname "$0")"

# # Put X2 into bootloader mode 
# echo "Going into bootloader mode..."
# stty -F "/dev/ttyACM0" 1200 # find device path using device info selected from list (maybe pass it via an argument?)
# sleep 5
# echo "Successfully activated bootloader mode!"

# # Execute update utility
# echo "Beginning update..."
# ./dfu-util-linux -d 0x16D0:0x0CC4,0x0483:0xdf11 -a 0 -s 0x08000000:leave -D ../firmware/X2-1.3.6.dfu

echo "Done!"
