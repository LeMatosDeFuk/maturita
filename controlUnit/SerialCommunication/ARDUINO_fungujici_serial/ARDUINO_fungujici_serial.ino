#include <SoftwareSerial.h>

SoftwareSerial NodeMCU(7, 6);
int temp, humi;
String str;
void setup() {
  Serial.begin(9600);
  NodeMCU.begin(9600);
}
void loop()
{
  humi = 150;
  temp = 132;
  str = String('H') + String(humi) + String('T') + String(temp);

  if (NodeMCU.available() > 0) {
    Serial.println(str.c_str());
    NodeMCU.write(str.c_str());
    delay(1000);
  }
}
