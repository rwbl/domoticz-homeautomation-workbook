#!/bin/bash
cd /home/pi/domoticz/scripts/python

## Turn channel 0 led on
python3 /home/pi/domoticz/scripts/python/tfio4v2_set_channel.py '{"UID":"G4d","CHANNELS":[{"channel":0,"value":1}]}'

sleep 2

## Turn channel 0 led off
python3 /home/pi/domoticz/scripts/python/tfio4v2_set_channel.py '{"UID":"G4d","CHANNELS":[{"channel":0,"value":0}]}'

