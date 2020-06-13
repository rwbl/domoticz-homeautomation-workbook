#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
gpio_ledonoff.py
Turn an LED, connected to GPIO18, on & off via the command line.
Wiring:
LED = RPi
Signal = Pin #12 - GPIO18
GND = Pin #6 - GND
Dependencies:
RPi.GPIO library
Run:
python3 gpio_ledonoff.py ON
Number of arguments: 2 arguments.
Argument List: ['gpio_ledonoff.py', 'ON']
LED State:  ON

20200609 rwbl
"""
import RPi.GPIO as GPIO
import sys

# GPIO pin number
GPIOPIN = 18
# LED object
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(GPIOPIN,GPIO.OUT)

def switch_led(argv):
    print('Number of arguments:', len(sys.argv), 'arguments.')
    if (len(sys.argv) < 2):
        print("Wrong number of arguments.")
        return
    print('Argument List:', str(sys.argv))
    state = sys.argv[1].upper()
    if (state == "ON"):
        GPIO.output(GPIOPIN,GPIO.HIGH)
    elif (state == "OFF"):
        GPIO.output(GPIOPIN,GPIO.LOW)
    else:
        state = "UNKNOWN"
    print("LED State: ",state)

if __name__ == "__main__":
    switch_led(sys.argv[2:])
    quit()

