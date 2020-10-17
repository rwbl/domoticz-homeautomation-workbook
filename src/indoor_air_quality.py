#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
indoor_air_quality.py
domoticz-workbook - function indoor_air_quality
Get Air Quality Bricklet data and submit in regular intervals the data to domoticz to update an air quality device or other devices.
A domoticz custom event (indoor_air_quality.dzvents) handles the incoming data defined as json by parsing the properties and update the devices.
The data parameter is a json string. Example: 
{"iaqindex": 249, "iaqquality": "Worse", "iaqaccuracy": "Low", "temperature": 21.31, "humidity": 58.87, "airpressure": 1015.27, "status": "OK", "title": "get_bricklet_data"}

CLI Run Example with output from folder /home/pi/domoticz/scripts/python:
$python3 indoor_air_quality.py
INFO:root:Calibration Duration Days [0=4,1=28]:0
INFO:root:Status LED:0
INFO:root:Temperature Offset:2.0
INFO:root:IAQ Index:94
INFO:root:IAQ Quality:Gut
INFO:root:IAQ Index Accuracy:Low
INFO:root:Temperature:18.82 °C
INFO:root:Humidity:59.4 %RH
INFO:root:Air Pressure:1016.08 hPa
INFO:root:OK,get_bricklet_data
INFO:root:OK,Custom Event

In case of an error, i.e. master brick not reachable
$python3 indoor_air_quality.py
ERROR:root:ERR,OS Error: No route to host
INFO:root:OK,Custom Event

