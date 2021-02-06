# Referencia para Microbit:
#
# https://microbit-micropython.readthedocs.io/en/latest/index.html
#
from microbit import *
import random

#Dado virtual, al mover el board, desplegaremos un numero aleatorio entre 1 y 6

while True:

    if accelerometer.was_gesture('shake'):
        display.show(random.randint(1, 6))

