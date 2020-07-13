#!/bin/sh

echo "WARNING: This command will immediately turn OFF your LTE modem until the next reboot.  Do you wish to proceed? y/n"

read response

if [ "$response" = "y" ]; then
  echo 0 >/sys/class/gpio/gpio14/value
else
  exit
fi