Dependencies: indoor_air_quality.dzvents
20201013 rwbl
"""

import json
import requests
import time 
from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_air_quality import BrickletAirQuality
import logging as log
log.basicConfig(level=log.INFO)

## Tinkerforge parameter Host and Air Quality Bricklet
## Ensure to set the parameter right - test with brick viewer first
TFHOST = "192.168.1.114"
TFPORT = 4223
TFUID = "Jvj"

## Air Quality Bricklet
## Status led config: 0 = OFF
IQA_STATUS_LED = 0
## Air Quality Condition text
IQA_QUALITY_UNKNOWN = "Unbekannt"		# Unknown
IQA_QUALITY_GOOD = "Sehr Gut"			# Good
IQA_QUALITY_AVERAGE = "Gut"				# Average
IQA_QUALITY_LITTLEBAD = "Befriedigend"	# Little Bad
IQA_QUALITY_BAD = "Unbefriedigend"		# Bad
IQA_QUALITY_WORSE = "Schlecht"			# Worse
IQA_QUALITY_VERYBAD = "Sehr Schlecht"	# Very Bad

## Domoticz IP is local (as running on the Domoticz system) with default port
## Ensure the name of the custom event matches the automation event setting: 
## on = { customEvents = { 'tfindoorairquality', }, },
DOMIP = "http://127.0.0.1"
DOMPORT = 8080
DOMCUSTOMEVENT = "indoorairquality"

## Loop counter with the delay in seconds between the loop
## This option ca be used to get the data in intervals less than one minute
counter = 0     # count loop
maxcounter = 1  # run n times
delay = 10      # seconds

## Get the Tinkerforge brickler data
## Returns JSON string (example with data):
## {"iaqindex": 249, "iaqquality": "Worse", "iaqaccuracy": "Low", "temperature": 21.31, "humidity": 58.87, "airpressure": 1015.27, "status": "OK", "title": "get_bricklet_data"}
def get_bricklet_data():
    # Create the JSON object
    data = {}
    # Connect to the master brick and get the data from the air quality bricklet
    try:
        # Create IP connection
        ipcon = IPConnection()

        # Create device object
        aq = BrickletAirQuality(TFUID, ipcon)

        # Connect to brickd
        ipcon.connect(TFHOST, TFPORT)
        # Don't use device before ipcon is connected

        # Get calibration duration
        log.info("Calibration Duration Days [0=4,1=28]:" + str(aq.get_background_calibration_duration()))
        
        # Set status LED
        aq.set_status_led_config(IQA_STATUS_LED)
        log.info("Status LED:" + str(aq.get_status_led_config()))

        # Set temperature offset by 2°C (10=0.1°C, measured against real room temperature)
        # Note: Check from time-to-time if still ok
        aq.set_temperature_offset(200)
        log.info("Temperature Offset:" + str(aq.get_temperature_offset() * 0.01))
        
        # Get all values
        iaq_index, iaq_index_accuracy, temperature, humidity, \
          air_pressure = aq.get_all_values()
          
        # Assign the values to the JSON object
        data['iaqindex'] = iaq_index
        log.info("IAQ Index:" + str(iaq_index))

        # IAQ index range 0-500:0-50(good),51-100(average),101-150(little bad),151-200(bad),201-300(worse),301-500(very bad).
        iaq_quality = IQA_QUALITY_UNKNOWN
        if iaq_index >= 0 and iaq_index < 51:
            iaq_quality = IQA_QUALITY_GOOD
        elif iaq_index > 50 and iaq_index < 101:
            iaq_quality = IQA_QUALITY_AVERAGE
        elif iaq_index > 100 and iaq_index < 150:
            iaq_quality = IQA_QUALITY_LITTLEBAD
        elif iaq_index > 150 and iaq_index < 201:
            iaq_quality = IQA_QUALITY_BAD
        elif iaq_index > 200 and iaq_index < 301:
            iaq_quality = IQA_QUALITY_WORSE
        elif iaq_index > 300 and iaq_index < 501:
            iaq_quality = IQA_QUALITY_VERYBAD
        data['iaqquality'] = iaq_quality
        log.info("IAQ Quality:" + iaq_quality)

        iaq_accuracy = "Unknown"
        if iaq_index_accuracy == aq.ACCURACY_UNRELIABLE:
            iaq_accuracy = "Unreliable"
        elif iaq_index_accuracy == aq.ACCURACY_LOW:
            iaq_accuracy = "Low"
        elif iaq_index_accuracy == aq.ACCURACY_MEDIUM:
            iaq_accuracy = "Medium"
        elif iaq_index_accuracy == aq.ACCURACY_HIGH:
            iaq_accuracy = "High"
        data['iaqaccuracy'] = iaq_accuracy
        log.info("IAQ Index Accuracy:" + iaq_accuracy)

        data['temperature'] = temperature/100.0
        log.info("Temperature:" + str(temperature/100.0) + " °C")

        data['humidity'] = humidity/100.0
        log.info("Humidity:" + str(humidity/100.0) + " %RH")

        data['airpressure'] = air_pressure/100.0
        log.info("Air Pressure:" + str(air_pressure/100.0) + " hPa")

        # Disconnect
        ipcon.disconnect()

        data['status'] = "OK"
        data['title'] = "get_bricklet_data"
        log.info(data['status'] + ","+ data['title'])
    
    # Handle errors
    except OSError as e:
        data['status'] = "ERR"
        data['title'] = "OS Error: " + str(e.strerror)
        log.error(data['status'] + ","+ data['title'])
        time.sleep(1)
        
    # Return the data
    return json.dumps(data)
    
## Send the HTTP API request to domoticz to update the devices
## In the custom event the idx of the devices are defined
def send_request():
    # increase the counter
    global counter
    counter = counter + 1
    # get the json data for the custom event request from tinkerforge bricklet
    json_data = get_bricklet_data()
    # create the url to signal the domoticz custom event
    url = "{}:{}/json.htm?type=command&param=customevent&event={}&data={}".format(DOMIP, DOMPORT, DOMCUSTOMEVENT, json_data)
    # log.info("Counter:{}, URL:{}".format(counter, url))
    # submit the url
    try:
        r = requests.get(url, timeout=3)
        r.raise_for_status()
        # log.info(r.status_code)                               # 200
        content_json = json.loads(r.content)                    # {'status': 'OK', 'title': 'Custom Event'}
        log.info(content_json['status'] + "," + content_json['title']) # OK, Custom Event
    except requests.exceptions.HTTPError as errh:
        log.error("Domoticz Update HTTP Error," + errh)
    except requests.exceptions.ConnectionError as errc:
        log.error("Domoticz Update Error Connecting," + errc)
    except requests.exceptions.Timeout as errt:
        log.error("Domoticz Update Timeout Error," + errt)
    except requests.exceptions.RequestException as err:
        log.error("Domoticz Update Something else went wrong," + err)

## Main
if __name__ == '__main__':
    while True:
        send_request()
        if counter == maxcounter:
            quit()
        time.sleep(delay)
