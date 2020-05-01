// Para controlar el Servo, usamos la libreria Servo.h incluida en el instalador del Arduino IDE

/*
 * funcion para realizar alguna accion utilizando metodo mensaje Cloud to Device (C2D)
 */
void realizarAccionC2D(char *mensaje)
{
    //asumimos que el mensaje recibido es un entero
    int numero = atoi(mensaje); 
  
    //realizamos cualquier accion que querramos, en este caso la intensidad del led (0-1024)
    analogWrite(LED_PIN, numero); //Led_pin se encuentra en config.h
}

/*
 *  Funciones para realizar alguna accion utlizando Direct Method
 *  Por defecto creamos los metodos Start y Stop para el envio de data
 */

void start()//Start y Stop funcionan sin parametros
{
    messageSending = true;
}

void stop()//Start y Stop funcionan sin parametros
{
    messageSending = false;
}

void MoverServoArriba(char *mensaje)
{
  int posicion = atoi( mensaje );
  int actual = servoArriba.read();
  servoArriba.write(actual + posicion);
}

void MoverServoAbajo(char *mensaje)
{
  int posicion = atoi( mensaje );
  int actual = servoAbajo.read();
  servoAbajo.write(actual + posicion);
}
