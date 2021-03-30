#include <SoftwareSerial.h>

SoftwareSerial Arduino(D6, D7);

int temp, humi;
String str;
void setup() {
  Serial.begin(9600);
  Arduino.begin(9600);
}

void loop() { // run over and over
  Arduino.write("Hello from ESP");

  if (Arduino.available() > 0) {
    String data = Arduino.readString();
    Serial.println(data);
  }
}
