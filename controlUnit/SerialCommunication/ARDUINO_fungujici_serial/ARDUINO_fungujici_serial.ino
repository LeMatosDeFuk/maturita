#include <SoftwareSerial.h>

SoftwareSerial NodeMCU_Send(8, 7);
SoftwareSerial NodeMCU_Recieve(6, 5);

void setup() {
  Serial.begin(9600);
  NodeMCU_Send.begin(9600);
  NodeMCU_Recieve.begin(9600);
}
void loop()
{
    String data = NodeMCU_Recieve.readString();
    Serial.println(data);

    NodeMCU_Send.write("Hello from Arduino!");
    delay(1000);

}
