#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
File:
tflcd20x4_set_text.py
Project:
Domoticz-Home-Automation-Workbook
Purpose:
Setter Example = Setting the text and/or configuration of the Tinkerforge LCD 20x4  Bricklet 2.0.
Description:
JSON formatted string as argument with following key:value pairs:
IMPORTANT: all keys must be in uppercase. all values are string (in "").
Key:Value
"HOST":"String" - IP address of the host running the brick deamon. Default: "localhost" (optional)
"PORT":integer - Port number. Default: 4223  (optional)
"UID":"String" - UID of the bricklet. Get from the Brick Viewer, i.e. "yyc". (mandatory)
"BACKLIGHT":"True|False"
"BLINKING":"True|False"
"CURSOR":"True|False"
"LCDLINES":[{"line":0,"position":1,"clear":1,"text":"Text 0"},{"line":1,"position":1,"clear":1,"text":"Text 1"},{"line":2,"position":1,"clear":1,"text":"Text 2"},{"line":3,"position":1,"clear":1,"text":"Text 3"}]
Examples:
Set text line 1 & 2 (index 0,1):     
    cd domoticz/scripts/python
    python3 tflcd20x4_set_text.py '{"UID":"BHN", "LCDLINES":[{"line":1,"position":1,"clear":1,"text":"Text"},{"line":2,"position":1,"clear":1,"text":"Text2"}]}'
Output:
    {"status": "OK", "title": ""}
Set text lines 1,2,3,4 (index 0,1,2,3):     
    python3 tflcd20x4_set_text.py '{"UID":"BHN", "LCDLINES":[{"line":0,"position":1,"clear":1,"text":"Text 0"},{"line":1,"position":1,"clear":1,"text":"Text 1"},{"line":2,"position":1,"clear":1,"text":"Text 2"},{"line":3,"position":1,"clear":1,"text":"Text 3"}]}'
Set Backlight Off:
    python3 /home/pi/domoticz/scripts/python/tflcd20x4_set_text.py '{"UID":"BHN","BACKLIGHT":"False"}'

Version:
20200225 by rwbL
"""

import sys
import json

# Tinkerforge & Python API Binding
from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_lcd_20x4 import BrickletLCD20x4
## Set defaults for connection and RGB 
HOST = "localhost"
PORT = 4223
UID = None
BACKLIGHT = True
CURSOR = False
BLINKING = False
LCDLINES = None

# Custom Characters file JSON array format - located in the same folder as plugin.py. older name is plugin key.
CUSTOMCHARFILE = "/home/pi/domoticz/scripts/python/customchar.json"

# Status
STATUSOK = "OK"
TATUSERROR = "ERROR"

# Messages (not all)
MSGERRNOUID = "[ERROR] Bricklet UID not set. Get the UID using the Brick Viewer."
MSGERRSETCONFIG = "[ERROR] Set bricklet configuration failed. Check bricklet and settings."

# Arguments Length
ARGVLEN = 2

# Tinkerforge Bricklet

"""
Set the bricklet configuration
Parameter:
backlight - True|False = Set backlight on
cursor - True|false = set cursor on|off
blick - True|False = set blink cursor on|off
"""
def set_configuration(lcd,backlight,cursor,blinking):
    # print("set_configuration: B={},C={},B={}".format(backlight,cursor,blinking))
    status = "OK"
    title = ""
    try:
        # Update the configuration
        if backlight == True:
            lcd.backlight_on()
        else:
            lcd.backlight_off()
        lcd.set_config(cursor, blinking)
        
        # Set Custom Characters with index 0-7 as max 8 custom characters can be defined.
        # dzVents Lua scripts:
        # The \ character needs to be escaped, i.e. line = string.format(line, l, p, "\\u0008", domoticz.helpers.isnowhhmm(domoticz) )
        # Ensure to write in unicode \u00NN and NOT \xNN - Example: lcd.write_line(0, 0, "Battery: " + "\u0008")
        # JSON has no hex escape \xNN but supports unicode escape \uNNNN
        # 
        # Example custom character definition and write to the lcd:
        #     battery = [14,27,17,17,17,17,17,31] 
        #     clock = [31,17,10,4,14,31,31,0]
        #     lcd.set_custom_character(0, clock)
        # 
        # JSON File
        # Read the custom characters from JSON array file as defined by constant CUSTOMCHARFILE
        # JSON format examplewith 2 characters: 
        # [
        #     {"id":0,"name":"battery","char":"14,27,17,17,17,17,17,31"},
        #     {"id":1,"name":"clock","char":"31,17,10,4,14,31,31,0"}
        # ]
        # Use exception handling in case file not found
        # The id must be in range 0-7 as max 8 custom characters can be defined
        try:
            with open(CUSTOMCHARFILE) as f:
                json_char_array = json.load(f)
                # print("Customchar: #characters defined: {}".format(len(json_char_array)))
                if len(json_char_array) > 0:
                    for item in json_char_array:
                        id = int(item["id"])
                        name = item["name"]
                        char = item["char"].strip().split(",")
                        # Check if the character id is in range 0-7
                        if id >= 0 and id <= 7:
                            lcd.set_custom_character(id, char)
                            # print("Customchar: Index={},Name={},Char={}".format(id,name,item["char"]))
                        else:
                            return { "status" : "ERROR", "title" : "Customchar: Index={} not in range 0-7.".format(id) }
                else:
                    return { "status" : "ERROR", "title" : "Customchar: No or wrong characters defined." }
        except:
            return { "status" : "ERROR", "title" : "Customchar: Can not open file={}.".format(CUSTOMCHARFILE) }
    except:
        return { "status" : "ERROR", "title" : MSGERRSETCONFIG }
    # print("Customchar: Result={}".format(result))
    return { "status" : "OK", "title" : ""}

"""
Set LCD text for the 4 lines and 20 columns using json.
Parameter:
lcd - lcd device object
lines - json object holding up-to 4 lines
The JSON array has 1 to N entries with line properties.
It is possible to define an entry for a line or multiple entries for a line for different positions.
JSON keys with value explain
"line" - 0-3
"position" - 0-19
"clear": clear the display: 0=no clear,1=clear line,2=clear display
"text": text to display at the line

