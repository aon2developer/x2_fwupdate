#!/bin/bash

echo "Platform is linux!"

# Ensure that the scipt executes in current directory
cd "$(dirname "$0")"

# Receive device directory from argument
devpath=$1
echo "devpath is '$devpath'!"

# echo "Lets count to 5! ..."
# sleep 2
# echo "frgerge20%ergrege"
# sleep 1
# echo "40%"
# sleep 1
# echo "60%"
# sleep 1
# echo "80%"
# auh9r92huew error here!!! <-----
# sleep 1
# echo "100%"

# # Put X2 into bootloader mode 
# echo "Going into bootloader mode..."
# stty -F "$devpath" 1200 # find device path using device info selected from list (maybe pass it via an argument?)
# sleep 5
# echo "Successfully activated bootloader mode!"

# Execute update utility
echo "Beginning update..."
./dfu-util-linux -d 0x16D0:0x0CC4,0x0483:0xdf11 -a 0 -s 0x08000000:leave -D ../firmware/X2-1.3.6.dfu 

echo "Done!"
