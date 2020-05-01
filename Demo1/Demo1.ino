#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>
#include <WiFiUdp.h>

#include <AzureIoTHub.h>
#include <AzureIoTProtocol_MQTT.h>
#include <AzureIoTUtility.h>

#include "config.h"

static bool messagePending = false;
static bool messageSending = true;



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
    initTime();
    initWifi();

    iotHubClientHandle = IoTHubClient_LL_CreateFromConnectionString(connectionString, MQTT_Protocol);
    if (iotHubClientHandle == NULL)
    {
        while (1);
    }
    
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
