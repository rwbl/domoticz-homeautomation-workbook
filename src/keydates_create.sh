#!/bin/bash
# keydates_create.sh
# Create keydates devices from type General, Subtype Alert
# Devicetype: pTypeGeneral, 0xF3 - convert to dec: 243
# Devices subType: sTypeAlert 0x16 - convert to dec: 22
# Taken from https://github.com/domoticz/domoticz/blob/development/hardware/hardwaretypes.h
# or checkout: https://www.domoticz.com/wiki/Developing_a_Python_plugin
# Ensure save bash file in Unix (LF) format and make executable: sudo chmod +x keydates_create.sh
#
# Example from CLI: 
# Run the script from /home/pi/domoticz/scripts/dzVents/scripts with ./keydates_create.sh
# Keydates Devices
#	Creating...
#	{"idx" : "326","status" : "OK","title" : "CreateSensor"}
#	Created: Keydate1
# ... and more
# Prior running this script set the number of devices to be created (adjust var devicecount). 
# This depends on the JSON array size.
# 20200903 rwbl

#
# Define the vars
#
domoticzPort=8080
domoticzIP=127.0.0.1
# Hardware used virtual sensors
hardwareIdx=6
# Device from type General, subtype Alert
devicetype=243
devicesubtype=22
# Initial devicename
# If want to be hidden use escaped dollar sign: \$Keydate
sensorname=Keydate
# Create 7 devices as defined in the JSON array
devicecount=7

#
# Create the alert devices
# Example: curl "http://$domoticzIP:$domoticzPort/json.htm?type=createdevice&idx=$hardwareIdx&sensorname=Keydate2&devicetype=243&devicesubtype=22"
#
echo "Keydates Devices"
counter=1
while [ $counter -le $devicecount ]
do
	echo "Creating device " $counter " ..."
	curl "http://$domoticzIP:$domoticzPort/json.htm?type=createdevice&idx=$hardwareIdx&sensorname=$sensorname$counter&devicetype=$devicetype&devicesubtype=$devicesubtype"
	echo Created: Keydate$counter
	echo 
	((counter++))
done
echo "Keydates Devices created."
echo "Check Domoticz GUI > Setup > Devices"
