# domoticz-homeautomation-workbook
Workbook on how to build a Domoticz Home Automation System on a Raspberry Pi.

### Objectives
* To explore and learn the Domoticz Home Automation System.
* Set up a solution from scratch on using two Raspberry Pi 3B+ (production and development server).
* Write up experiences in building the solution … and update any further with new ideas - see To-do list.

### Notes
* This is a working document … solution changes, idea’s & todo’s will probably never cease to exist.
* There might be better solutions for what is shared ... updates or changes will happen as progressing with the learning curve.
* Source code for the scripts & flows not fully shared in this document or have changed … check the GitHub scripts folder for the latest full source code.
* Automation scripts developed as dzVents Lua script events … very few in Python (to be replaced).
* Domoticz Hardware Plugin development in Python.
* Some functions make initially use of Node-RED flows … but target is to replace by dzVents events if possible.
* Functions that have been replaced by another solution are kept in this document as reference – might be of use.
* Screenshots shared might not be update as functionality is evolving.
* To-do’s are tagged with <TODO>. The To-do list, with prefix, i.e. NEW, UPD …, are captured in the file TODO.md.

### Functions
(full list see the workbook)
* Display temperature & humidity measured in rooms.
* Charts for selective weather items, room temperature & humidity.
* Control Somfy roller shutters with RTS motors in rooms.
* Philips Hue Lighting System control via Hue Bridge for ZigBee devices.
* HomeMatic (RaspberryMatic) CCU3 integration with variety of devices.
* Security door & window wireless contact detectors.
* Information on key dates (calendar type information).
* MQTT subscribe & publish messages to trigger actions or information.
* Raspberry Pi system information with charts and threshold email notification.
* Electricity power & energy for the house from “volkszaehler” with charts.
* Electricity power & energy for selected devices / rooms (washer, MakeLab etc.).
* Coffee machine monitor – start and end time, info message.
* Control Volumio music player whilst listening to web radio.
* Monitor stock quotes.
* Ambient light (from ESP8266 running ESP Easy) with threshold.
* Hue Light controlled via ESP8266 with slide potentiometer & 4-digit-7-segment-display.
* Event monitor for selected devices.
* Hardware Monitor for the Raspberry Pi's used (see HardwareMonitor.zip).
* Custom icons.
* Soil Moisture monitor for plants - [Plugin](https://github.com/rwbl/domoticz-plugin-soil-moisture-monitor).
* Air Quality monitor - [Plugin](https://github.com/rwbl/domoticz-plugin-indoor-air-quality-monitor).
* Remote Control Domoticz devices using Email client - includes a simple Android test app 
* _More in progress ..._

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
* homematicIP using RaspberryMatic CCU3 and integrate into Domoticz.
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
