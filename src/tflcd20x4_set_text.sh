#!/bin/bash
cd /home/pi/domoticz/scripts/python

python3 tflcd20x4_set_text.py '{"UID":"BHN", "LCDLINES":[{"line":0,"position":1,"clear":1,"text":"Text 0"},{"line":1,"position":1,"clear":1,"text":"Text 1"},{"line":2,"position":1,"clear":1,"text":"Text 2"},{"line":3,"position":1,"clear":1,"text":"Text 3"}]}'

# python3 tflcd20x4_set_text.py {"UID":"BHN", "LCDLINES":[{"line":1,"position":n,"clear":n,"text":"Text"}]}
# python3 tflcd20x4_set_text.py '{"UID":"BHN", "LCDLINES":[{"line":1,"position":n,"clear":n,"text":"Text"},{"line":2,"position":n,"clear":n,"text":"Text"},{"line":3,"position":n,"clear":n,"text":"Text"},{"line":4,"position":n,"clear":n,"text":"Text"}]}'



