# Explore Automation Events
These scripts are not used anymore but kept as learning reference. 

## Python

### Python basement_humidity_monitor_p.py

```
"""
Script: basement_humidity_monitor_p
Monitor the basement humidity if exceeds threshold and write to Domoticz log.
----------------------------------------------------------------------------- 
"""

# Imports
import domoticz
import DomoticzEvents as DE

# Devices
KellerIdx = 11
KellerName = 'Keller'

# Set the threshold to monitor the humidity (%RH)
HumidityThreshold = 70

if DE.changed_device_name == KellerName:
    # Test Log
    # 2018-09-02 11:32:46.085 Python: Changed: ID: 11 Name: Keller, Type: 82, subType: 7, switchType: 0, s_value: 18.7;75;3, n_value: 0, n_value_string: 18.7;75;3, last_update_string: 2018-09-02 11:32:46
    DE.Log("Python: Changed: " + DE.changed_device.Describe())
    # Test s_value
    # 2018-09-02 11:32:46.085 18.7;75;3
    svalue = DE.Devices[KellerName].s_value
    DE.Log(svalue)
    # Get the humidity, which is at the 2nd entry of the svalue, i.e. 75
    # Split the svalue by ;. The result is a list with length 3, data[0]=T,data[1]=H,data[2]=Comfort
    data = svalue.split(";")
    # Log all 3 entries
    # for temp in data:
    #     DE.Log(temp)
    # Get the humidity at pos 2 which is index 1 :
    if len(data) == 3:
        Humidity = int(data[1])
        if Humidity >= HumidityThreshold:
            # Log that the humidity is above threshold. The log string uses new string formatting
            DE.Log('Basement Humidity >= {}%RH ({}%RH)'.format(HumidityThreshold, Humidity))
```
    
### Python basement_humidity_monitor2_p.py

```
"""
script: basement_humidity_monitor2_p
Project: domoticz-homeautomation-workbook
Monitor the basement humidity (device=Keller) if exceeds threshold, write to Domoticz log and update the virtual sensor text (device=Info Message)
----------------------------------------------------------------------------- 
"""

# Imports
import domoticz
import DomoticzEvents as DE
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError 

# Define the domoticz server ip with port!
domoticzserver="localhost:8080" 

# Devices
KellerIdx = 11
KellerName = 'Keller'
TextInfoIdx = 52
TextInfoName = 'Info Message'

# Set the threshold to monitor the humidity (%RH)
HumidityThreshold = 70

def domoticzrequest (url):
    """Send update request to domoticz
    :url: Domoticz JSON/API url
    :result: Result is a json object
    """
    req = Request(url)
    try:
        response = urlopen(req)
    except HTTPError as e:
        # print('Server couldn\'t fulfill the request.')
        # print('Error code: ', e.code)
        return "Error fulfilling the request." + e.code
    except URLError as e:
        # print('Failed to reach a server.')
        # print('Reason: ', e.reason)
        return "Error reaching the server." + e.code
    else:
        # everything is fine
        return response.read().decode('utf-8')
 
if DE.changed_device_name == KellerName:
    # Test Log
    # 2018-09-02 11:32:46.085 Python: Changed: ID: 11 Name: Keller, Type: 82, subType: 7, switchType: 0, s_value: 18.7;75;3, n_value: 0, n_value_string: 18.7;75;3, last_update_string: 2018-09-02 11:32:46
    DE.Log("Python: Changed: " + DE.changed_device.Describe())
    # Test s_value
    # 2018-09-02 11:32:46.085 18.7;75;3
    svalue = DE.Devices[KellerName].s_value
    DE.Log(svalue)
    # Get the humidity, which is at the 2nd entry of the svalue, i.e. 75
    # Split the svalue by ;. The result is a list with length 3, data[0]=T,data[1]=H,data[2]=Comfort
    data = svalue.split(";")
    # Log all 3 entries
    # for temp in data:
    #     DE.Log(temp)
    # Get the humidity at pos 2 which is index 1 :
    if len(data) == 3:
        Humidity = int(data[1])
        if Humidity >= HumidityThreshold:
            # Log that the humidity is above threshold. The log string uses new string formatting
            svalueinfo = 'Basement Humidity >= {}%RH ({}%RH)'.format(HumidityThreshold, Humidity)
            DE.Log(svalueinfo)
            
            # Update the Virtual Sensor Info_Message
            # This is not working - not sure why, might be only in plugins
            # DE.Command(TextInfoName, svalueinfo)
            
            # Require to escape the message string including spaces
            svalueinfo = urllib.parse.quote_plus(svalueinfo)
            # Build the url. Example:
            # http://localhost:8080/json.htm?type=command&param=udevice&idx=52&nvalue=0&svalue=Basement+Humidity+%3E%3D+70%25RH+%2877%25RH%29
            url = "http://" + domoticzserver + "/json.htm?type=command&param=udevice&idx=" + str(TextInfoIdx) + "&nvalue=0&svalue=" + svalueinfo
            # DE.Log(url)
            ret = domoticzrequest(url) 
            # Log the return . which is a JSON string {"status" : "OK","title" : "Update Device"} 
            # DE.Log(ret)
```

