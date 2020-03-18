#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
File:       tfio4v2_set_channel.py
Project:    Domoticz-Home-Automation-Workbook
Purpose:    Set for the bricklet channels 0-3 the direction to output with a value high or low.
Depends on: Python API Binding
Description:JSON formatted string as argument with key:value pairs enclosed in ''.
IMPORTANT: all keys must be in uppercase.
Key:Value
"HOST":"String" - IP address of the host running the brick deamon. Default: "localhost" (optional)
"PORT":integer - Port number. Default: 4223 (optional)
"UID":"String" - UID of the bricklet. Get from the Brick Viewer, i.e. "yyc" (mandatory)
The UID argument is mandatory, HOST and PORT are optional. The keys must in UPPERCASE!
Additional key:value pairs for the io4v2 bricklet:
"CHANNELS":json array - Channels 0 to 3 with value, ie. [{"channel":0,"value":1},{"channel":1,"value":1}]}'
"channel":integer - Channel number 0-3 (mandatory)
"value":integer - State of the channel 0=low (off) 1=high (on)
The direction for each channel is set to output because this script acts as a setter.
"DIRECTION":String - Direction "o" or "i" - NOT USED
Example:
Set channel 0 to high = '{"UID":"G4d","CHANNELS":[{"channel":0,"value":1}]}'
Result
The result of the command is a JSON formatted string containing the key:value pairs:
{"status": "OK", "title": "channel:0 value:1"} or {"status": "ERROR", "title": "Error message"}
Tests:
Recommend during script development, to run (iterate) the script for a terminal command line without using Domoticz (dzVents, Lua).
Example: Run to get the lux value of the bricklet connected to the master brick which is connected via USB with Raspberry Pi:
    cd domoticz/scripts/python
    python3 /home/pi/domoticz/scripts/python/tfio4v2_set_channel.py '{"UID":"G4d","CHANNELS":[{"channel":0,"value":1}]}'
    Output:
    {"status": "OK", "title": "channel:0 value:1"}

Version:    20200226 by rwbL
"""
import sys
import json

# Tinkerforge
from tinkerforge.ip_connection import IPConnection
# Bricklet api - see Tinkerforge documentation
from tinkerforge.bricklet_io4_v2 import BrickletIO4V2
## Set defaults for connection
HOST = "localhost"
PORT = 4223
UID = "G4d"

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
        if "CHANNELS" in args:
            CHANNELS = args["CHANNELS"]
        # Check arguments
        # print("JSON:H={},P={},U={},C={}".format(HOST,PORT,UID,CHANNELS))
    else:
        status = 0
        result = { "status" : "ERROR", "title" : "Wrong number of arguments." }

    if status == 1:
        try:
            # Create IP connection
            ipcon = IPConnection()
            # Create device object
            devobj = BrickletIO4V2(UID, ipcon)
            # Connect to brickd
            ipcon.connect(HOST, PORT)
            # Check if the bricklet is reachable - else error is triggered
            # In case the bricklet is not reachable, it takes 1-2 seconds befor a response is given
            devobj.read_uid()
            # SET one or more channels
            if CHANNELS != None:
                title = ""
                for item in CHANNELS:
                    channel = int(item["channel"])
                    value = int(item["value"])
                    direction = "o"
                    # set configuration is used to enable the of getting the value using get_configuration
                    devobj.set_configuration(channel, direction, value)
                    title = "channel:{} value:{}".format(channel,value)
                result = { "status" : "OK", "title" : "{}".format(title) }
            # Disconnect
            ipcon.disconnect()
        except:
            result = { "status" : "ERROR", "title" : "get_value failed. Check master & bricklet." }
    # Print the result which is used by the dzVents Lua script
    print(json.dumps(result))
 