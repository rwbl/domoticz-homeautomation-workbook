Status 20190516

NEW: Power measurement using a Revolt SF-436 [requires rfxtrx type2 firmware, ELEC5 protocol] (or other).
Status:
Device ordered.

NEW: Samsung TV with Tizen OS - explore if possible to build some basic control (on/off, Volume) as a starter.
Status:
Tested on the Domoticz development environment (RPi) the Node-RED nodes https://www.npmjs.com/package/node-red-contrib-samsung-tv-mk .

NEW: Hardware Plugin for Tinkerforge Master Brick & selected Bricklets.
Status:
Not started.

NEW: Traffic Light Status Indicator for the Raspberry Pi Domoticz Server (using GPIO).
Status: Not started.

NEW: Measure CO living room.
Status: Not started.

NEW: Notifications Explore usage of notifications other then Email (Status: Not started).
Status: Not started.

NEW: Thresholds Set threshold via another UI, i.e. Node-RED or Custom UI (Status: Not started).
Status: Not started.

UPD: Build house control functions.
Status: These are implemented but not shared yet.

NEW: Connect Sonoff (Itead) devices using ESP Easy software.
Status:
Sonoff device and FTDI converter (3.3v connection) ordered.
Important to set mode DOUT!
Use the ESP Easy flasher:
* Do not connect power to the Sonoff
* Press and keep the button down on the Sonoff
* Connect the FTDI Adapter
* Release the button on the Sonoff
* Flash
* Disconnect the Sonoff from the FTDI adapter

Manage the Sonoff from ESP Easy via HTTP.
Sonoff parameter:
Relay Switch = GPIO 12 (D6)
Device Button = GPIO 0 (D3)
Green LED = GPIO 13 

Read more here: https://www.letscontrolit.com/wiki/index.php/Sonoff_basic

<and many more to explore/>