### Python Run Bash Script

This is a more complex example running a bash script to update Domoticz device value via Python script.
The Python scripts uses the Tinkerforge library to access data from the moisture bricklet.

```
local utils = require('utils')

return {
	on = {
		timer = {
			'every minute'
		}
	},
	execute = function(domoticz, timer)
	    domoticz.log("Running Python...")
	    os.execute('bash um.sh')
	end
}
```

**um.sh**
```
#!/bin/bash
python3 /home/pi/domoticz/scripts/dzVents/scripts/update_moisture.py
```

**update_moisture.py**

```
#!/usr/bin/env python
# -*- coding: utf-8 -*-

HOST = "master-ip-address"
PORT = 4223
UID = "uTP" # Change XYZ to the UID of your Moisture Bricklet

# Imports
import time
from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_moisture import BrickletMoisture
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError 

#Tinkerforge Master Brick
HOST = "master-ip-address"
PORT = 4223
UID = "uTP"

# Define the domoticz server ip with port!
domoticzserver="localhost:8080" 

APP_DELAY = 1

# Devices
PalmeMakeLABIdx = 54
PalmeMakeLABName = 'Palme MakeLAB'
TextInfoIdx = 52
TextInfoName = 'Info Message'

def domoticzrequest (url):
    """Send update request to domoticz
    :url: Domoticz JSON/API url
    :result: Result is a json object
    """
    req = Request(url)
    try:
        response = urlopen(req)
    except HTTPError as e:
        # print('Server couldn\'t fulfill the request.')
        # print('Error code: ', e.code)
        return "Error fulfilling the request." + e.code
    except URLError as e:
        # print('Failed to reach a server.')
        # print('Reason: ', e.reason)
        return "Error reaching the server." + e.code
    else:
        # everything is fine
        return response.read().decode('utf-8')
 
# Convert TF value to Domoticz value
# 00 - 09 = saturated, 10 - 19 = adequately wet, 20 - 59 = irrigation advice, 60 - 99 = irrigation, 100-200 = Dangerously dry, 
def converttfvalue(tfvalue):
    n = 4095 / 200
    v = 200 - (tfvalue / n)
    return int(v)

def getmoisture():
    ipcon = IPConnection() # Create IP connection
    m = BrickletMoisture(UID, ipcon) # Create device object
    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected
    # Get current moisture value
    moisture = m.get_moisture_value()
    moisture = converttfvalue(moisture)
    ipcon.disconnect()
    return moisture

def updatemoisture():
	m = getmoisture()
    # Build the url. Example:
    # http://localhost:8080/json.htm?type=command&param=udevice&idx=54&nvalue=22
    # IDX = id of your device (This number can be found in the devices tab in the column "IDX")
    # MOISTURE = moisture content in cb 0-200 where:
	svaluemoisture = str(m)
	url = "http://" + domoticzserver + "/json.htm?type=command&param=udevice&idx=" + str(PalmeMakeLABIdx) + "&nvalue=" + svaluemoisture
    # DE.Log(url)
	ret = domoticzrequest(url)
	f = open("moisture.txt", "w")
	f.write(svaluemoisture)
	time.sleep(APP_DELAY)
	print(svaluemoisture)
	
	
if __name__ == "__main__":
	# Get the moisture and update the Domoticz Device
	#  print("Palme MakeLAB Moisture Update")
	updatemoisture()
```

