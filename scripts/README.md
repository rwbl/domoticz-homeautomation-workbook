## Domoticz Homeautomation Workbook Scripts

### dzVents
The files with extension _.lua_ are the generated dzVents scripts used. All scripts are maintained via the Domoticz Web UI Event Editor.

The files are created by the tool [Domoticz Internal Script Viewer](https://github.com/rwbl/domoticz-internal-script-viewer).

The unused scripts are under review of what will be shared.

### Lua Libraries
The files _utils.lua_ and _msgbox.lua_ are external libraries containing helper functions (included in the internal dzVents scripts using the key word _require_).
***NOTE***: These libaries are not used anymore and replaced by the internal shared helper _global_data.lua_.

### Node-RED
The files with exsention _.flow_ are Node-RED flows.
The flows can be inported in Node-RED via the settings menu > import (paste).

### Python
The files with extension _.py_ are function specific. 

### ESP Easy
The files with extension _.rule_ are ESP Easy rules.

### Archives
The files with extension _.zip_ are archives named as the function.
The archive contains the required files with subfolders.
Example: emailcontrol.zip.

