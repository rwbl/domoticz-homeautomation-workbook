# explore_fastevent_http_2.py
## domoticz-workbook - function explore_events_dzvents
## Submit in regular intervals less than 1 minute data to domoticz to update an alert sensor.
## A domoticz custom event (explore_fastevent_http) handles the incoming data defined as json by parsing the properties level & text and update the alert sensor.
## The data parameter is a filename.
## The file contains a json string. Example: {"level": 4, "text": "Alert Level set to 4"}
## 20201009 rwbl

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
custom_event = "setalert2"
file_name = "explore_fastevent_http_2.json"
## Alert device level and text - see function send_request
alert_level = randint(1, 4)
alert_text = "Alert Level set to {}".format(alert_level)
## Loop counter with the delay in seconds between the loop
counter = 0
maxcount = 3
delay = 10

## Define the json data with keys level (integer) and text (string)
def set_data(level, text):
    data = {}
    data['level'] = level
    data['text'] = text
    return json.dumps(data)

def create_file(level, text):
    f = open(file_name,"w+")
    f.write(set_data(level, text))
    f.close()
    print(set_data(level, text))

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
    create_file(alert_level, alert_text)
    json_data = file_name
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
        if counter == maxcount:
            print("Done\n") 
            quit()
        time.sleep(delay)
