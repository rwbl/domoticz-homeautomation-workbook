#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
File:
tfrgbledv2_set_color.py
Project:
Domoticz-Home-Automation-Workbook
Purpose:
Setter Example = Test setting the color of a Tinkerforge RGB LED Bricklet 2.0.
Description:
JSON formatted string as argument with following key:value pairs:
IMPORTANT: all keys must be in uppercase.
Key:Value
"HOST":"String" - IP address of the host running the brick deamon, i.e. localhost or any other IP address
"PORT":integer - Port number. Default: 4223
"UID":"String" - UID of the bricklet. Get from the Brick Viewer, i.e. "yyc"
"R":Red color 0 - 255
"G":Green color 0 - 255
"B":Blue color 0 - 255
Run example set color yellow:     
    cd domoticz/scripts/python
    python3 tfrgbledv2_set_color.py '{"R":255,"G":255,"B":0}'
Output:
    {"status": "OK", "title": "255,255,0"}
Version:
20200223 by rwbL
"""

import sys
import json

# Tinkerforge
from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_rgb_led_v2 import BrickletRGBLEDV2
## Set defaults for connection and RGB 
HOST = "localhost"
PORT = 4223
UID = "Jng"
R = 0
G = 0
B = 0

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
        if "R" in args:
            R = args["R"]
        if "G" in args:
            G = args["G"]
        if "B" in args:
            B = args["B"]
        # Check the json parse result
        # print("JSON:H={},P={},U={},R={},G={},B={}".format(HOST,PORT,UID,R,G,B))
    else:
        status = 0
        result = { "status" : "ERROR", "title" : "Wrong number of arguments." }

    if status == 1:
        try:
            # Create IP connection
            ipcon = IPConnection()
            # Create device object
            rl = BrickletRGBLEDV2(UID, ipcon)
            # Connect to brickd
            ipcon.connect(HOST, PORT)
            # Check if the bricklet is reachable - else error is triggered
            # In case the bricklet is not reacable, it takes 1-2 seconds befor a response is given
            rl.read_uid()
            # Set the color
            rl.set_rgb_value(R,G,B)
            result = { "status" : "OK", "title" : "{},{},{}".format(R,G,B) }
            # Disconnect
            ipcon.disconnect()
        except:
            result = { "status" : "ERROR", "title" : "set_rgb_value failed. Check master & bricklet." }
    # Print the result which is used by the dzVents Lua script
    print(json.dumps(result))
 