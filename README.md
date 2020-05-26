## Domoticz Homeautomation Workbook - Source

Information related to the files in the folder **src**.
All files are lowercase except the HTML custom pages files whuch use capitalize.

### Archives
The files with extension _.zip_ are archives named as the function.
The archive contains the required files with subfolders.
Example: email_control.zip.

### dzVents
The files with extension _.lua_ are the generated dzVents scripts used. All scripts are maintained via the Domoticz Web UI Event Editor.

The files are created by the tool [Domoticz Internal Script Viewer](https://github.com/rwbl/domoticz-internal-script-viewer).

The unused scripts are under review of what will be shared.

### ESP Easy
The files with extension _.rule_ are ESP Easy rules.

### Explore Scripting
The files _explore_automation_events_name.md_ contain various test or initially used scripts, whilst exploring dzVents Lua, Lua, Python and Blockly.
These scripts are not used anymore but kept as learning reference.

### HTML
The files with extension _.html_ are custom pages from the chapter "Explore Custom Pages".

### Lua Libraries
The files _utils.lua_ and _msgbox.lua_ are external libraries containing helper functions (included in the internal dzVents scripts using the key word _require_).
***NOTE***: These libaries are not used anymore and replaced by the internal shared helper _global_data.lua_.

### Node-RED
The files with extension _.flow_ are Node-RED flows.
The flows can be inported in Node-RED via the settings menu > import (paste).

### Python
The files with extension _.py_ are function specific. 
Example: The files starting with _sql-_ are Python test scrpts for SQL operations.

### RaspberryMatic
The files with extension _.script_ are RaspMatic scripts used in various function and chapter "Explore RaspberryMatic".

### Tinkerforge
The files starting with _tf_ are scripts (dzVents, Python, Bash) from the chapter "Explore Tinkerforge".
