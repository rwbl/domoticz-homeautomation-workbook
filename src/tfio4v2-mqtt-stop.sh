#!/bin/bash
## File:	tfio4v2-mqtt-stop.sh
## Attributes: make the script executable: sudo chmod +x tfio4v2-mqtt-stop.sh
## 20200301 rwbL

cd /home/pi/domoticz/scripts/python
# stop the service
echo service stopping...
sudo systemctl stop tfio4v2-mqtt.service
# check if stopped
echo check if stopped...
echo no entry should be listed line: pi 14621 1  0 19:16 ? 00:00:00 /usr/bin/python3 -u tfio4v2-mqtt
ps -ef | grep tfio4v2-mqtt
echo done