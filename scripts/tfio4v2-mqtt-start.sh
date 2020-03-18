#!/bin/bash
## File:	tfio4v2-mqtt-start.sh
## Attributes: make the script executable: sudo chmod +x tfio4v2-mqtt-start.sh
## 20200301 rwbL

cd /home/pi/domoticz/scripts/python
# start the service
echo Starting...
sudo systemctl start tfio4v2-mqtt.service
# check if running
echo check if running...
echo entry should be listed line: pi 14621 1  0 19:16 ? 00:00:00 /usr/bin/python3 -u tfio4v2-mqtt
ps -ef | grep tfio4v2-mqtt
echo done