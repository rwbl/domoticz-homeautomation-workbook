### Status 20190603

#### NEW: Additional Revolt SF-436 
Installed a Revolt SF-436 to measure power (Watt) & energy (Wh, kWh) for the room MakeLab = working fine.
_Status_
Enhancement: second device to measure the power & energy of the heating system.

#### NEW: Air Quality Monitor
Measure Indoor Air Quality (IAQ) index, temperature, humidity and air pressure
Build solution "Air Quality Monitor" composed out of Tinkerforge Master Brick with WiFi Extension & Bricklets (Air Quality, RGB LED, LCD 20x4).
Information taken from the Tinkerforge [documentation](https://www.tinkerforge.com/en/doc/Hardware/Bricklets/Air_Quality.html#air-quality-bricklet):
Typical applications for the Air Quality Bricklet are the monitoring of air quality, environmental statistics, home automation and similar.
The IAQ index is a measurement for the quality of air.
To calculate the IAQ index the Bricklet detects ethane, isoprene (2-methylbuta-1,3-diene), ethanol, acetone and carbon monoxide (often called VOC, volatile organic components) by adsorption.
These gas measurements are combined with the measurements of air pressure, humidity and temperature to calculate the final IAQ index.
The IAQ index has a range of 0-500:
0-50=good,51-100=average,101-150=little bad,151-200=bad,201-300=worse,301-500=very bad.
The "Air Quality Monitor" hardware will be a Domotizc Python Plugin.
_Status_
Waiting for the Air Qiality Bricklet, received the other required Bricks & Bricklets.

#### NEW: Postbox Watcher
Watch opening the top cover of the postbox and notify if opened.
Same hardware solution as described in chapter "Contact Detection" (X10 devices PB-62R).
_Status_
Ordered a PB-62R.

#### NEW: Control Samsung TV with Tizen OS
Explore if possible to build some basic control (on/off, Volume) as a starter using Node-RED.
_Status_
Tested on the Domoticz development environment, the node [Samsung-TV-MK Node-RED](https://www.npmjs.com/package/node-red-contrib-samsung-tv-mk).

#### NEW: Traffic Light Status Indicator for the Raspberry Pi Domoticz Server (using GPIO)
Monitor the memory & disc space usage and notify.
_Status_
Not started.

#### NEW: Measure CO living room
_Status_
Not started.
Have not found a device yet which is supported by RFXCOM 433MHz and Domoticz.
Will probably not continue as could be covered by the "Air Quality Monitor".

#### NEW: Explore notifications usage other then Email
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
