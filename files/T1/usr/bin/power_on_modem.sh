#!/bin/sh

echo "WARNING: This command will power on your LTE modem.  Do you wish to proceed? y/n"

read response

if [ "$response" = "y" ]; then
  echo 1 >/sys/class/gpio/gpio14/value
else
  exit
fi
