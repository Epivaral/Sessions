import time
from machine import Pin
import dht

sensor = dht.DHT22(Pin(14))

temp = 0
humedad = 0


def web_page():
  html = """<html>
<body><h1>DHT 22</h1>
<HR/>
  <p>"""+str(temp)+""" grados<p>
  <p>"""+str(humedad)+""" %</p>
  </body></html>"""
  return html

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(('', 80))
s.listen(5)

while True:
    
    conn, addr = s.accept()
    print('Conexion desde %s' % str(addr))
    request = conn.recv(1024)
    
    try:
        sensor.measure()
        temp = sensor.temperature()
        humedad = sensor.humidity()
        time.sleep_ms(500) #agregamos un delay para poder preparar la proxima lectura
    except OSError as e:
        print('error de lectura')
        
    response = web_page()
    conn.send('HTTP/1.1 200 OK\n')
    conn.send('Content-Type: text/html\n')
    conn.send('Connection: close\n\n')
    conn.sendall(response)
    conn.close()

