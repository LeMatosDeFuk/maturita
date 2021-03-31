#include <SoftwareSerial.h>

SoftwareSerial Arduino_Recieve(D7, D8);
SoftwareSerial Arduino_Send(D5, D6);

void setup() {
  Serial.begin(9600);
  Arduino_Send.begin(9600);
  Arduino_Recieve.begin(9600);
}

void loop() {
  Arduino_Send.write("Hello from ESP!");
  delay(1000);

  String data = Arduino_Recieve.readString();
  Serial.println(data);
}
