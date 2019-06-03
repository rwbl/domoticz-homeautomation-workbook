# domoticz-homeautomation-workbook
Workbook on how to build a Domoticz Home Automation System on a Raspberry Pi.

As a Domoticz Beginner
* Main Purpose to explore and learn Domoticz & Scripting.
* Get an initial Home Automation Solution up & running.
* Write up experiences during development … and build further.

***Notes***
* There might be better solutions for what is shared – solutions might change whilst evolving.
* This is a working document – idea’s & todo’s will never cease to exist.
* The code of scripts & flows is not fully shared or might have changed – check the GitHub scripts folder for the latest full source.
* The scripts are mainly developed using dzVents Lua scripts. Few exceptions using Python.
* There is quite a bit of functionality where Node-RED flows are used. Node-RED is one of my favorite tools – esp. as wanting to learn JavaScript.

### Functions
* Display temperature & humidity measured in rooms.
* Charts for selective weather items, room temperature & humidity.
* Control Somfy roller shutters with RTS motors in rooms.
* Philips Hue Lighting System control via Hue Bridge for ZigBee devices.
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
* Soil Moisture monitor for plants.
* Event monitor for selected devices.
* Custom icons.
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
