### Status 20190621

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

#### NEW: Explore using notifications beside Email
_Status_
Not started.

#### NEW: Threshold setting via another UI, i.e. Node-RED or Custom UI
_Status_
Not started.

#### UPD: Build house control functions
_Status_
These are implemented but not shared yet.

#### NEW: Connect Sonoff (Itead) devices using ESP Easy
_Status_
Tested the Sonoff POW R2 to measure power & energy without success - think made a mistake soldering the IO's to be able to flash ESP Easy.
Will probably not continue as the Revolt SF-436 deliver the same results.
ON HOLD.

#### NEW: Function MQTT Monitor
Monitor message payload of topic "domoticz/out" to analyze properties of devices
_Status_
Scribbled a first flow using Node-RED Dashboard UI nodes. Runs on the Domoticz Development server.
