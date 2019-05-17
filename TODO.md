### Status 20190516

NEW: Power measurement using a Revolt SF-436 [requires rfxtrx type2 firmware, ELEC5 protocol] (or other).
_Status_
Device ordered.

NEW: Samsung TV with Tizen OS - explore if possible to build some basic control (on/off, Volume) as a starter.
_Status_
Tested on the Domoticz development environment (RPi) the Node-RED nodes https://www.npmjs.com/package/node-red-contrib-samsung-tv-mk .

NEW: Hardware Plugin for Tinkerforge Master Brick & selected Bricklets.
_Status_
Not started.

NEW: Traffic Light Status Indicator for the Raspberry Pi Domoticz Server (using GPIO).
_Status_
Not started.

NEW: Measure CO living room.
_Status_
Not started.
Have not found a device yet which is supported by RFXCOM 433MHz and Domoticz.

NEW: Notifications Explore usage of notifications other then Email (Status: Not started).
_Status_
Not started.

NEW: Thresholds Set threshold via another UI, i.e. Node-RED or Custom UI (Status: Not started).
_Status_
Not started.

UPD: Build house control functions.
_Status_
These are implemented but not shared yet.

NEW: Connect Sonoff (Itead) devices using ESP Easy software.
_Status_
Sonoff device and FTDI converter (3.3v connection) ordered [20190516].
Planned to use the ESP Easy flasher as outlined in my  Domoticz Home Automation workbook chapter Explore ESP Easy.
Steps like...
* Do not connect power to the Sonoff
* Press and keep the button down on the Sonoff
* Connect the FTDI Adapter
* Release the button on the Sonoff
* Flash
* Disconnect the Sonoff from the FTDI adapter
Important to set mode DOUT!

Manage the Sonoff from ESP Easy via HTTP.
Sonoff parameter:
Relay Switch = GPIO 12 (D6)
Device Button = GPIO 0 (D3)
Green LED = GPIO 13 

Read more here: https://www.letscontrolit.com/wiki/index.php/Sonoff_basic

<and many more to explore/>
