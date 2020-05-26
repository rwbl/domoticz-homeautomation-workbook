#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
File:       tfio4v2-mqtt.py
Project:    Domoticz-Home-Automation-Workbook
Purpose:    To test mqtt communication between Tinkerforge IO4 Bricklet 2.0 and Domoticz devices or scripts.
The IO4 Bricklet 2.0 configuration:
IO4 Channel 0: LED connected. Output, High.
IO4 Channel 1: Push-button connected. Input, Low.
There are 2 Domoticz devices used (Idx,Name,Type,SubType,SwitchType):
108,TFIO4 Status,General,Text
109,TFIO4 LED Switch,Light/Switch,Switch,On/Off

To configure the IO4 bricklet, a JSON formatted string with key:value pairs enclosed in '' is required.
* IMPORTANT: all keys must be in uppercase except for the CHANNELS which must be in lowercase.
(Key:Value)
"HOST":"String" - IP address of the host running the brick deamon. Default: "localhost" (optional)
"PORT":integer - Port number. Default: 4223 (optional)
"UID":"String" - UID of the bricklet. Get from the Brick Viewer, i.e. "yyc" (mandatory)
STATUSLED:integer - Set the status LED configuration (see Bricklet documentation)
The UID argument is mandatory, HOST and PORT are optional. The keys must in UPPERCASE!
Additional key:value pairs for the io4v2 bricklet:
"CHANNELS":json array - Channels 0 to 3 with value& direction, ie. [{"channel":0,"value":1,"direction":"o"},{"channel":1,"value":0,"direction":"i"}]}'
"channel":integer - Channel number 0-3 (mandatory)
"value":integer - State of the channel 0=low (off) 1=high (on)
"direction":String - Direction output "o" or input "i"

Tests
1: Switch the IO4 Channel 0 LED on/off triggered by the Domoticz Switch device (idx=109) (MQTT subscribe)
2: Set the text of the Domoticz Text device (idx=108) when pushing or release the IO4 Channel 1 push-button (MQTT publish)
Example running python script from folder /home/pi/domoticz/scripts/python
# IO4 Channel 0: LED connected. Output, High.
# IO4 Channel 1: Push-button connected. Input, Low.
python3 tfio4v2-mqtt.py

The config is set below in the global CONFIG:
'{"UID":"G4d","STATUSLED":2,"CHANNELS":[{"channel":0,"value":0,"direction":"o"},{"channel":1,"value":0,"direction":"i"}]}'

