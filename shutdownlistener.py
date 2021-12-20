#!/usr/bin/env python


import RPi.GPIO as GPIO
import subprocess
import os
from config import *

GPIO.setmode(GPIO.BCM)
GPIO.setup(SD_GPIO, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.wait_for_edge(SD_GPIO, GPIO.FALLING)

subprocess.call(['shutdown', '-h', 'now'], shell=False)
