#!/bin/bash

deviceName=$1

echo 'Actvating bootloader mode for' $deviceName

stty -F $deviceName 1200

sleep 5

echo 'Bootloader mode activated!'

exit 0
