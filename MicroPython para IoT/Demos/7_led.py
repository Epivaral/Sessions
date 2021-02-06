from machine import Pin

led = Pin(2, Pin.OUT)


def web_page():
  html = """<html><head><meta name="viewport" content="width=device-width, initial-scale=1"></head>
  <body><h1>control de LED ESP8266</h1><a href=\"?led=on\"><button>ON</button></a>&nbsp;
  <a href=\"?led=off\"><button>OFF</button></a></body></html>"""
  return html

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(('', 80))
s.listen(5)

while True:
  try:
    if gc.mem_free() < 102000:
      gc.collect()
    conn, addr = s.accept()
    conn.settimeout(3.0)
    print('Conexion desde %s' % str(addr))
    request = conn.recv(1024)
    conn.settimeout(None)
    request = str(request)
    led_on = request.find('/?led=on')
    led_off = request.find('/?led=off')
    if led_on == 6:
      print('LED ON')
      led.value(0)
    if led_off == 6:
      print('LED OFF')
      led.value(1)
    response = web_page()
    conn.send('HTTP/1.1 200 OK\n')
    conn.send('Content-Type: text/html\n')
    conn.send('Connection: close\n\n')
    conn.sendall(response)
    conn.close()
  except OSError as e:
    conn.close()
