#!/bin/bash

# Ensure that the scipt executes in current directory
cd "$(dirname "$0")"

# Find X2 dev path
for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do
    devpath=$(
        syspath="${sysdevpath%/dev}"
        devname="$(udevadm info -q name -p $syspath)"
        # Stop if device is not an acm device (+filtering)
        [[ "$devname" == "bus/"* || "$devname" != *"ttyACM"* ]] && exit
        eval "$(udevadm info -q property --export -p $syspath)"
        # Return if X2 match found
        [[ "$ID_VENDOR_ID" == "16d0" && "$ID_MODEL_ID" == "0cc4" ]] && devpath="/dev/$devname"
        echo $devpath
    )
    [[ "$devpath" != "" ]] && break
done

[[ "$devpath" == "" ]] && echo "X2 not found, make sure that it's plugged in!" & exit
echo $devpath

# Put X2 into update mode 
stty -F "$devpath" 1200
sleep 1

# Execute update utility
./dfu-util-linux -d 0x16D0:0x0CC4,0x0483:0xdf11 -a 0 -s 0x08000000:leave -D X2-1.3.6.dfu
