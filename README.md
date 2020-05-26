# domoticz-homeautomation-workbook
To build a Home Automation & Information System, based on the Domoticz Home Automation System, running on the single-board computer Raspberry Pi.

### Objectives
* Explore & learn Domoticz & Scripting.
* Build a Home Automation & Information System.
* Write up & share experiences during development.
* Use this workbook as a supplemental reference.
* Lookup [url=https://github.com/rwbl/domoticz-homeautomation-workbook/blob/master/CHANGELOG.md]Changelog[/url].

### Remarks
* **This is a working document**- concept changes, new idea’s & to-do’s whilst progressing.
* There might be better solutions for what is shared - updates or changes depending learning curve.
* Source code for scripts, flows & apps not fully shared or have changed - check the GitHub _src_ folder for latest sources.
* Automation events developed as dzVents Lua script events.
* Domoticz Hardware Plugin development in Python.
* Custom pages with JavaScript.
* Some of the functions make initially use of Node-RED flows - but target is to replace by dzVents Lua scripts if possible.
* Functions that have been replaced by another solution are kept in this document as reference – could be of use.
* Screenshots might not be updated as functionality is evolving.
* To-do’s are tagged with <TODO> - The To-do list, with prefix, i.e. NEW, UPD …, are captured in the file TODO.md.
Abbreviations: GUI = Domoticz UI in browser, HmIP = homematicIP,

### Functions
(full list see the workbook)
* Air Quality monitor - [Plugin](https://github.com/rwbl/domoticz-plugin-indoor-air-quality-monitor).
* Ambient light (from ESP8266 running ESP Easy) with threshold.
* Charts for selective weather items, room temperature & humidity.
* Coffee machine monitor – start and end time, info message.
* Control Somfy roller shutters with RTS motors in rooms.
* Control Volumio music player whilst listening to web radio.
* Custom icons.
* Custom Pages - simple to more complex examples.
* Display temperature & humidity measured in rooms.
* Electricity power & energy for selected devices / rooms (washer, room MakeLab etc.).
* Electricity power & energy for the house from “volkszaehler” with charts.
* Event monitor for selected devices.
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
* RaspberryMatic Statelist with devices and datapoints (Node-RED).
* Raspberry Pi system information with charts and threshold email notification.
* Remote Control Domoticz devices using Email client - includes a simple Android test app 
* Security door & window wireless contact detectors.
* Soil Moisture monitor for plants - [Plugin](https://github.com/rwbl/domoticz-plugin-soil-moisture-monitor).
* Time Control to track & control the time spent in hours, per activity block (with start- & end-time) and total/day, on a generic task.
* Timers for single devices or complex tasks (Automation events dzVents).
* Web App Site Control [Info](https://github.com/rwbl/domoticz-webapp-sitecontrol) - Node-RED alternative to the standard Domoticz Web UI.

### Explore How To Use
* Domoticz running on a Raspberry Pi (setup, configure).
* Scripting Python, Lua, dzVents, JavaScript.
* Python Plugin Development (mainly with Tinkerforge Building Blocks)
* API interaction
* MQTT messaging
* Node-RED as an alternative script engine and User Interface.
* SQLite
* ESP8266
* ESP Easy for sensors.
* RFXCOM RFXtrx433E USB RF Transceiver for Temperature & Humidity devices, External Wind device (only for RFXCOM tests), Other 433Mhz devices, i.e. door & window contacts.
* Philips Hue Light Control.
* Homematic IP using RaspberryMatic CCU3 and integrate into Domoticz.
* External services
* Domoticz Android App (native client, to be determined).
* Advanced User Interfaces, i.e. Node-RED, Bootstrap …

### Credits
To the developers of Domoticz and to all sharing information about Domoticz. Without these, it would not be possible to build this project and write the workbook.

### Disclaimer
THIS DOCUMENT IS PROVIDED BY THE AUTHOR “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR 
TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH 
DAMAGE.