Example JSON string = JSON array for the 4 lines
jsonarraystring = '
[
    {"line":0,"position":0,"clear":1,"text":"TEXT 1"},
    {"line":1,"position":0,"clear":1,"text":"TEXT 2"},
    {"line":2,"position":0,"clear":1,"text":"TEXT 3"},
    {"line":3,"position":0,"clear":1,"text":"TEXT 4"}
]'
"""
def write_lines(lcd,lines):
    # print("write_lines: text: {}".format(lines))
    result = "OK"
    EMPTYLINE = "                    "
    # Check if lines is none
    if lines == None:
        return { "status" : "ERROR", "title" : "lcd lines missing." }
    try:
        # Define the lcd function write_line parameter
        line = 0
        position = 0
        text = ""
        clear = 0
        # print("write_lines: parsing json ...")
        # the parameter lines is already a json array
        json_array = lines  # , encoding=None)
        # print("write_lines: #lines: {}".format(len(json_array)))
        linecnt = 0
        for item in json_array:
            line = int(item["line"])
            position = int(item["position"])
            text = item["text"]
            clear = int(item["clear"])
            # print("write_lines: items (l,p,t,c) {},{},{},{}".format(line,position,text,clear))
            # Checks
            if (line < 0 or line > 3):
                return { "status" : "ERROR", "title" : "write_lines: Wrong line number: %d. Ensure 0-3." % (line)}
            if (position < 0 or position > 19):
                return { "status" : "ERROR", "title" : "write_lines: Wrong position number: %d. Ensure 0-19." % (position)}
            # Clear action: 1=clear line;2=clear display
            if clear == 1:
                lcd.write_line(line, 0, EMPTYLINE)
            if clear == 2:
                lcd.clear_display()
            # Write text 
            lcd.write_line(line, position, text)
            linecnt = linecnt + 1
            # print("write_lines: L={},P={},T={}".format(line,position,text))
        return { "status" : "OK", "title" : "Lines written #{}".format(linecnt)}
    except:
        return { "status" : "ERROR", "title" : "write_lines: Failed writing text (Unit=%d,ID=%d,JSON=%s). Check JSON definition." % (unit, Devices[unit].ID, Devices[unit].sValue) }

if __name__ == "__main__":
    status = 1
    # Get the command line argurments
    # print("Arguments {}: {}".format(len(sys.argv), str(sys.argv)))
    if len(sys.argv) == ARGVLEN:
        # Parse the command line argument 1 from string to json 
        # Argument 1 must be a string. Example single line: '{"UID":"BHN", "LCDLINES":[{"line":1,"position":1,"clear":1,"text":"Text"}]}'
        args = json.loads(sys.argv[1])
        if "HOST" in args:
            HOST = args["HOST"]
        if "PORT" in args:
            PORT = int(args["PORT"])
        if "UID" in args:
            UID = args["UID"]
        if "BACKLIGHT" in args:
            BACKLIGHT = True if args["BACKLIGHT"].lower() == "true" else False
        if "CURSOR" in args:
            CURSOR = True if args["CURSOR"].lower() == "true" else False
        if "BLINKING" in args:
            BLINKING = True if args["BLINKING"].lower() == "true" else False
        if "LCDLINES" in args:
            LCDLINES = args["LCDLINES"]
        # Check the json parse result
        # print("JSON:H={},P={},U={},B={},C={},BL={},L={}".format(HOST,PORT,UID,BACKLIGHT,CURSOR,BLINKING,LCDLINES))
    else:
        status = 0
        result = { "status" : "ERROR", "title" : "Wrong number of arguments." }

    if status == 1:
        try:
            # Create IP connection
            ipcon = IPConnection()
            # Create device object
            lcd = BrickletLCD20x4(UID, ipcon)
            # Connect to brickd
            ipcon.connect(HOST, PORT)
            # Check if the bricklet is reachable - else error is triggered
            # In case the bricklet is not reacable, it takes 1-2 seconds befor a response is given
            lcd.get_identity()
            # Set the config
            result = set_configuration(lcd,BACKLIGHT,CURSOR,BLINKING)
            if result['status'] == STATUSOK:
                # Write the lines
                # print("LCDLINES:" + LCDLINES)
                if LCDLINES != None:
                    result = write_lines(lcd,LCDLINES)
            # Disconnect
            ipcon.disconnect()
        except:
            result = { "status" : "ERROR", "title" : "lcd update failed. Check master & bricklet." }
    # Print the result which is used by the dzVents Lua script
    print(json.dumps(result))
 