Recommend during script development, to run (iterate) the script for a terminal command line without using Domoticz (dzVents, Lua).
Depends on: Tinkerforge Python API Binding, MQTT Python paho client
Version:    20200229 rwbL
"""
# Imports
import sys
import time
from datetime import datetime
## json to handle incoming mqtt messages from domoticz
import json
## mqtt client library for subscribe & publish mqtt messages
import paho.mqtt.client as mqtt
## URL lib for domoticz http api requests
import urllib.request
import urllib.parse
from urllib.error import HTTPError,URLError
# Tinkerforge
from tinkerforge.ip_connection import IPConnection
## Bricklet api - see Tinkerforge documentation
from tinkerforge.bricklet_io4_v2 import BrickletIO4V2

# Info
VERSION = "DoTfIO4V2"

# Debug
# DEBUG = True
DEBUG = False

# Configuration
CONFIG = '{"UID":"G4d","STATUSLED":2,"CHANNELS":[{"channel":0,"value":0,"direction":"o"},{"channel":1,"value":0,"direction":"i"}]}'

## MQTT connection parameter defaults and domoticz topics publish & subscribe
MQTT_BROKER = "localhost"
MQTT_CLIENT = "tfdomoticzio4"
MQTT_TOPIC_SUB = "domoticz/out"
MQTT_TOPIC_PUB = "domoticz/in"

# Tinkerforge
## Connection parameter defaults
TF_HOST = "localhost"
TF_PORT = 4223
## IO4
IO4_UID = "G4d"
## Set the input channel callback period to 0.25s (250ms) or 500 ...
IO4_CALLBACK_PERIOD = 500
## Set the status LED to heartbeat (see bricklet api doc for the values to be set)
IO4_STATUS_LED = 2
## Channels
IO4_CHANNEL_0 = 0
IO4_CHANNEL_1 = 1

# Domoticz
## (mqtt subscribe) Domoticz switch to turn the io4 led on&off (connected to channel 0)
IDX_SWITCH = 109
## (mqtt publish)Domoticz text device gets updated when io4 button (connected to channel 1) is pressed.
IDX_STATUS = 108

##
## INIT with globals having initial values
##

##
## MQTT functions
##

# mqtt subscribe to topic(s) after successful connection to the mqtt broker
# for this solution only the domoticz mqtt topic "domoticz/out" is subscribed to
def on_connect(client, userdata, flags, rc):
    mqttConnected = True
    if DEBUG == True:
        print("MQTT on_connect: client={},userdata={},flags={},rc={},subscribe topic={}".format(client, userdata, flags, rc, mqttTopicSub))
    client.subscribe(mqttTopicSub)
    print("MQTT Connected. Waiting for messages...".format())

# mqtt handle incoming messages from domoticz topic "domoticz/in"
# for this topic all domoticz mqtt messages are received (json formatted string)
# the mqtt message is json parsed to get the device idx and take action.
# for this example, the io4 channel 0 is set to high or low, i.e. led on / off
def on_message(client, userdata, message):
    if DEBUG == True:
        print("MQTT on_message: topic={}".format(message.topic))
        print("MQTT on_message: payload={}".format(message.payload.decode("utf-8")))
        print("MQTT on_message: qos={},retail=".format(message.qos,message.retain))
    # decode the message payload to be able to parse
    json_string = str(message.payload.decode("utf-8"))
    # Handle changes of the domoticz switch to turn io4 led channel 0 on or off
    set_io4_channel_value(json_string, IDX_SWITCH, IO4_CHANNEL_0)

# mqtt log any messages
def on_log(client, userdata, level, buf):
    if DEBUG == True:
        print("MQTT on_log:client={},userdata={},level=={},buf={}".format(client, userdata, level, buf))

# mqtt create a new instance and start listening.
# prior string to listen to mqtt messages, connect to tinkerforge brick deamon with callback on io4 input channels
def create_mqtt_instance():
    global mqttBroker,mqttClient,mqttTopicSub,mqttTopicPub,mqttConnected

    mqttBroker = MQTT_BROKER
    mqttClient = MQTT_CLIENT
    mqttTopicSub = MQTT_TOPIC_SUB
    mqttTopicPub = MQTT_TOPIC_PUB
    mqttConnected = False

    print("Connecting to Tinkerforge & MQTT...")

    if DEBUG == True:
        print("MQTT create new instance:broker={}client={},".format(mqttBroker,mqttClient))
    mqttClient = mqtt.Client(mqttClient)
    mqttClient.on_connect = on_connect
    mqttClient.on_message = on_message
    mqttClient.on_log = on_log
    if DEBUG == True:
        print("Connecting to the broker", mqttBroker)
    mqttClient.connect(mqttBroker, 1883, 60)
    time.sleep(4)
    # Connect to the tinkerforge brick daemon with json string holding the configuration
    # Instead of constant CONFIG, an argument sys.argv can be used
    if connect_tinkerforge(CONFIG) == True:
        # Loop the matt client
        mqttClient.loop_forever()
    else:
        print("[ERROR] Can not connect to Tinkerforge. Check configuration.")
    return
    
# mqtt publish new message to domoticz
## Examples payload:
## Text device: '{"command": "udevice", "idx": %s, "svalue": "Hello World at %s"}' % (IDX,datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
def publish_mqtt_message(payload):
    if DEBUG == True:
        print("MQTT publish_mqtt_message:topic={},payload={}".format(mqttTopicSub,payload))
    mqttClient.publish(mqttTopicPub,payload)

def disconnect_mqtt_broker():
    mqttClient.loop_stop()
    if DEBUG == True:
        print("MQTT disconnected mqtt broker={}".format(mqttBroker))

##
## JSON Parsing
##
def get_domoticz_device_property(json_string, idx, property):
    result = ""
    if DEBUG == True:
        print("get_domoticz_device_property: json={},idx={},property={}".format(json_string, idx, property))
    parsed_json = json.loads(json_string)
    parsed_idx = int(parsed_json['idx'])
    if parsed_idx == idx:
        name = parsed_json['name']
        value = parsed_json[property]
        result = value
        if DEBUG == True:
            print("get_domoticz_device_property: idx={},name={},property={},value={}".format(idx, name, property, value))
    return result
    
## Text device: '{"command": "udevice", "idx": %s, "svalue": "Hello World at %s"}' % (IDX,datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
def set_domoticz_text_device(idx, svalue):
    if DEBUG == True:
        print("set_domoticz_text_device: idx={},svalue={}".format(idx, svalue))
    payload = '{{"command":"udevice","idx":{},"svalue":"{}"}}'.format(idx,svalue)
    # payload = '{"command":"udevice","idx":%d,"svalue":"%s"}' % (idx, svalue)
    print("set_domoticz_text_device: payload={}".format(payload))
    publish_mqtt_message(payload)
    if DEBUG == True:
        print("set_domoticz_text_device: idx={},svalue={}".format(idx, svalue))

# set the value of an io4 input channel depending domoticz witch on/off device nvalue
def set_io4_channel_value(json_string, idx, channel):
    # get all idx properties
    # if DEBUG == True:
    #     print("set_io4_channel_value: json={},idx={}".format(json_string, idx))
    parsed_json = json.loads(json_string)
    parsed_idx = int(parsed_json['idx'])
    if parsed_idx == idx:
        # get the properties of the selected idx
        if DEBUG == True:
            print("set_io4_channel_value: json={},idx={}".format(json_string, idx))
        name = parsed_json["name"]
        value = int(parsed_json["nvalue"])
        io4Dev.set_selected_value(channel,value)
        print("set_io4_channel_value: channel={},idx={},name={},nvalue={}".format(channel,idx, name, value))

##
## Tinkerforge functions
##

# Connect to the tinkerforge brick deamon, create io4 bricklet device object and set bricklet parameter
# Parameter:
# config - json string with settings
def connect_tinkerforge(config):
    result = False
    # Define the globals for he tinkerforge connection and io4 bricklet
    global tfHost,tfPort
    global io4Uid,io4CallbackPeriod,io4StatusLED,io4Dev
    
    # Get the config parameter
    if DEBUG == True:
        print("Config=:{}".format(config))

    # Parse the config string
    args = json.loads(config)
    # Assign to the vars
    tfHost = args["HOST"] if "HOST" in args else TF_HOST
    tfPort = int(args["PORT"]) if "PORT" in args else TF_PORT
    io4Uid = args["UID"] if "UID" in args else IO4_UID
    io4StatusLED = int(args["STATUSLED"]) if "STATUSLED" in args else IO4_STATUS_LED
    io4CallbackPeriod = IO4_CALLBACK_PERIOD
    io4Channels = args["CHANNELS"] if "CHANNELS" in args else ""
        
    # Check arguments
    if DEBUG == True:
        print("connect tinkerforge: host={},port={},uid={},callbackperiod={},channels={}".format(tfHost,tfPort,io4Uid,io4CallbackPeriod,io4Channels))

    try:
        # Create IP connection
        ipCon = IPConnection()
        # Create device object
        io4Dev = BrickletIO4V2(io4Uid, ipCon)
        # Connect to brickd
        ipCon.connect(tfHost,tfPort)
        # Check if the bricklet is reachable - else error is triggered
        # In case the bricklet is not reachable, it takes 1-2 seconds befor a response is given
        io4Dev.read_uid()
        # Set the status led
        io4Dev.set_status_led_config(io4StatusLED)
        # Set one or more channels
        if io4Channels != None:
            title = ""
            for item in io4Channels:
                channel = int(item["channel"])
                value = int(item["value"])
                direction = item["direction"]
                # set configuration is used to enable the of getting the value using get_configuration
                io4Dev.set_configuration(channel, direction, value)                   
                # Register input value callback to function cb_input_value
                if direction == "i":
                    io4Dev.register_callback(io4Dev.CALLBACK_INPUT_VALUE, on_io4_callback)
                    # Set period for input value for the channel with callback
                    io4Dev.set_input_value_callback_configuration(channel, io4CallbackPeriod, False)
                title = "channel:{} value:{} direction:{}".format(channel,value,direction)
            result = True
            # result = { "status" : "OK", "title" : "{}".format(title) }
        #
        print("Tinkerforge Connected: host={},port={},uid={}".format(tfHost,tfPort,io4Uid))
        # Disconnect
        # ipCon.disconnect()
    except:
        result = False
        # result = { "status" : "ERROR", "title" : "io4 failed. Check master & bricklet." }
    # Print the result which is used by the dzVents Lua script
    if DEBUG == True:
        print(json.dumps(result))

    return result
    
    # input("Press key to exit\n") # Use raw_input() in Python 2
    # ipCon.disconnect()
        
# Callback function for the io4 channel(s) configured as input
# Updates the domoticz text device:
# Button pushed (example log entry & device text):
# 2020-02-29 12:09:08.468 MQTT: Topic: domoticz/in, Message: {"command":"udevice","idx":108,"svalue":"IO4 changed:True, value:False, time:2020-02-29 
# TF IO4 Status IO4 changed:True, value:True, time:2020-02-29 12:13:13
def on_io4_callback(channel, changed, value):
    if DEBUG == True:
        print("on_io4_callback:channel:{},changed:{},value:{}".format(channel,changed,value))
    # Select the channel
    if (channel == IO4_CHANNEL_1) and (changed == True):
        svalue = "IO4 changed:{}, value:{}, time:{}".format(changed,value,datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
        set_domoticz_text_device(IDX_STATUS, svalue)
    
# Main    
if __name__ == "__main__":
    print("{} starting...".format(VERSION))
    create_mqtt_instance()
