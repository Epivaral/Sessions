using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Microsoft.Azure.EventHubs;
using System.Threading;

namespace WinformsIoT
{
    public partial class ControlarServos : Form
    {
     
        public ControlarServos()
        {
            InitializeComponent();
        }

        // Event Hub-compatible name
        private readonly static string s_eventHubsCompatibleEndpoint = "<>";

        
        // az iot hub show --query properties.eventHubEndpoints.events.path --name {your IoT Hub name}
        private readonly static string s_eventHubsCompatiblePath = "<>";

        // az iot hub policy show --name service --query primaryKey --hub-name {your IoT Hub name}
        private readonly static string s_iotHubSasKey = "<>";
        private readonly static string s_iotHubSasKeyName = "service";
        private static EventHubClient s_eventHubClient;

        private async Task ReceiveMessagesFromDeviceAsync(string partition, CancellationToken ct)
        {

            var eventHubReceiver = s_eventHubClient.CreateReceiver("$Default", partition, EventPosition.FromEnqueuedTime(DateTime.Now));

            while (true)
            {
                if (ct.IsCancellationRequested) break;
                // Check for EventData - this methods times out if there is nothing to retrieve.
                var events = await eventHubReceiver.ReceiveAsync(100);

                // If there is data in the batch, process it.
                if (events == null) continue;

                foreach (EventData eventData in events)
                {
                    string data = Encoding.UTF8.GetString(eventData.Body.Array);
                    //Console.WriteLine("Message received on partition {0}:", partition);
                    //Console.WriteLine("  {0}:", data);
                    textBox1.AppendText(data);
                }
            }
        }




        EventHubsConnectionStringBuilder connectionString;
        EventHubRuntimeInformation runtimeInfo;
        string[] d2cPartitions;
        CancellationTokenSource cts;


        private async void ControlarServos_Load(object sender, EventArgs e)
        {
            HabilitaControles(false);

            connectionString = new EventHubsConnectionStringBuilder(new Uri(s_eventHubsCompatibleEndpoint), s_eventHubsCompatiblePath, s_iotHubSasKeyName, s_iotHubSasKey);
            s_eventHubClient = EventHubClient.CreateFromConnectionString(connectionString.ToString());

            // Create a PartitionReciever for each partition on the hub.
            runtimeInfo = await s_eventHubClient.GetRuntimeInformationAsync();
            d2cPartitions = runtimeInfo.PartitionIds;
            cts = new CancellationTokenSource();

            HabilitaControles(true);

            foreach (string partition in d2cPartitions)
            {
                await ReceiveMessagesFromDeviceAsync(partition, cts.Token);
            }


        }

        private void HabilitaControles(bool valor)
        {
            btnAder.Enabled = valor;
            btnAizq.Enabled = valor;
            btnUder.Enabled = valor;
            btnUizq.Enabled = valor;
            label1.Visible = !valor;
        }

        private async void btnAizq_Click(object sender, EventArgs e)
        {
            textBox1.AppendText(Environment.NewLine);
            textBox1.AppendText("Servo abajo <<");
            try
            {
                await IoTcalls.MueveServo("MoverServoAbajo", "10"); //llamamos a la funcion IoT 
                textBox1.AppendText(Environment.NewLine);
                textBox1.AppendText(IoTcalls.ReturnMessage); // Obtenemos el resultado
            }
            catch
            {
                HabilitaControles(false);

            }
            

        }


        private async void btnUizq_Click(object sender, EventArgs e)
        {
            textBox1.AppendText(Environment.NewLine);
            textBox1.AppendText("Servo arriba <<");
            try
            {
                await IoTcalls.MueveServo("MoverServoArriba", "-10"); //llamamos a la funcion IoT
                textBox1.AppendText(Environment.NewLine);
                textBox1.AppendText(IoTcalls.ReturnMessage); // Obtenemos el resultado
            }
            catch
            {
                HabilitaControles(false);
            }
            

        }

        private async void btnUder_Click(object sender, EventArgs e)
        {
            textBox1.AppendText(Environment.NewLine);
            textBox1.AppendText("Servo arriba >>");
            try
            {
                await IoTcalls.MueveServo("MoverServoArriba", "10"); //llamamos a la funcion IoT
                textBox1.AppendText(Environment.NewLine);
                textBox1.AppendText(IoTcalls.ReturnMessage); // Obtenemos el resultado
            }
            catch
            {
                HabilitaControles(false);
            }
        }

        private async void btnAder_Click(object sender, EventArgs e)
        {
            textBox1.AppendText(Environment.NewLine);
            textBox1.AppendText("Servo abajo >>");
            try
            {
                await IoTcalls.MueveServo("MoverServoAbajo", "-10"); //llamamos a la funcion IoT
                textBox1.AppendText(Environment.NewLine);
                textBox1.AppendText(IoTcalls.ReturnMessage); // Obtenemos el resultado
            }
            catch
            {
                HabilitaControles(false);
            }
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            HabilitaControles(true);
        }
    }
        
}
