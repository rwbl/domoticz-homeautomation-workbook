# ToDo domoticz-home-automation-workbook
Status: 20200316

#### FIX: EMail Notification Error: SMTPSEND.BareLinefeedsAreIllegal
Since few weeks, when sending a notification via email, got SMTPSEND error mesage:
```
SMTPSEND.BareLinefeedsAreIllegal; message contains bare linefeeds, which cannot be sent via DATA and receiving system does not support BDAT 
```

Prioriy: High
_Status_
Investigating but no solution found..

#### NEW: Function Notes Delete Selected Log Entry
Delete the selected note from the deive log history.
Tested:
Delete Datapoint HTTP API Request
http://domoticz-ip:8080/json.htm?date=2020-03-15+11:17:28&idx=111&param=deletedatapoint&type=command
NOT WORKING as the function deletedatapoint does not delete from table lightinglog.

Only all device entries can be deleted from table ligthinglog for the given idx.
Clear log entries HTTP API Request
http://domoticz-ip:8080/json.htm?idx=111&param=clearlightlog&type=command

TODO: Find way to delete the selected logentry

Priority: Low
_Status_
Not started

#### NEW: Plugin homematicIP Device HmIP/SWDM
Develop a plugin for the Window and Door Contact with magnet.
These devices are connected to the RaspberryMatic system which communicates via XML-API with Domoticz.

Prioriy: Medium
_Status_
Not started.

#### NEW: Tool DeviceTimerList
To get a list of timers defined for the switch devices.
Select the data via SQL SELECT statements direct from the Domoticz SQLite3 database, i.e. for production database dopro.db.

Prioriy: Low
_Status_
Not started.

#### NEW: Explore using notifications beside Email

Prioriy: Low
_Status_
Not started.

#### NEW: Threshold setting via another UI, i.e. Node-RED or Custom UI
The various thresholds are set by User Variables. Updating can be done either via GUI or HTTP REST Requests.
Seeking for a solution to quickly change the user variable values.
A custom GUI would be a possibility (simple field with update and cancel button).

Prioriy: Low
_Status_
Not started.

#### UPD: Funcion Notes
Consider to autosize the textarea for the note content.
The textarea uses the Domoticz CSS ui_widget.
For now the textarea has size rwos=10 cols=50 which is fine.

Prioriy: Low
_Status_
Not started.

#### UPD: Build house control functions

Prioriy: Medium
_Status_
These are implemented but not shared yet.

#### UPD: Tool Domoticz Internal Script Viewer
Create a Python3 version with a UI library like GUIZero or QT.

Prioriy: Low
_Status_
Not started.

#### NEW: Function Traffic Light Status Indicator for the Raspberry Pi Domoticz Server (using GPIO)
Monitor the memory & disc space usage and notify.

Prioriy: Low
_Status_
Not started.

#### NEW: Function Energy Devices & Rooms
Explore integating a Tinkerforge [Energy Bricklet](https://github.com/Tinkerforge/energy-monitor-bricklet).
This function requires a Tinkerorge Master Brick to be connected to the Domoticz server.

Prioriy: Low
_Status_
Not started.

#### UPD: Function Postbox Notifier
Replace checking operating voltage (datapoint OPERATING_VOLTAGE) by checking low battery state (Datapoint LOW_BAT). See plugin HmIP-eTRV.

Prioriy: Low
_Status_
Not started.

### [TODOS ON HOLD OR STOPPED]
These are kept for reference in case new developments or changes which could be applied.

#### NEW: Test Domoticz on the Raspberry Pi 4 with 4GB
The intention is to test Domoticz and other like Node-RED on the Raspberry Pi 4.

_Status_
STOPPED.
Based on the CPU load of ~3-5% on both the Domoticz production (running since 3 years now) & developed Raspberry Pi 3 boards, dediced not to continue.
An option might be to use other hardware, like Rock Pi S, Intel NUC, Server running Ubuntu.
One issue noticed, is an increase in CPU load if Node-RED flows are used with high interval triggers (like the "e-mail in node" from node-red-node-email).

#### FIX: Function Energy Devices & Rooms - Revolt SF-436.m Range
Installed a Revolt SF-436.m to measure power (Watt) & energy (Wh, kWh) for the room MakeLab.
**Issue**
If the RFXtrx433E is more then about 10 meters range away from the Revolot device, then no data is received else working ok.
Probably rather weak antenna. Explore how to improve the range ELSE consider other solution.
The device is causing high traffic on the 433.92MHz frequency. Sending almost every few seconds data.
The Domoticz log is getting spoiled with data and of course the RFXtrx433E is rather busy.

_Status_
STOPPED.
Been thinking about additional Revolt devices - but regarding issues 1 and 2 will not continue.
Developed & installed a solution using a RaspberryMatic HomeMatic CCU3 with several own developed plugins.

#### NEW: Control Samsung TV with Tizen OS
Explore if possible to build some basic control (on/off, Volume) as a starter using Node-RED.

_Status_
ON HOLD.
Tested on the Domoticz development environment, the node [Samsung-TV-MK Node-RED](https://www.npmjs.com/package/node-red-contrib-samsung-tv-mk).

#### NEW: Function Measure CO living room

_Status_
ON HOLD.
Have not found a device yet which is supported by RFXCOM 433MHz and Domoticz.
Will probably not continue as could be covered by the function "Air Quality Plus".

#### NEW: Connect Sonoff (Itead) devices using ESP Easy

_Status_
ON HOLD.
Tested the Sonoff POW R2 to measure power & energy without success - think made a mistake soldering the IO's to be able to flash ESP Easy.
Will not continue as a) the Revolt SF-436 delivers the same results and b) developed a RaspberryMatic solution which works great.
