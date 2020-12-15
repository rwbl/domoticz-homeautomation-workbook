# domoticz-home-automation-workbook - Ideas
Any ideas captured which might get implemented in the workbook.

### FIX: Function Energy Devices & Rooms - Revolt SF-436.m Range
Installed a Revolt SF-436.m to measure power (Watt) & energy (Wh, kWh) for the room MakeLab.
#### Issue
If the RFXtrx433E is more then about 10 meters range away from the Revolot device, then no data is received else working ok.
Probably rather weak antenna. Explore how to improve the range ELSE consider other solution.
The device is causing high traffic on the 433.92MHz frequency. Sending almost every few seconds data.
The Domoticz log is getting spoiled with data and of course the RFXtrx433E is rather busy.
#### Status
Been thinking about additional Revolt devices - but regarding issues 1 and 2 will not continue.
Developed & installed a solution using a RaspberryMatic HomeMatic CCU3 with several own developed plugins.

### NEW: Control Samsung TV with Tizen OS
Explore if possible to build some basic control (on/off, Volume) as a starter using Node-RED.
Tested on the Domoticz development environment, the node [Samsung-TV-MK Node-RED](https://www.npmjs.com/package/node-red-contrib-samsung-tv-mk).
This is more out of curiosity rather than using.
#### Status
Open

### NEW: Connect Sonoff (Itead) devices using ESP Easy
Tested the Sonoff POW R2 to measure power & energy without success - think made a mistake soldering the IO's to be able to flash ESP Easy.
#### Status
Will probably not continue as a) the Revolt SF-436 delivers the same results and b) developed a RaspberryMatic solution which works great.

### NEW: Ring Doorbell Monitor
Monitor the doorbell using a Ring Doorbell 2 device.
#### Status
The Ring Doorbell uses the Ring App on the in-use Android & iOS devices.
Do not think it makes sense to integrate into Domoticz, may be just out of curiosity.

### NEW: Plugin acting as GPIO Middleware
A GPIO Plugin as an enabler for several functions, i.e. acting as kind of "GPIOMiddleware".
The GPIO has various devices connected, i.e. LED, LCD display, switch, push-button, sensors...
The GPIOMiddleware can than be used by various dzVents automation scripts depending function.
#### Status
Not sure if this should be pursued, as want to connect GPIO devices to an Arduino or ESP device.
Think these devices are more suitable for GPIO kind of tasks.
Communication with the Domoticz system via LAN/WLAN HTTP API or MQTT.

### UPD: GPIOZero Handle Exceptions
Improve GPIOZero exception handling as described here: https://gpiozero.readthedocs.io/en/stable/api_exc.html
#### Status
Open

### NEW: Explore Arduino Raspberry Pi communication
Idea is to use the Arduino for sensors whilst the Domoticz production system focus on running Domoticz & Node-RED.
#### Status
The chapter Explore ESPEasy outlines how to integrate ESP devices via MQTT.
See this as the target solution for communication with an ESP device rather than an Arduino.

### NEW: Domoticz Workbook Wiki
The workbook is rather growing. The PDF document has reached in the meantime almost 700 pages. 
Considering to create a wiki and publish changes adhoc, instead publishing the PDF document with sources.
Exploring how to do best without the use of a dedicated homepage, i.e. export the PDF document & automatic creation of GitHub pages.
#### Status
Still not make up my mind:
Having a full PDF document as reference is rather practical as single source of information, can be used offline and easier to maintain.

### NEW: Explore Domoticz Standalone
Setup a Domoticz system on a Raspberry Pi without Internet connection.
Use the system to control sensors & actuators.
Idea: RPi to control a simple Model Railroad.
#### Status
Open

### NEW: Automation Event Helper domoticz.py for any device
In folder /home/pi/domoticz/scripts/python, there is a helper Python script domoticz.py.
There logging functions are giving an arguments error and are therefore modified.
The modified helper script is called domoticz2.py.
In addition exploring how to update Domoticz devices other than switches - not found a way yet.
#### Status
Logging modified. Script called domoticz2.py.

### NEW: Function Notes Delete Selected Log Entry
Delete the selected note from the device log history. The note is stored in a text device.
**Tested**
Deleted a datapoint from a graph and checked via browser developer settings (F12) the URL used by Domoticz.
Then tried for a text device with idx=111:
```
http://domoticz-ip:8080/json.htm?date=2020-03-15+11:17:28&idx=111&param=deletedatapoint&type=command
```
Thought if possible to delete a datapoint via graph, then give a try for a text device.
Checked the Domoticz source main\SQLHelper.cpp, function CSQLHelper::DeleteDataPoint.
This function applies to the tables Rain, Wind, UV, Temperature, Meter, MultiMeter, Percentage, Fan and their _Calendar tables.
The text device data is stored in table lightinglog which is not supported by the function deletedatapoint.
Only ALL device entries can be deleted from table ligthinglog for the given idx.
Example to clear all log entries for idx=111 using HTTP API request:
```
http://domoticz-ip:8080/json.htm?idx=111&param=clearlightlog&type=command
```
#### Status
Waiting for any new Domoticz releases to check out if possible to use the function deletedatapoint for table lightinglog.
An option could be to use a Python script with parameter to delete entries from table lightinglog.
Another idea is to create a Custom Page solution using a JSON file to store the notes.

### NEW: Plugin homematicIP Device HmIP/SWDM
Develop a plugin for the Window and Door Contact with magnet.
These devices are connected to the RaspberryMatic system which communicates via XML-API with Domoticz.
#### Status
Will probably not pursue as the solution in place is based on a RaspberryMatic programm with script triggering a Domoticz Custom Event.
This is working fine. For an example, see function Garage Door Monitor.

### NEW: Tool DeviceTimerList
To get a list of timers defined for the switch devices.
Select the data via SQL SELECT statements direct from the Domoticz SQLite3 database, i.e. for production database dopro.db.
#### Status
Will not pursue because all timer events are handled by Automation Events dzVents.

### UPD: Tool Domoticz Internal Script Viewer
Create a Python3 version with a UI library like GUIZero or QT.
#### Status
Open

### NEW: Function Traffic Light Status Indicator for the Raspberry Pi Domoticz Server (using GPIO)
Monitor the memory & disc space usage and notify.
#### Status
Open.
