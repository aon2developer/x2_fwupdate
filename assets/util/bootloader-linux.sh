#!/bin/bash

deviceName=$1

echo Activate bootloader mode
stty -F $deviceName 1200

exitCode=$?

if [ $exitCode -ne 0 ] 
then 
  echo Failed to start boot loader mode
  exit $?
fi

echo Waiting for boot loader mode...
sleep 5

echo Boot loader mode activated!

exit 0
