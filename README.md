# domoticz-homeautomation-workbook
To build a Home Automation & Information System, based on the Domoticz Home Automation System, running on the single-board computer Raspberry Pi.

### Objectives
* To Explore & Learn Domoticz & Scripting.
* To build a Home Automation & Information System.
* To write up & share experiences during development.
* To use this workbook as a supplemental reference.

Lookup [Changelog](https://github.com/rwbl/domoticz-homeautomation-workbook/blob/master/CHANGELOG.md).

### Remarks
* **This is a working document**- concept changes, new idea’s & to-do’s whilst progressing.
* There might be better solutions for what is shared - updates or changes depending learning curve.
* Source code for scripts, flows & apps not fully shared or have changed - check the GitHub _src_ folder for latest sources.
* Automation events developed as dzVents Lua script events.
* Domoticz Hardware Plugin development in Python.
* Custom User Interface & Pages with HTML & JavaScript (using jQuery & Bootstrap).
* Some of the functions make initially use of Node-RED flows - but target is to replace by dzVents Lua scripts if possible.
* Functions that have been replaced by another solution are kept in this document as reference – could be of use.
* Screenshots might not be updated as functionality is evolving.
* To-do’s are tagged with <TODO> - The To-do list, with prefix, i.e. NEW, UPD …, are captured in the file TODO.md.
* Device names and other information are in cases in German language as the Domoticz system is used in Germany.

### Functions
(full list see the workbook)
* Air Quality monitor - [Plugin](https://github.com/rwbl/domoticz-plugin-indoor-air-quality-monitor).
* Ambient light (from ESP8266 running ESP Easy) with threshold.
* Charts for selective weather items, room temperature & humidity.
* Climate Environment - UV Index & Category, Pollen Index.
* Coffee machine monitor – start and end time, alert message.
* Control Somfy roller shutters & blinds with RTS motors in several rooms.
* Control Volumio music player whilst listening to web radio.
* Custom icons.
* Custom Pages - simple to more complex examples.
* Display temperature & humidity measured in rooms.
* Electricity power & energy for selected devices / rooms (washer, room MakeLab etc.).
* Electricity power & energy for the house from “volkszaehler” with charts.
* Event monitor for selected devices.
* Garage door monitor.
* Hardware Monitor for the Raspberry Pi's used (see HardwareMonitor.zip).
* HomeMatic (RaspberryMatic) CCU3 integration with variety of devices and plugins [HmIP-eTRV](https://github.com/rwbl/domoticz-plugin-hmip-etrv), [HmIP-PSM](https://github.com/rwbl/domoticz-plugin-hmip-psm).
* Hue Light controlled via ESP8266 with slide potentiometer & 4-digit-7-segment-display.
* MQTT subscribe & publish messages to trigger actions or information.
* MQTT Logger (Node-RED)
* Monitor stock quotes.
* Music Player (using LibreELEC with Kodi).
* Key Dates management and information organised in a roomplan.
* Notes with a subject & content and save, copy or notify.
* Philips Hue Lighting System control via Hue Bridge for ZigBee devices.
* Postbox Notifier.
* RaspberryMatic DutyCycle monitor.
* RaspberryMatic Statelist with devices and datapoints (Node-RED).
* Raspberry Pi system information with charts and threshold email notification.
* Remote Control Domoticz devices using Email client - includes a simple Android test app 
* Security door & window wireless contact detectors.
* Soil Moisture monitor for plants - [Plugin](https://github.com/rwbl/domoticz-plugin-soil-moisture-monitor).
* Time Control to track & control the time spent in hours, per activity block (with start- & end-time) and total/day, on a generic task.
* Timers for single devices or complex tasks (Automation events dzVents).
* [Domoticz Quick Access Mobile](https://github.com/rwbl/domoticz_quick_access_mobile) - customized web frontend to control dedicated functions mainly accessed from mobile  devices.
* Web App Site Control [Info](https://github.com/rwbl/domoticz-webapp-sitecontrol) - Node-RED alternative to the standard Domoticz Web UI (Note: Not developed further as replaced by Web UI Quick Access Mobile).

### Explore
* Domoticz running on a Raspberry Pi (setup, configure).
* Scripting Python, Lua, dzVents, JavaScript.
* Python Plugin Development.
* Handling HTTP JSON/API requests.
* MQTT messaging.
* SQLite3 to understand the Domoticz database structure and to query.
* Connecting & communicating with microcontroller Arduino, ESP8266 and other.
* Integrate ESP Easy with various sensors.
* Raspberry Pi GPIO libraries RPi.GPIO and GPIOZero - CLI, Device Actions, Automation Events, Plugins.
* RFXCOM RFXtrx433E USB RF Transceiver with various devices, i.e. Temperature & Humidity, Wind, Door & Window contacts, Switches.
* Philips Hue Light Control.
* Homematic IP using RaspberryMatic CCU3 and integrate into Domoticz with devices like thermostats, energy measurement, switches, contacts.
* Tinkerforge Building Blocks.
* Domoticz Android App (native client, to be determined).
* Advanced User Interfaces, i.e. Customized User Interface, Custom Webpages, Node-RED, Bootstrap, jQuery.
* External services.

### Credits
To the developers of Domoticz and to all sharing information about Domoticz. Without these, it would not be possible to build this project and write this workbook.

### Disclaimer
THIS DOCUMENT IS PROVIDED BY THE AUTHOR “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR 
TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS DOCUMENT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH 
DAMAGE.
