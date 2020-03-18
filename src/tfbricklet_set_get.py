#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
File:       tfbricklet_get_set.py
Project:    Domoticz-Home-Automation-Workbook
Purpose:    Get or set the value of a bricklet.
Depends on: Python API Binding
Description:JSON formatted string as argument with key:value pairs enclosed in ''.
IMPORTANT: all keys must be in uppercase.
Key:Value
"HOST":"String" - IP address of the host running the brick deamon. Default: "localhost" (optional)
"PORT":integer - Port number. Default: 4223 (optional)
"UID":"String" - UID of the bricklet. Get from the Brick Viewer, i.e. "yyc" (mandatory)
The UID argument is mandatory, HOST and PORT are optional. The keys must in UPPERCASE!

Define additional key:value pairs depending bricklet:
Examples Bricklets:
RGB LED 2.0: set color = '{"HOST":"IP-Address","PORT":4223,"UID":"Jng","R":255,"G":255,"B":0}'
LCD 20x4: set text 4 lines = '{"UID":"BHN","LCDLINES":[{"line":0,"position":0,"clear":1,"text":"R=255"},{"line":1,"position":5,"clear":1,"text":"G=0"},{"line":2,"position":10,"clear":1,"text":"B=0"},{"line":3,"position":15,"clear":1,"text":"Color"}]}'
Result
The result of the command is a JSON formatted string containing the key:value pairs:
{"status": "OK", "title": ""} or {"status": "ERROR", "title": "Error message"}
For a getter, the requested values are added to the result.
Examples Bricklets:
Ambient Light 2.0: get lux = {"status": "OK", "title": "", "lux":"146.21"}

Tests:
Recommend during script development, to run (iterate) the script for a terminal command line without using Domoticz (dzVents, Lua).
Example: Run to get the lux value of the bricklet connected to the master brick which is connected via USB with Raspberry Pi:
    cd domoticz/scripts/python
    python3 /home/pi/domoticz/scripts/python/tfalv2_get_lux.py '{"UID":"yyc"}'
    Output:
    {"status": "OK", "title": "", "lux": "177.92"}

Version:    20200226 by rwbL
"""
import sys
import json

# Tinkerforge
from tinkerforge.ip_connection import IPConnection
# Bricklet api - see Tinkerforge documentation
from tinkerforge.bricklet_<BRICKLETAPINAME> import Bricklet<BRICKLETAPINAME>
## Set defaults for connection
HOST = "localhost"
PORT = 4223
UID = "<UID>"

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
        # Add additional arguments depending bricklet
        if "VALUE" in args:
            VALUE = args["VALUE"]
        # Examples:
        # RGB LED 2.0 set RGB color: '{"UID":"Jng", "R":255,"G":255,"B":0}'
        # LCD 20x4 set text lines: '{"UID":"BHN", "LCDLINES":[{"line":1,"position":1,"clear":1,"text":"Text"},{"line":2,"position":1,"clear":1,"text":"Text2"}]}' 
        # 
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
            devobj = BrickletBRICKLETAPINAME(UID, ipcon)
            # Connect to brickd
            ipcon.connect(HOST, PORT)
            # Check if the bricklet is reachable - else error is triggered
            # Depending the version of the bricklet the UID uses different function:
            # Older bricklets .get_identity() and newer .read_uid()
            # In case the bricklet is not reachable, it takes 1-2 seconds befor a response is given
            devobj.get_identity()
            devobj.read_uid()
            # GET
            value = devobj.get_<value>()
            # define the result containing the mandatory status, title and the value
            result = { "status" : "OK", "title" : "", "value" : "{}".format(value) }
            
            # SET
            devobj.set_value(<VALUE>)
            result = { "status" : "OK", "title" : "{}".format(<VALUE>) }

            # Disconnect
            ipcon.disconnect()
        except:
            result = { "status" : "ERROR", "title" : "get_value failed. Check master & bricklet." }
    # Print the result which is used by the dzVents Lua script
    print(json.dumps(result))
 