#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
File:
tfrgbledv2_set_color.py
Project:
Domoticz-Home-Automation-Workbook
Purpose:
Getter Example - Test getting the lux value of a Tinkerforge Ambient Light Bricklet 2.0.
Depends on: Python API Binding
Description:
JSON formatted string as argument with following key:value pairs:
IMPORTANT: all keys must be in uppercase. all values are string (in "").
Key:Value
"HOST":"String" - IP address of the host running the brick deamon, i.e. localhost or any other IP address
"PORT":integer - Port number. Default: 4223
"UID":"String" - UID of the bricklet. Get from the Brick Viewer, i.e. "yyc"
Arguments: '{"HOST":"localost","PORT":4223,"UID":"yyc"}'
At least 1 argument must be given.
Run example to get the lux value of the bricklet connected to the master brick which is connected via USB with Raspberry Pi:
cd domoticz/scripts/python
python3 /home/pi/domoticz/scripts/python/tfalv2_get_lux.py '{"UID":"yyc"}'
Output:
{"status": "OK", "title": "", "lux": "177.92"}
Version:
20200224 by rwbL
"""
import sys
import json

# Tinkerforge
from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_ambient_light_v2 import BrickletAmbientLightV2
## Set defaults for connection and RGB 
HOST = "localhost"
PORT = 4223
UID = "yyc"

# Arguments Length
ARGVLEN = 2

if __name__ == "__main__":
    status = 1
    # Get the command line argurments
    # print("Arguments: {}".format(str(sys.argv)))
    if len(sys.argv) == ARGVLEN:
        # Parse the command line argument 1 from string to json 
        args = json.loads(sys.argv[1])
        if "HOST" in args:
            HOST = args["HOST"]
        if "PORT" in args:
            PORT = int(args["PORT"])
        if "UID" in args:
            UID = args["UID"]
        # Check arguments
        # print("JSON:H={},P={},U={}".format(HOST,PORT,UID))
    else:
        status = 0
        result = { "status" : "ERROR", "title" : "Wrong number of arguments." }

    if status == 1:
        try:
            # Create IP connection
            ipcon = IPConnection()
            # Create device object
            al = BrickletAmbientLightV2(UID, ipcon)
            # Connect to brickd
            ipcon.connect(HOST, PORT)
            # Check if the bricklet is reachable - else error is triggered
            # In case the bricklet is not reacable, it takes 1-2 seconds befor a response is given
            al.get_identity()
            # # Get current illuminance
            illuminance = al.get_illuminance()
            if illuminance > 0:
                illuminance = illuminance/100.0
            result = { "status" : "OK", "title" : "", "lux" : "{}".format(illuminance) }
            # Disconnect
            ipcon.disconnect()
        except:
            result = { "status" : "ERROR", "title" : "get_illuminance failed. Check master & bricklet." }
    # Print the result which is used by the dzVents Lua script
    print(json.dumps(result))
 