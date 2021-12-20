#!/usr/bin/env python


import RPi.GPIO as GPIO
import subprocess

from home.pi.raspberry_pi_power_on_off.config import *

GPIO.setmode(GPIO.BCM)
GPIO.setup(SD_GPIO, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.wait_for_edge(SD_GPIO, GPIO.FALLING)

subprocess.call(['shutdown', '-h', 'now'], shell=False)
