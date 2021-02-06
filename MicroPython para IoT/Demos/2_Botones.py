# Referencia para Microbit:
#
# https://microbit-micropython.readthedocs.io/en/latest/index.html
#
from microbit import *

while True:
  if button_a.is_pressed():
    display.show("A")
  elif button_b.is_pressed():
    display.show("B")
