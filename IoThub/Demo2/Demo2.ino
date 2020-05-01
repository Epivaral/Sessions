// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

// Please use an Arduino IDE 1.6.8 or greater

#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>
#include <WiFiUdp.h>
#include <Servo.h>

#include <AzureIoTHub.h>
#include <AzureIoTProtocol_MQTT.h>
#include <AzureIoTUtility.h>

#include "config.h"

static bool messagePending = false;
static bool messageSending = true;


Servo servoAbajo;  // Definimos el objecto Servo
Servo servoArriba;  // Definimos el objecto Servo
const int PinServoAbajo = 2; //GPIO que usaremos para controlar el servo de abajo
const int PinServoArriba = 4; //GPIO que usaremos para controlar el servo de abajo

const int TRIG_PIN = 5; //GPIO que manda el pulso al sensor
const int ECHO_PIN = 14; //GPIO que recibe el pulso del sensor

// una distancia mayor de 400 cm (23200 us) esta fuera de rango
const unsigned int MAX_DIST = 23200;


void initTime()
{
  /*
  mas info en
  https://lastminuteengineers.com/esp32-ntp-server-date-time-tutorial/
  */
    time_t epochTime;
    configTime(0, 0, "pool.ntp.org", "time.nist.gov");

    while (true)
    {
        epochTime = time(NULL);

        if (epochTime == 0)
        {
            delay(2000);
        }
        else
        {
            break;
        }
    }
}



// Variables de conexion, cambiar para cada dispositivo
static char *connectionString = DeviceConnStr;
static char *ssid = my_SSID;
static char *pass = my_PWD;


static int interval = INTERVAL;



void initWifi()
{
    // Attempt to connect to Wifi network:
  
    // Connect to WPA/WPA2 network. Change this line if using open or WEP network:
    WiFi.begin(ssid, pass);
    while (WiFi.status() != WL_CONNECTED)
    {
       
        WiFi.begin(ssid, pass);
        delay(10000);
    }
}

static IOTHUB_CLIENT_LL_HANDLE iotHubClientHandle;
void setup()
{
    pinMode(TRIG_PIN, OUTPUT);

    servoAbajo.attach(PinServoAbajo);  // Inicializamos el objeto Servo en el pin elegido
    servoArriba.attach(PinServoArriba);  // Inicializamos el objeto Servo en el pin elegido
  

    delay(2000);
    initTime();
    initWifi();

    /*
     * AzureIotHub library remove AzureIoTHubClient class in 1.0.34, so we remove the code below to avoid
     *    compile error
    */

    // initIoThubClient();
    iotHubClientHandle = IoTHubClient_LL_CreateFromConnectionString(connectionString, MQTT_Protocol);
    if (iotHubClientHandle == NULL)
    {
        
        while (1);
    }

    //IoTHubClient_LL_SetOption(iotHubClientHandle, "product_info", "HappyPath_AdafruitFeatherHuzzah-C");
    IoTHubClient_LL_SetMessageCallback(iotHubClientHandle, receiveMessageCallback, NULL);
    IoTHubClient_LL_SetDeviceMethodCallback(iotHubClientHandle, deviceMethodCallback, NULL);
    IoTHubClient_LL_SetDeviceTwinCallback(iotHubClientHandle, twinCallback, NULL);
}

static int messageCount = 1;
void loop()
{
    if (!messagePending && messageSending)
    {
        char messagePayload[MESSAGE_MAX_LEN];
        bool ValueAlert = readMessage(messageCount, messagePayload);
        sendMessage(iotHubClientHandle, messagePayload, ValueAlert);
        messageCount++;
        delay(interval);
    }
    IoTHubClient_LL_DoWork(iotHubClientHandle);
    delay(10);
}
