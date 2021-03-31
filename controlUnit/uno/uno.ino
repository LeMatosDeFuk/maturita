#include <SoftwareSerial.h>
#include <ArduinoJson.h>

SoftwareSerial NodeMCU_Send(8, 7);
SoftwareSerial NodeMCU_Recieve(6, 5);

const int humiditySensor1 = 19; // left top
const int waterPump1 = 12; // right bottom

const int humiditySensor2 = 18; // right bottom
const int waterPump2 = 11; // left bottom

const int humiditySensor3 = 17; // right top
const int waterPump3 = 10; // left top

const int humiditySensor4 = 2; // left bottom
const int waterPump4 = 9; // right top

const int photoResistor = A0;
const int waterSensor = A3;
const int temperatureSensor = A1;

void setup() {
  Serial.begin(9600);
  NodeMCU_Send.begin(9600);
  NodeMCU_Recieve.begin(9600);

  pinMode(waterPump1, OUTPUT);
  pinMode(waterPump2, OUTPUT);
  pinMode(waterPump3, OUTPUT);
  pinMode(waterPump4, OUTPUT);
  digitalWrite(waterPump1, HIGH);
  digitalWrite(waterPump2, HIGH);
  digitalWrite(waterPump3, HIGH);
  digitalWrite(waterPump4, HIGH);

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

  return "temperature=" + temperature + "&humidity1=" + humidity1  + "&humidity2=" + humidity2  + "&humidity3=" + humidity3  + "&humidity4=" + humidity4 + "&lighting=" + lighting + "&waterLevel=" + waterLevel;
}

String getLightingValues() {
  float lightValue = analogRead(photoResistor);
  lightValue = (lightValue / 1024) * 100;

  return String(lightValue);
}

String getTemperatureValues() {
  int Vo;
  float R1 = 100000;
  float logR2, R2, T, temperature;
  float c1 = 1.009249522e-03, c2 = 2.378405444e-04, c3 = 2.019202697e-07;

  Vo = analogRead(temperatureSensor);
  R2 = R1 * (1023.0 / (float)Vo - 1.0);
  logR2 = log(R2);
  T = (1.0 / (c1 + c2 * logR2 + c3 * logR2 * logR2 * logR2));
  temperature = T - 273.15;

  return String(temperature);
}

String getHumidity1Values() {
  int humidity = digitalRead(humiditySensor1);
  return String(humidity);
}


String getHumidity2Values() {
  int humidity = digitalRead(humiditySensor2);
  return String(humidity);
}


String getHumidity3Values() {
  int humidity = digitalRead(humiditySensor3);
  return String(humidity);
}

String getHumidity4Values() {
  int humidity = digitalRead(humiditySensor4);
  return String(humidity);
}

String getWaterLevelValues() {
  float waterLevel = analogRead(waterSensor);
  waterLevel = (waterLevel / 1024) * 100;

  return String(waterLevel);
}

void loop() {
  // Send sensor data
  String data = getPostData();
  NodeMCU_Send.write(data.c_str());
  Serial.println(data.c_str());
  delay(1000);

  // Read actions
  String jsonActions = NodeMCU_Recieve.readString();

  // Decode json
  StaticJsonDocument<96> doc;
  DeserializationError error = deserializeJson(doc, jsonActions);

  if (error) {
    return;
  }

  int sector1 = doc["sector1"];
  int sector2 = doc["sector2"];
  int sector3 = doc["sector3"];
  int sector4 = doc["sector4"];

  if (sector1 == 1) {
    Serial.println("jsem tu1");
    digitalWrite(waterPump1, LOW);
    delay(2000);
    digitalWrite(waterPump1, HIGH);
  }

  if (sector2 == 1) {
    Serial.println("jsem tu2");
    digitalWrite(waterPump2, LOW);
    delay(2000);
    digitalWrite(waterPump2, HIGH);
  }

  if (sector3 == 1) {
    Serial.println("jsem tu3");
    digitalWrite(waterPump3, LOW);
    delay(2000);
    digitalWrite(waterPump3, HIGH);
  }

  if (sector4 == 1) {
    Serial.println("jsem tu4");
    digitalWrite(waterPump4, LOW);
    delay(2000);
    digitalWrite(waterPump4, HIGH);
  }
}