### Python palmemakelab_moisture_update

```
"""
palmemakelab_moisture_update
Monitor the moisture of the palm in the MakeLAB (Palme MakeLAB, idx=54).
The moisture is measured using Tinkerforge Moisture bricklet connect to a Master Brick with WiFi extention 2.
The returned value is 0 (dry) - 4095 (saturated).
Domoticz requires a value between 0 (saturated) - 200 (dry):
00 - 09 = saturated, 10 - 19 = adequately wet, 20 - 59 = irrigation advice, 60 - 99 = irrigation, 100-200 = Dangerously dry, 

The Python script requires the Tinkerforge Python library.
Install Tinkerforge Python Library:
pip3 install tinkerforge
pip3 show tinkerforge
IMPORTANT:
Copy /home/pi/.local/lib/python3.5/site-packages/tinkerforge to /home/pi/domoticzs/scripts/python/tinkerforge
This is required for the event system to find the Tinkerforge API.
----------------------------------------------------------------------------- 
"""

# Imports
import domoticz
import DomoticzEvents as DE
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError 

import tinkerforge
from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_moisture import BrickletMoisture

#Tinkerforge Master Brick
HOST = "master-ip-address"
PORT = 4223
UID = "uTP"

# Define the domoticz server ip with port!
domoticzserver="localhost:8080" 

# Devices
PalmeMakeLABIdx = 54
PalmeMakeLABName = 'Palme MakeLAB'
TextInfoIdx = 52
TextInfoName = 'Info Message'

def domoticzrequest (url):
    """Send update request to domoticz
    :url: Domoticz JSON/API url
    :result: Result is a json object
    """
    req = Request(url)
    try:
        response = urlopen(req)
    except HTTPError as e:
        # print('Server couldn\'t fulfill the request.')
        # print('Error code: ', e.code)
        return "Error fulfilling the request." + e.code
    except URLError as e:
        # print('Failed to reach a server.')
        # print('Reason: ', e.reason)
        return "Error reaching the server." + e.code
    else:
        # everything is fine
        return response.read().decode('utf-8')
 
# Convert TF value to Domoticz value
# 00 - 09 = saturated, 10 - 19 = adequately wet, 20 - 59 = irrigation advice, 60 - 99 = irrigation, 100-200 = Dangerously dry, 
def converttfvalue(tfvalue):
    n = 4095 / 200
    v = 200 - (tfvalue / n)
    return int(v)

def getmoisture():
    ipcon = IPConnection() # Create IP connection
    m = BrickletMoisture(UID, ipcon) # Create device object
    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected
    # Get current moisture value
    moisture = m.get_moisture_value()
    moisture = converttfvalue(moisture)
    ipcon.disconnect()
    return moisture

def updatemoisture():
    m = getmoisture()
    # Build the url. Example:
    # http://localhost:8080/json.htm?type=command&param=udevice&idx=54&nvalue=22
    # IDX = id of your device (This number can be found in the devices tab in the column "IDX")
    # MOISTURE = moisture content in cb 0-200 where:
    svaluemoisture = str(m)
    url = "http://" + domoticzserver + "/json.htm?type=command&param=udevice&idx=" + str(PalmeMakeLABIdx) + "&nvalue=" + svaluemoisture
    # DE.Log(url)
    ret = domoticzrequest(url)
    DE.Log(svaluemoisture)

DE.Log("Palme MakeLAB Moisture Update")
updatemoisture()
```
