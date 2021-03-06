# Changelog domoticz-home-automation-workbook

### 20201115
* NEW: Utility Dashboard - Heating, Power, Water dashboard using Grafana & FlowCharting plugin. This is a process engineering prototype (SCADA).
* NEW: Weather Forecast - Custom Page with Highcharts Custom Chart 9-DAY FORECAST for a selected location with data from the Norwegian Meteorological Institute (Meteorologisk).
* NEW: Explore Grafana & InfluxDB - Basic dashboard with two panels displaying gauges & line charts for 3 devices. Explored InfluxLink; dzVents InfluxDB HTTP API using curl.
* UPD: Explore RaspberryMatic - Thermostat HmIP-eTRV-2 Script handling multiple datapoint requests for multiple devices.
* UPD: Explore RaspberryMatic - Release 3.53.34.20201121.
* UPD: Various smaller enhancements & corrections.
* FIX: Function Hardware Monitor - fixed get RAM data for Raspberry Pi OS.

### 20201122
* NEW: Explore Custom Charts - First examples Custom Pages with Highcharts & Google Charts embedded for single & multiple devices.
* UPD: Function Temperature & Humidity (TFA TS34C) - Hint on how to replace the batteries and keep the log history.
* UPD: Various smaller enhancements & corrections.

### 20201025
* NEW: Function Battery Status - Daily check & notify for all devices (Domoticz & External Systems) the battery level against a threshold set via user variable.
* NEW: Function Custom Settings - Custom page to change the value of selective user variables.
* NEW: Function Device Status - Custom page to quickly view the status, i.e. all device attributes, of a used device.
* NEW: Document IDEAS.md to capture any ideas which might gets implemented in the workbook.
* UPD: [Domoticz Quick Access Mobile](https://github.com/rwbl/domoticz_quick_access_mobile). See CHANGELOG.md.
* UPD: Document TODO.md to only keep actions for next workbook version. Any other to capture in IDEAS.md.
* UPD: Various corrections.

### 20201017
* NEW: Function Indoor Air Quality - Measure in regular intervals, the IAQ Index, assign to a custom sensor (measuring VOC) and set the color of a Hue White & Color Ambiance bulb accordingly.
* NEW: Function Philips Hue - Various on how to set the color using color wheel, RGB, change every min for 2 secs.
* NEW: Function Radiator Thermostat - Solution using Domoticz Thermostat Setpoint device with scripts & automation events (Homematic IP, dzVents Lua, no Python plugins required).
* NEW: Function Remote Control - Integrated Homematic IP 8 buttons device (HmIP-RC8) connected to RaspberryMatic CCU triggering Automation Event (dzVents) for specific functions.
* NEW: Explore Events dzVents - Fast Event Less One Minute using HTTP API triggered by Python script with Custom Event dzVents.
* UPD: Explore RaspberryMatic - Release 3.53.30.20200919.
* UPD: Various smaller enhancements & corrections.
* INF: Function Web UI Quick Access Mobile - Not updated further as replaced by dedicated solution [Domoticz Quick Access Mobile](https://github.com/rwbl/domoticz_quick_access_mobile). 

### 20200912
* NEW: Function BME280 Temp+Hum+Baro - Monitor server room Temp+Hum. Baro for air pressure weather. Timer triggered.
* NEW: Function Garage Door Monitor - Open|Close state provided by Raspberrymatic with Homematic IP SWDM device.
* NEW: Function Key Dates Calendar JSON - New Concept using JSON showing sorted key dates as Alert devices in a room plan. The previous CSV solution kept for reference.
* NEW: Function RaspberryMatic Duty Cycle Monitor - Monitor the Raspberrymatic systemvariable DutyCycle and log error if above threshold.
* NEW: Function Web UI Quick Access Mobile - First version of a customized web frontend to control dedicated functions mainly accessed from mobile smartphones devices.
* NEW: Explore Custom Pages - Example external plugin JustGage embedded in a Bootstrap responsive grid.
* NEW: Explore Custom UI - Create a custom UI. Started by building a Bootstrap grid example based on locally stored latest Bootrap library.
* UPD: Function Air Pressure (BME280) - Automation event trigger changed from device to timer as device changes happen N times/minute. dzVents script reworked. Replaced see below.
* UPD: Function Climate Environment - UV Index & Category, Pollen Index with date; Data in German, Removed city & date in device name.
* UPD: Function Hardware Monitor - GPIO LCD Display with Information System start, stop, CPU Usage&Temp, HDD Usage, Memory Usage.
* UPD: Function River Elbe Tide - Converted solution from Node-RED to Automation Event dzVents Lua.
* UPD: Explore Custom Pages - Reworked chapter & examples; Added hints.
* UPD: Various smaller enhancements & corrections.
* INF: Function Air Pressure (BME280) - Replaced by function BME280 Temp+Hum+Baro.

### 20200817
* NEW: Function Climate Environment - UV Index & Category, Pollen Index.
* NEW: Function Hardware Monitor - GPIO LCD Display, RGB LED Status Indicator.
* NEW: Explore GPIO - GPIOZero Plugin RGBLED.
* NEW: Explore GPIO - LCD I2C Control (Python script) with examples clock, hardware monitor & timer/device events.
* UPD: Explore ESP Easy - Firmware update, chapter reworked.
* UPD: Explore RaspberryMatic - Release 3.51.6.20200621.
* UPD: User Variables - List using SQLite3.
* UPD: Various smaller enhancements & corrections.
* INF: Domoticz Development Raspberry Pi 3B+ replaced by a Raspberry Pi 4B with Raspberry OS Version 10 (Buster) - no issues during setup encountered.

### 20200612
* FIX: EMail Notification Error: SMTPSEND.BareLinefeedsAreIllegal with Outlook - reinstalled Domoticz.
* NEW: Explore Events dzVents Lua - Solutions for timer update less one minute (Timer,Device,MQTT).
* NEW: Explore GPIO - Use GPIO with Raspberry Pi Python libraries RPi.GPIO (CLI, Device Actions, Automation Events, Plugins) & GPIOZero (Plugins) and (just to test) Node-RED flow.
* UPD: Function Notes - Explored alternative solution using User Variables (not used further).
* UPD: Explore SQL - Update device examples.

### 20200526
* NEW: Function Music Player - Control Kodi music player(s) by a single automation event (dzVents Lua) and several virtual sensors.
* NEW: Function Notes: Export the notes file (JSON format) to local file (text format).
* NEW: Function Radiator Thermostat - Simple solution using the Domoticz devices Select Switch & Thermostat with a single automation event (dzVents Lua, no Python plugins required).
* NEW: Explore Kodi Music Player - Explore setting up Kod Music Player and communicate/control by Domoticz
* NEW: Explore RaspberryMatic - Monitor the CCU Duty Cycle Monitor two separate solutions Node-RED Dashboard and Domoticz Dashboard.
* UPD: Explore Node-RED - Reworked chapter and the example flows; added new flow Domoticz as Node-RED data logger.
* UPD: Explore RaspberryMatic - Release 3.51.6.20200420.

### 20200318
* NEW: Explore Custom Pages - First examples setting & getting data; Alert Message, Quick Check Raspberry Pi data, Switch Light.
* NEW: Explore SQL - read from file; execute sql-command-line using Lua; more examples.
* NEW: Explore Tinkerforge - Various concepts how to interact between Domoticz and the [Tinkerforge](http://www.tinkerforge.com) Building Blocks.
* NEW: Function Notes - Create notes with a subject & content and save, copy or notify.
* NEW: Function Philips Hue - Examples to direct access a device using HTTP API.
* NEW: Function Time Control - Track & control time spent in hours, per activity block (with start- & end-time) and total/day, on a generic task.
* NEW: Tool: RaspberryMatic Statelist - Obtain the datapoint id's for all RaspberryMatic devices configured on the CCU.
* UPD: Explore MQTT > Python: Scripts reworked.
* UPD: Explore RaspberryMatic - Release 3.51.6.20200229; Additional examples to get data & set Domoticz devices.
* UPD: Function [Domoticz Web App Site Control](https://github.com/rwbl/domoticz-webapp-sitecontrol) - Dark theme instead default light blue.
* UPD: Function Hardware Monitor - fixed get RAM data for Raspberry Pi Buster.
* UPD: Function Postbox Notifier - At midnight reset notification in case not done manually.
* UPD: Function Waste Calendar - Renamed to Key Dates Calendar as also including other key dates in the list. Removed interval entry.
* UPD: Tool MQTT Logger - Node-RED solution completely reworked; select MQTT broker Domoticz Production or Development.
* UPD: Setup > Raspberry Pi > Samba - Added full log installing Samba and set share.
* UPD: User Variables > List > Python: Script reworked; improved error handling for the request, HTTP & URL.
* UPD: Various chapters reviewed and smaller updates including scripts, flows.

### 20200112
* NEW: Function [Domoticz Web App Site Control](https://github.com/rwbl/domoticz-webapp-sitecontrol) - Node-RED based GUI.

### 20191222
* NEW: Function Roomplan - Created roomplans with associated devices; defined device naming convention
* NEW: Function Timers - Started to use timers for simple tasks like thermostat setting setpoint or switch on|off
* NEW: Function Postbox Notifier - Solution with Alert + Switch + Voltage
* NEW: Explore RaspberryMatic - Added more push & pull examples; HTTP XML-API URL replaced config by addons
* NEW: Explore RaspberryMatic - Experiment Node-RED dashboard with two radiator thermostats
* UPD: Explore Events - bundled testscripts to files explore_automation_events*.md
* UPD: Explore Node-RED - updated installation information as Node-RED installation/update script has changed (Linux Installers for Node-RED)
* UPD: Function Radiator Thermostat reworked; new plugin HmIP-eTRV; Timers to control heating; New device valve position
* UPD: Explore SQL - Chapter reworked and added more SQL select examples
* UPD: TODO.md
* UPD: Various smaller enhancements & corrections

### 20191207
* NEW: Function EMail Control - Experiment to Remote Control Domoticz devices using Email client - includes simple Android test app
* NEW: Function River Elbe Tide - watch the tide of the river "Elbe" at "Schulau" near Hamburg Germany
* NEW: Function Radiator Thermostat HMIP-eTRV-2 - Event to ensure not heating overnight (switch off)
* NEW: Function Stock Quotes - Automation script (dzVents Lua) instead Node-RED flow (disabled)
* UPD: Function BMP280 - Sensor replaced by BME280 (T+H+P), function renamed & automation scripts updated
* UPD: Function Postbox Watcher - Renamed to Postbox Notifier; new second solution with reset switch
* UPD: Function RaspberryMatic - update 3.47.22.20191130 
* NEW: Explore RaspberryMatic - Reworked, added more examples using the XML-API addon
* NEW: Explore ESP Easy - ESP BMP280 to Domoticz
* UPD: Explore ESP Easy - Firmware update, chapter reviewed and polished up 
* UPD: Coffee Machine Monitor - User Variable to set the power threshold
* UPD: Setup - Added ethernet configuration and network overview
* UPD: Functions and Explore - Reordered chapters
* UPD: Various smaller enhancements & corrections

### 20190709
* NEW: Explore RaspberryMatic CCU solution, addons XML-API & CUxD and Domoticz integration
* NEW: Function Electric Usage Rooms/Devices - RaspberryMatic CCU with device HMIP-PSM (Plugin)
* NEW: Function Radiator Thermostat - RaspberryMatic CCU with device HMIP-eTRV-2 (Plugin)
* NEW: Function Postbox Watcher - RaspberryMatic CCU with device HMIP-SDWO
* NEW: User Variables - List with Python3 script
* UPD: Alert Message - improved dzVents Lua scripts; Alert Level 4 sends Email notifications
* UPD: Various smaller enhancements & corrections

### 20190621
* NEW: Function Hardware Monitor for all Raspberry Pi's used.
* NEW: Function Indoor Air Quality Monitor - Plugin. See [more](https://github.com/rwbl/domoticz-plugin-indoor-air-quality-monitor)
* NEW: Appendix Tools MQTT Logger - Log and analyse Domoticz MQTT messages (topic domoticz/out),  Node-RED flow
* UPD: Function Custom Icons reworked
* UPD: Explore Python Plugin Development - Hints on Domoticz log errors
* UPD: Various smaller enhancements & corrections

### 20190603
* NEW: Function Contact Detection - using X10 devices PB-62R
* NEW: Function Event Monitor - keep a log for changes for selected devices
* NEW: Hardware Python Plugin - showcase [Traffic Light](https://github.com/rwbl/domoticz-plugin-traffic-light) interacting with Tinkerforge Brick & Bricklets, for functions using Tinkerforge Building Blocks (i.e. Soil Moisture Monitor, Air Quality Plus)
* NEW: Power & Energy Monitoring - started but work in progress
* NEW: Electricity Device & Rooms - implemented measuring room MakeLab with Revolt SF-436
* UPD: Electricity House - complete rework of the solution
* UPD: Soil Moisture Monitor - (Hardware Python Plugin) improved error handling, changed UID parameter setting (based on showcase Traffic Light)
* UPD: User Variables - database table info, list of variables updated
* UPD: Explore SQL - installed the SQLite3 package with examples
* UPD: Explore ESP Easy - Experiment Ambient Light enhanced with LED indicator
* UPD: To-do list
* UPD: Various smaller enhancements & corrections
* INF: _The more exploring, the more fun it makes_

### 20190516
* NEW: Explore ESP Easy - added chapters to update firmware, set / view rules logging
* NEW: Explore ESP Easy - added preferred solution to control Hue Light Brightness via Potentiometer using dummy devices and rule with SendToHTTP command
* UPD: Explore ESP Easy - reworked the experiments documentation tobe consistent (purpose,parts,circuit,esp easy,domoticz)
* NEW: Explore ESP8266 - Hue light remote control = small fun project to tinker with microcontrollers and connected devices (programming an ESP8266 microcontroller in C++ using the Arduino IDE)
* NEW: Explore API Interaction: Example Syntax HTTP vs MQTT 
* UPD: RFXCOM - Prepare RFXtrx433E
* UPD: Function Volumio - changed Volumio Bookmark switch type from On/Off to Push On Button
* UPD: Function Volumio - changed Volumio Refresh switch type from On/Off to Push On Button
* UPD: Various minor corrections

### 20190310

* NEW: Shared helper functions for dzVents scripts global_data.lua. Replaces the libraries utils.lua & msgbox.lua
* UPD: Function Stock Quotes renamed to Stock Monitor
* NEW: Function Stock Monitor - Device Total Stock Value
* NEW: Explore ESP Easy - Rules example LED triggered by Ambient Light Lux threshold

### 20190301

* NEW: Function Volumio - Control using dzVents scripts (in addition to the Node-RED solution)
* NEW: Custom Icons - first two custom icons used by the Function Volumio (in file CustomIcons.zip)
* UPD: User Variable section
* NEW: Added all generated dzVents scripts (Lua files) to the scripts folder

### 20190227

* NEW: Function Ambient Light w/ threshold. The Ambient Light is connected to a ESP8266 NodeMCU running ESPEasy
* NEW: Function Hue Lights - Control the lights via Node-RED Dashboard UI
* NEW: User Variables - Example how to use Node-RED Dashboard UI to set threshold value
* UPD: Function Volumio - Node-RED Reworked checking Volumio server response (using ping)
* FIX: Function Hue Lights - Bug in dzVents script Timed Switch Light

### 20190218

* NEW: Function Monitor Stock Quotes - Obtain quotes from [Alpha Vantage](https://www.alphavantage.co), set thresholds with notifications, Roomplan, Node-RED Dashboard
* UPD: Reworked User Variables section

### 20190212

* NEW: Function Volumio Web Radio - Listen to & control, via Domoticz Dashboard, Web Radio provided by Volumio
* NEW: Appendix Tools - Domoticz Internal Script Viewer
* UPD: Appendix TODO List and the specific TODOs in the document

### 20190207

* NEW: First version published
