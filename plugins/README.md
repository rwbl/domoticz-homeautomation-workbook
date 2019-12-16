### Domoticz Python Plugins
Created by the author and used for several functions in the workbook.

#### Installation
For each of the plugins, create a dedicated folder.

Example:
```
/home/pi/domoticz/plugins/hmip-etrv
```

Copy from the plugin archive (i.e. plugin-hmip-etrv), the file **plugin.py** to the new folder

Restart Domoticz.
Example using the CLI:
```
sudo service domoticz.sh restart
```

In the Domoticz WebUI (GUI), use the plugin ith its devices, by adding new hardware
* GUI > Setup > Settings > Hardware/Devices: Accept new Hardware Devices > Allow for 5 Minutes
* GUI > Setup > Hardware
* Select the type, i.e. homematicIP Radiator Thermostat (HmIP-eTRV)
* Set the parameter
* Add
* The devices are created - check the devices list GUI > Setup > Devices
