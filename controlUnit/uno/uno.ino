#include <SoftwareSerial.h>
SoftwareSerial NodeMCU(12, 13);

const int humiditySensor1 = 3; // left top
const int waterPump1 = 5; // left top

const int humiditySensor2 = 4; // right bottom
const int waterPump2 = 6; // right bottom

const int humiditySensor3 = A1; // left bottom
const int waterPump3 = 7; // left bottom

const int humiditySensor4 = A0; // right top
const int waterPump4 = 8; // right top

const int photoResistor = A2;
const int waterSensor = A3;

void setup() {
  Serial.begin(9600);
  NodeMCU.begin(9600);

  //  pinMode(waterPump1, OUTPUT);
  //  digitalWrite(waterPump1, LOW);
  //  delay(2000);
  //  digitalWrite(waterPump1, HIGH);

  //  pinMode(waterPump2, OUTPUT);
  //  digitalWrite(waterPump2, LOW);
  //  delay(2000);
  //  digitalWrite(waterPump2, HIGH);

  //  pinMode(waterPump3, OUTPUT);
  //  digitalWrite(waterPump3, LOW);
  //  delay(2000);
  //  digitalWrite(waterPump3, HIGH);


  pinMode(humiditySensor1, INPUT);
  pinMode(humiditySensor2, INPUT);
  pinMode(humiditySensor3, INPUT);
  pinMode(humiditySensor4, INPUT);

  pinMode(photoResistor, INPUT);
  pinMode(waterSensor, INPUT);
}

String getPostData() {
  String temperature = "0";
  String humidity1 = "0";
  String humidity2 = "0";
  String humidity3 = "0";
  String humidity4 = "0";
  String lighting = "0";
  String waterLevel = "0";

  temperature = getTemperatureValues();
  humidity1 = getHumidity1Values();
  humidity2 = getHumidity2Values();
  humidity3 = getHumidity3Values();
  humidity4 = getHumidity4Values();
  lighting = getLightingValues();
  waterLevel = getWaterLevelValues();
  Serial.println("_____________________________________________________");

  return "temperature=" + temperature + "&humidity1=" + humidity1  + "&humidity2=" + humidity2  + "&humidity3=" + humidity3  + "&humidity4=" + humidity4 + "&lighting=" + lighting + "&waterLevel=" + waterLevel;
}

String getLightingValues() {
  float photoSensorValue = analogRead(photoResistor);

  return String(photoSensorValue);
}

String getTemperatureValues() {
  int temperature = 32;

  return String(temperature);
}

String getHumidity1Values() {
  float humidity = analogRead(humiditySensor1);
  humidity = 100 - (humidity / 1024) * 100;

  return String(humidity);
}


String getHumidity2Values() {
  float humidity = analogRead(humiditySensor2);
  humidity = 100 - (humidity / 1024) * 100;

  return String(humidity);
}


String getHumidity3Values() {
  float humidity = analogRead(humiditySensor3);
  humidity = 100 - (humidity / 1024) * 100;

  return String(humidity);
}


String getHumidity4Values() {
  float humidity = analogRead(humiditySensor4);
  humidity = 100 - (humidity / 1024) * 100;

  return String(humidity);
}

String getWaterLevelValues() {
  float waterLevel = analogRead(waterSensor);
  waterLevel = (waterLevel / 1024) * 100;

  return String(waterLevel);
}

void loop() {
  String data = getPostData();
  Serial.println(data.c_str());
  if (NodeMCU.available() > 0) {
    Serial.println(data.c_str());
    NodeMCU.write(data.c_str());
    delay(1000);
  }
}
