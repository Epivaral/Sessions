#include <ArduinoJson.h>

bool readMessage(int messageId, char *payload)
{
    int Lectura =0;
    
    //lecturas que deseas enviar al IoT hub
  
    int obtenerADC = analogRead(PINADC);
  
    Lectura = obtenerADC; //Mensaje a enviar

    
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
