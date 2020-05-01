
#include <ArduinoJson.h>


int Lectura =0; //lectura obtenida del divisor del voltage de la fotoresistencia

//----------------------------------------
float SensorDist()
{
  unsigned long t1;
  unsigned long t2;
  unsigned long ancho_pulso;
  float cm;

  // mandamos un pulso por 10 milisegundos
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);

  // esperamos a que el pulso regrese
  while ( digitalRead(ECHO_PIN) == 0 );

  // La funcion micros mide el tiempo desde que el programa inicia, ocurre un overflow cada 70 minutos
  t1 = micros(); 
  while ( digitalRead(ECHO_PIN) == 1); // se mide cuanto tiempo estuvo en HIGH el pin de eco
  t2 = micros();
  ancho_pulso = t2 - t1; //obtenemos la longitud del pulso

  
  cm = ancho_pulso / 58.0; //Constante obtenida del datasheet del sensor HC-SR04 para obtener centimetros

  return (cm);
  
 }
//----------------------------------------



bool readMessage(int messageId, char *payload)
{
  //lecturas que deseas enviar al IoT hub
  
    Lectura = SensorDist();


    
    StaticJsonBuffer<MESSAGE_MAX_LEN> jsonBuffer;
    JsonObject &root = jsonBuffer.createObject();
    root["deviceId"] = DEVICE_ID;
    root["messageId"] = messageId;
    bool ValueAlert = false;

    if (std::isnan(Lectura))
    {
        root["Valor"] = NULL;
    }
    else
    {
        root["Valor"] = Lectura;
        if (Lectura > VALUE_ALERT)
        {
            ValueAlert = true;
        }
    }

    root.printTo(payload, MESSAGE_MAX_LEN);
    return ValueAlert;
}

void parseTwinMessage(char *message)
{
    StaticJsonBuffer<MESSAGE_MAX_LEN> jsonBuffer;
    JsonObject &root = jsonBuffer.parseObject(message);
    if (!root.success())
    {
        return;
    }

    if (root["desired"]["interval"].success())
    {
        interval = root["desired"]["interval"];
    }
    else if (root.containsKey("interval"))
    {
        interval = root["interval"];
    }
}
