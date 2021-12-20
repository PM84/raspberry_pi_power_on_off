#!/usr/bin/env python


import RPi.GPIO as GPIO
import subprocess
import time


SD_GPIO = 3 # You can not change this pin.
BUTTON_PRESSED_FOR_SEC = 2

GPIO.setmode(GPIO.BCM)
GPIO.setup(SD_GPIO, GPIO.IN, pull_up_down=GPIO.PUD_UP)

while True:
  GPIO.wait_for_edge(SD_GPIO, GPIO.FALLING)
  time.sleep(BUTTON_PRESSED_FOR_SEC)
  if GPIO.input(SD_GPIO) == False:
    subprocess.call(['shutdown', '-h', 'now'], shell=False)
    break

GPIO.cleanup()