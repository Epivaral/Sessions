static WiFiClientSecure sslClient; // for ESP8266

const char *onSuccess = "\"Successfully invoke device method\"";
const char *notFound = "\"No method found\"";


static void sendCallback(IOTHUB_CLIENT_CONFIRMATION_RESULT result, void *userContextCallback)
{
    if (IOTHUB_CLIENT_CONFIRMATION_OK == result)
    {
       //blinkLED();
       messagePending = false;
    }
    
    messagePending = false;
}

static void sendMessage(IOTHUB_CLIENT_LL_HANDLE iotHubClientHandle, char *buffer, bool ValueAlert)
{
    IOTHUB_MESSAGE_HANDLE messageHandle = IoTHubMessage_CreateFromByteArray((const unsigned char *)buffer, strlen(buffer));
    if (messageHandle == NULL)
    {
        messagePending = false;
    }
    else
    {
        MAP_HANDLE properties = IoTHubMessage_Properties(messageHandle);
        Map_Add(properties, "Value Alert", ValueAlert ? "true" : "false");
        if (IoTHubClient_LL_SendEventAsync(iotHubClientHandle, messageHandle, sendCallback, NULL) == IOTHUB_CLIENT_OK)
        {
            messagePending = true;
        }

        IoTHubMessage_Destroy(messageHandle);
    }
}


/*
 *  empieza mensaje recibido usando C2D
 */
IOTHUBMESSAGE_DISPOSITION_RESULT receiveMessageCallback(IOTHUB_MESSAGE_HANDLE message, void *userContextCallback)
{
    IOTHUBMESSAGE_DISPOSITION_RESULT result;
    const unsigned char *buffer;
    size_t size;
    if (IoTHubMessage_GetByteArray(message, &buffer, &size) != IOTHUB_MESSAGE_OK)
    {
        
        result = IOTHUBMESSAGE_REJECTED;
    }
    else
    {
        /*buffer is not zero terminated*/
        char *temp = (char *)malloc(size + 1);

        if (temp == NULL)
        {
            return IOTHUBMESSAGE_ABANDONED;
        }

        strncpy(temp, (const char *)buffer, size);
        temp[size] = '\0';
        
        realizarAccionC2D(temp); //accion utilizando metodo mensaje Cloud to Device (C2D)
        
        free(temp);
        //blinkLED();
        
    }
    return IOTHUBMESSAGE_ACCEPTED;
}

/*
 *  termina mensaje recibido usando C2D
 */



/*
 * Empieza mensaje recibido usando direct method
 */

int deviceMethodCallback(
    const char *methodName,
    const unsigned char *payload,
    size_t size,
    unsigned char **response,
    size_t *response_size,
    void *userContextCallback)
{
    const char *responseMessage = onSuccess;
    int result = 200;

    char *temp = (char *)malloc(size + 1);

    if (temp == NULL)
    {
        return IOTHUBMESSAGE_ABANDONED;
    }

    strncpy(temp, (const char *)payload, size);
        temp[size] = '\0';

    if (strcmp(methodName, "start") == 0)
    {
        start();
    }
    else if (strcmp(methodName, "stop") == 0)
    {
        stop();
    }
    else if (strcmp(methodName, "MoverServoArriba") == 0)
    {
        
        MoverServoArriba(temp);
    }
    else if (strcmp(methodName, "MoverServoAbajo") == 0)
    {
        
        MoverServoAbajo(temp);
    }
    else
    {
        responseMessage = notFound;
        result = 404;
    }

    *response_size = strlen(responseMessage);
    *response = (unsigned char *)malloc(*response_size);
    strncpy((char *)(*response), responseMessage, *response_size);

    return result;
}

void twinCallback(
    DEVICE_TWIN_UPDATE_STATE updateState,
    const unsigned char *payLoad,
    size_t size,
    void *userContextCallback)
{
    char *temp = (char *)malloc(size + 1);
    for (int i = 0; i < size; i++)
    {
        temp[i] = (char)(payLoad[i]);
    }
    temp[size] = '\0';
    parseTwinMessage(temp);
    free(temp);
}
