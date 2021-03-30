#include <SoftwareSerial.h>
#include <ArduinoJson.h>

SoftwareSerial NodeMCU(7, 6);

const int humiditySensor1 = 19; // left top
const int waterPump1 = 5; // right bottom

const int humiditySensor2 = 18; // right bottom
const int waterPump2 = 6; // left bottom

const int humiditySensor3 = 17; // right top
const int waterPump3 = 7; // left top

const int humiditySensor4 = 2; // left bottom
const int waterPump4 = 8; // right top

const int photoResistor = A0;
const int waterSensor = A3;
const int temperatureSensor = A1;

void setup() {
  Serial.begin(9600);
  NodeMCU.begin(9600);

  pinMode(waterPump1, OUTPUT);
  pinMode(waterPump2, OUTPUT);
  pinMode(waterPump3, OUTPUT);
  pinMode(waterPump4, OUTPUT);

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

int convertToLux(int voltage) {
  float Vout = float(voltage) * (5 / float(1023));
  float RLDR = (10000 * (5 - Vout));
  int lux = 500 / (RLDR / 1000);

  return lux;
}

String getLightingValues() {
  int voltage = analogRead(photoResistor);
  int lightValue = convertToLux(voltage);

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
  String data = getPostData();

    Serial.println(data.c_str());
    NodeMCU.write(data.c_str());
 

  String payload = NodeMCU.readString();

  // Allocate JsonBuffer
  const size_t capacity = JSON_OBJECT_SIZE(3) + JSON_ARRAY_SIZE(2) + 60;
  DynamicJsonBuffer jsonBuffer(capacity);

  // Parse JSON object
  JsonObject& root = jsonBuffer.parseObject(payload);
  if (!root.success()) {
    Serial.println(F("Nelze převést json!"));
    return;
  }

  if (root["sector1"] == true) {
    digitalWrite(waterPump1, LOW);
    delay(2000);
    digitalWrite(waterPump1, HIGH);
  }

  if (root["sector2"] == true) {
    digitalWrite(waterPump2, LOW);
    delay(2000);
    digitalWrite(waterPump2, HIGH);
  }

  if (root["sector3"] == true) {
    digitalWrite(waterPump3, LOW);
    delay(2000);
    digitalWrite(waterPump3, HIGH);
  }

  if (root["sector4"] == true) {
    digitalWrite(waterPump4, LOW);
    delay(2000);
    digitalWrite(waterPump4, HIGH);
  }

  delay(3000);
}
