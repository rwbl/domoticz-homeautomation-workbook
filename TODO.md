# ToDo domoticz-home-automation-workbook
Status: 20200612

### NEW: Domoticz Workbook Wiki
The workbook is rather growing. The PDF document has reached in the meantime about 530 pages. 
Considering to create a wiki and publish changes adhoc, instead publishing the PDF document with sources.
Exploring how to do best without the use of a dedicated homepage.
#### Status
Not started

### NEW: Function Shed - Rain Tank Level & Temperature Indicator
Monitor level & temperature rain tank.
#### Status
Not started

### NEW: Ring Doorbell Monitor
Monitor the doorbell using a Ring Doorbell 2 device.
#### Status
Not started

### NEW: Explore Arduino Raspberry Pi communication
#### Status
Not started

### NEW: Automation Event Helper domoticz.py for any device
In folder /home/pi/domoticz/scripts/python, there is a helper Python script domoticz.py.
There logging functions are giving an arguments error and are therefore modified.
In addition exploring how to update Domoticz devices other the switches - not found a way yet.
The modified helper script is called domoticz2.py.
#### Status
Logging modified

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

### NEW: Plugin homematicIP Device HmIP/SWDM
Develop a plugin for the Window and Door Contact with magnet.
These devices are connected to the RaspberryMatic system which communicates via XML-API with Domoticz.
#### Status
Not started.

### NEW: Tool DeviceTimerList
To get a list of timers defined for the switch devices.
Select the data via SQL SELECT statements direct from the Domoticz SQLite3 database, i.e. for production database dopro.db.
**Prioriy**Low
#### Status
Not started.

### NEW: Explore Notifications beside Email
#### Status
Not started.

### NEW: Threshold setting via another UI, i.e. Node-RED or Custom UI
The various thresholds are set by User Variables. Updating can be done either via GUI or HTTP REST Requests.
Seeking for a solution to quickly change the user variable values.
A custom GUI would be a possibility (simple field with update and cancel button).
#### Status
Not started.

### UPD: Function Notes
Consider to autosize the textarea for the note content.
The textarea uses the Domoticz CSS ui_widget.
For now the textarea has size rwos=10 cols=50 which is fine.
#### Status
Not started.

### UPD: Build house control functions
#### Status
These are implemented but not shared yet.

### UPD: Tool Domoticz Internal Script Viewer
Create a Python3 version with a UI library like GUIZero or QT.
#### Status
Not started.

### NEW: Function Traffic Light Status Indicator for the Raspberry Pi Domoticz Server (using GPIO)
Monitor the memory & disc space usage and notify.
#### Status
Not started.

### NEW: Function Energy Devices & Rooms
Explore integrating a Tinkerforge [Energy Bricklet](https://github.com/Tinkerforge/energy-monitor-bricklet).
This function requires a Tinkerorge Master Brick to be connected to the Domoticz server.
#### Status
Not started.

### UPD: Function Postbox Notifier
Replace checking operating voltage (datapoint OPERATING_VOLTAGE) by checking low battery state (Datapoint LOW_BAT).
See plugin HmIP-eTRV.
#### Status
Not started.

## [TODOS ON HOLD OR STOPPED]
These are kept for reference in case new developments or changes which could be applied.

### NEW: Test Domoticz on the Raspberry Pi 4 with 4GB
The intention is to test Domoticz and other like Node-RED on the Raspberry Pi 4.
#### Status
STOPPED.
Based on the CPU load of ~3-5% on both the Domoticz production (running since 3 years now) & developed Raspberry Pi 3 boards, dediced not to continue.
An option might be to use other hardware, like Rock Pi S, Intel NUC, Server running Ubuntu.
One issue noticed, is an increase in CPU load if Node-RED flows are used with high interval triggers (like the "e-mail in node" from node-red-node-email).

### FIX: Function Energy Devices & Rooms - Revolt SF-436.m Range
Installed a Revolt SF-436.m to measure power (Watt) & energy (Wh, kWh) for the room MakeLab.
#### Issue
If the RFXtrx433E is more then about 10 meters range away from the Revolot device, then no data is received else working ok.
Probably rather weak antenna. Explore how to improve the range ELSE consider other solution.
The device is causing high traffic on the 433.92MHz frequency. Sending almost every few seconds data.
The Domoticz log is getting spoiled with data and of course the RFXtrx433E is rather busy.
#### Status
STOPPED.
Been thinking about additional Revolt devices - but regarding issues 1 and 2 will not continue.
Developed & installed a solution using a RaspberryMatic HomeMatic CCU3 with several own developed plugins.

### NEW: Control Samsung TV with Tizen OS
Explore if possible to build some basic control (on/off, Volume) as a starter using Node-RED.
Tested on the Domoticz development environment, the node [Samsung-TV-MK Node-RED](https://www.npmjs.com/package/node-red-contrib-samsung-tv-mk).
#### Status
ON HOLD.

### NEW: Function Measure CO living room
Have not found a device yet which is supported by RFXCOM 433MHz and Domoticz.
Will probably not continue as could be covered by the function "Air Quality Plus".
#### Status
ON HOLD.

### NEW: Connect Sonoff (Itead) devices using ESP Easy
Tested the Sonoff POW R2 to measure power & energy without success - think made a mistake soldering the IO's to be able to flash ESP Easy.
Will not continue as a) the Revolt SF-436 delivers the same results and b) developed a RaspberryMatic solution which works great.
#### Status
ON HOLD.
