#!/usr/bin/python3
# -*- coding: utf-8 -*-
"""
gpio_cleanup
Cleanup GPIO ports. 
The ports used by the various scripts are setup and cleanup at the end. Any LEDs are turned off.
20200610 rwbl
"""
import RPi.GPIO as GPIO

# Cleanup GPIO ports
def gpio_cleanup():
    print("RPi.GPIO Cleanup")
    # GPIO pin numbers
    LEDPIN = 18
    BUTTONPIN = 23
    try:  
        GPIO.setmode(GPIO.BCM)
        GPIO.setwarnings(False)
        GPIO.setup(LEDPIN,GPIO.OUT)
        GPIO.setup(BUTTONPIN, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
    except:  
        # this catches ALL other exceptions including errors.  
        print("Other error or exception occurred!"  )
    finally:  
        GPIO.cleanup() # this ensures a clean exit  
        print("RPi.GPIO ports cleaned up.")

if __name__ == "__main__":
    gpio_cleanup()
    quit()
