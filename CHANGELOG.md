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
