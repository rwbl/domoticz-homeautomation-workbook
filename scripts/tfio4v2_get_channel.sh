#!/bin/bash
cd /home/pi/domoticz/scripts/python

# IO-2V2 - Get the channel status.

## Get channel 0 status
python3 /home/pi/domoticz/scripts/python/tfio4v2_get_channel.py '{"UID":"G4d","CHANNELS":[{"channel":0}]}'
## {"status": "OK", "title": "channel:0 value:Configuration(direction='o', value=False)"}

sleep 2

## Get channel 0 status
python3 /home/pi/domoticz/scripts/python/tfio4v2_get_channel.py '{"UID":"G4d","CHANNELS":[{"channel":1}]}'

