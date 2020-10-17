# explore_fastevent_http.py
## domoticz-workbook - function explore_events_dzvents
## Submit in regular intervals less than 1 minute data to domoticz to update an alert sensor.
## A domoticz custom event (explore_fastevent_http) handles the incoming data defined as json by parsing the properties level & text and update the alert sensor.
## The data parameter is a json string. Example: {"level": 4, "text": "Alert Level set to 4"}
## 
## CLI Run Example with output:
##  python3 explore_fastevent_http.py
##  Counter:1, URL:http://127.0.0.1:8080/json.htm?type=command&param=customevent&event=setalert&data={"level": 4, "text": "Alert Level set to 4"}
##  OK Custom Event
##  Counter:2, URL:http://127.0.0.1:8080/json.htm?type=command&param=customevent&event=setalert&data={"level": 4, "text": "Alert Level set to 4"}
##  OK Custom Event
##  Counter:3, URL:http://127.0.0.1:8080/json.htm?type=command&param=customevent&event=setalert&data={"level": 4, "text": "Alert Level set to 4"}
##  OK Custom Event
##  Done
##
## The data received in the domoticz custom event as debug:
## ...Info: SETALERT: {["isJSON"]=true, ["message"]="", ["isXML"]=false, ["data"]="{"level": 4, "text": "Alert Level set to 4"}", ["dump"]=function, ["type"]="customEvent", ["isHTTPResponse"]=false, ["isCustomEvent"]=true, ["isHardware"]=false, ["isSystem"]=false, ["json"]={["text"]="Alert Level set to 4", ["level"]=4}, ["isTimer"]=false, ["isVariable"]=false, ["isSecurity"]=false, ["customEvent"]="setalert", ["trigger"]="setalert", ["status"]="info", ["isDevice"]=false, ["isScene"]=false, ["isGroup"]=false}
## ...Info: SETALERT: Level:4,Text:Alert Level set to 4
##
## Dependencies: explore_fastevent_http.dzvents
## 20201007 rwbl

import json
import requests
import time 

# generate random integer values used to set the alert level between 1 - 4
from random import seed
from random import randint
# seed random number generator
seed(1)
    
## Domoticz ip is local with default port
domoticz_ip = "http://127.0.0.1"
domoticz_port = 8080
custom_event = "setalert"
## Alert device level and text - see function send_request
alert_level = randint(1, 4)
alert_text = "Alert Level set to {}".format(alert_level)
## Loop counter with the delay in seconds between the loop
counter = 0
delay = 10

## Define the json data with keys level (integer) and text (string)
def set_data(level, text):
    data = {}
    data['level'] = level
    data['text'] = text
    return json.dumps(data)

## Send the HTTP API request to domoticz to update the alert device
## In the custom event the idx of the alert device is defined
def send_request():
    # increase the counter
    global counter
    counter = counter + 1
    # define the json data for the custom event request
    # 
    alert_level = randint(1, 4)
    alert_text = "Alert Level set to {}".format(alert_level)
    json_data = set_data(alert_level, alert_text)
    # define the url to signal the domoticz custom event
    url = "{}:{}/json.htm?type=command&param=customevent&event={}&data={}".format(domoticz_ip, domoticz_port, custom_event, json_data)
    print("Counter:{}, URL:{}".format(counter, url))
    # submit the url
    try:
        r = requests.get(url, timeout=3)
        r.raise_for_status()
        # print(r.status_code)                                  # 200
        content_json = json.loads(r.content)
        # print(content_json)                                   # {'status': 'OK', 'title': 'Custom Event'}
        print(content_json['status'], content_json['title'])    # OK Custom Event
    except requests.exceptions.HTTPError as errh:
        print ("Http Error:",errh)
    except requests.exceptions.ConnectionError as errc:
        print ("Error Connecting:",errc)
    except requests.exceptions.Timeout as errt:
        print ("Timeout Error:",errt)
    except requests.exceptions.RequestException as err:
        print ("OOps: Something Else",err)

## main
if __name__ == '__main__':
    while True:
        send_request()
        if counter == 3:
            print("Done\n") 
            quit()
        time.sleep(delay)
