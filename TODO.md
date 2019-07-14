### Status 20190714

#### UPD: Replace BMP280 with BME280
_Status_
Device ordered.

#### NEW: Test Domoticz on the Raspberry Pi 4 with 4GB
_Status_
Device received; testing first other software before installing Domoticz.

#### UPD: Polish up document and some minor updates
* Order the functions chapter alphabetically
* Rename function "Postbox Watcher" to "Postbox Notifier"
* Styling: Code Style to font Consolas,9; Note(s) Style to Italic,11
_Status_
In progress (reordering completed, function Postbox renamed).

#### NEW: Explore using notifications beside Email
_Status_
Not started.

#### NEW: Threshold setting via another UI, i.e. Node-RED or Custom UI
The various thresholds are set by User Variables. Updating can be done either via GUI or HTTP REST Requests.
Seeking for a solution to quickly change the user variable values.
A custom GUI would be a possibility (simple field with update and cancel button).
_Status_
Not started.

#### UPD: Build house control functions
_Status_
These are implemented but not shared yet.

#### UPD: Tool MQTT Logger
Monitor message payload of topic "domoticz/out" to analyze properties of devices.
Flow created using the Node-RED Dashboard UI. Running ok.
To enhance with option to select the MQTT Broker Domoticz Production or Domoticz Development.
_Status_
Not started.

#### NEW: Explore custom UI further
_Status_
In progress.

#### UPD: Tool Domoticz Internal Script Viewer
Create a Python3 version with a UI library like GUIZero or QT.
_Status_
Not started.

#### [TODOS ON HOLD]

#### FIX: Function Energy Devices & Rooms - Revolt SF-436.m Range
Installed a Revolt SF-436.m to measure power (Watt) & energy (Wh, kWh) for the room MakeLab.
**Issues**
1) If the RFXtrx433E is more then about 10 meters range away from the Revolot device, then no data is received else working ok.
Probably rather weak antenna. Explore how to improve the range ELSE consider other solution.
2) The device is causing high traffic on the 433.92MHz frequency. Sending almost every few seconds data.
The Domoticz log is getting spoiled with data and of course the RFXtrx433E is rather busy.
3) Been thinking about additional Revolot devices - but regarding issues 1 and 2 will not continue.
4) Alternatives (need to explore further):
* Tinkerforge upcoming [Energy Bricklet](https://github.com/Tinkerforge/energy-monitor-bricklet)
* HomeMatic CCU3 with plugs = rather expensive, requires interface to Domoticz (MQTT prefferable), if using then add more functionality
_Status_
ON HOLD.

#### NEW: Control Samsung TV with Tizen OS
Explore if possible to build some basic control (on/off, Volume) as a starter using Node-RED.
_Status_
Tested on the Domoticz development environment, the node [Samsung-TV-MK Node-RED](https://www.npmjs.com/package/node-red-contrib-samsung-tv-mk).
ON HOLD.

#### NEW: Function Traffic Light Status Indicator for the Raspberry Pi Domoticz Server (using GPIO)
Monitor the memory & disc space usage and notify.
_Status_
Not started.

#### NEW: Function Measure CO living room
_Status_
Not started.
Have not found a device yet which is supported by RFXCOM 433MHz and Domoticz.
Will probably not continue as could be covered by the function "Air Quality Plus".
ON HOLD.

#### NEW: Connect Sonoff (Itead) devices using ESP Easy
_Status_
Tested the Sonoff POW R2 to measure power & energy without success - think made a mistake soldering the IO's to be able to flash ESP Easy.
Will probably not continue as the Revolt SF-436 deliver the same results.
ON HOLD.
