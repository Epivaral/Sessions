using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Azure.Devices;

namespace WinformsIoT
{
    class IoTcalls
    {
        public static string ReturnMessage = "";
        //Declare the class to send methods to devices
        private static ServiceClient s_serviceClient;

        // Connection string for your IoT Hub
        private readonly static string s_connectionString = "<IoThubConnectionString>";


        public static async Task MueveServo(string Servo, string dir)
        {
            s_serviceClient = ServiceClient.CreateFromConnectionString(s_connectionString);
            

            CloudToDeviceMethod methodInvocation = new CloudToDeviceMethod(Servo) { ResponseTimeout = TimeSpan.FromSeconds(10) };
            methodInvocation.SetPayloadJson(dir);

            // Invoke the direct method asynchronously and get the response from the device.
            CloudToDeviceMethodResult response = await s_serviceClient.InvokeDeviceMethodAsync("<YourDevice>", methodInvocation);

            ReturnMessage = response.GetPayloadAsJson();
        }
    }
}
