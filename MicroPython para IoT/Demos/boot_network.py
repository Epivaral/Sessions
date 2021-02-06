#imports
import esp
esp.osdebug(None)

import gc
gc.collect()

from time import time

import network

try:
  import usocket as socket
except:
  import socket
  
 #fin imports 

sta_if = network.WLAN(network.STA_IF)


if sta_if.active() == False: # validamos si STATION esta activado o no
  sta_if.active(True)
  
sta_if.connect('<SSID>', '<PWD>')
print('Conectando...')

t = time()

while sta_if.isconnected() == False:
  if(time()-t)>10: #timeout de n segundos para evitar bloquear el board
    break

   
  
if sta_if.active():
  print('Station Activado')
  print(sta_if.ifconfig())
