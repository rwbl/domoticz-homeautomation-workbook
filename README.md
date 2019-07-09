# domoticz-homeautomation-workbook
Workbook on how to build a Domoticz Home Automation System on a Raspberry Pi.

### Objectives
* To explore and learn the Domoticz Home Automation System.
* Set up a solution from scratch on using two Raspberry Pi 3B+ (production and development server).
* Write up experiences in building the solution … and update any further with new ideas - see To-do list.

### Notes
* There might be better solutions for what is shared and might change whilst evolving
* This is a working document – idea’s & to-do’s will (probably) never cease to exist.
* The source code of scripts & flows is not fully shared or might have changed – check the scripts folder for the latest full source.
* The scripts are mainly developed using dzVents Lua scripts. Few exceptions using Python.
* Python is used for creating hardware plugins (with HomeMatic, Tinkerforge).
* Several functions are using Node-RED flows.

### Functions
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
