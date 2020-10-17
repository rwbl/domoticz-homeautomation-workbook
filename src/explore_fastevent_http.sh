#!/bin/bash
# explore_fastevent_http.sh
# To update the level & text of a virtual alert sensor.
# The custom event receives data from a Python script running on the Rapberry Pi CLI.
# The custom data is defined as JSON, i.e. {"level": 4, "text": "Alert Level set to 4"}.
# The data is converted to a Lua table and used to update the alert device level & text.
# 20201007 rwbl

#
# Define vars
#
## Domoticz ip running local with default port
domoticz_ip=127.0.0.1
domoticz_port=8080
## Alert level and text. The text special must be escaped
level=4
text="The%20alert%20level%20is%20set%20to%20$level"
## Define the JSON string without {} as these are set in the url parameter
json_data=\"level\":$level,\"text\":\"$text\"

echo JSON_DATA:
echo "$json_data"

#
# Keep this the same as the trigger of the dzVents script
#
custom_event=setalert

#
# signal dzVents
#

## This is working
curl -H 'Content-type: application/json' "http://$domoticz_ip:$domoticz_port/json.htm?type=command&param=customevent&event=$custom_event&data=\{$json_data\}"
## echo "http://$domoticz_ip:$domoticz_port/json.htm?type=command&param=customevent&event=$custom_event&data=\{$json_data\}"
## http://127.0.0.1:8080/json.htm?type=command&param=customevent&event=setalert&data=\{"level":4,"text":"this%20is%20the%20alertlevel%204"\}

## This is working
## curl "http://$domoticz_ip:$domoticz_port/json.htm?type=command&param=customevent&event=$custom_event&data=\{\"level\":2,\"text\":\"This%20the%20alert%20level\"\}"
## echo "http://$domoticz_ip:$domoticz_port/json.htm?type=command&param=customevent&event=$custom_event&data=\{\"level\":2,\"text\":\"This%20the%20alert%20level\"\}"
## http://127.0.0.1:8080/json.htm?type=command&param=customevent&event=setalert&data=\{"level":2,"text":"This%20the%20alert%20level"\}
