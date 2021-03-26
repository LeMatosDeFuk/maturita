#include <SoftwareSerial.h>
SoftwareSerial NodeMCU(5, 6);

const int photoResistor = A1;
const int humiditySensor = 3;
const int waterSensor = A0;
int sensorValue;

void setup() {
  Serial.begin(9600);
  NodeMCU.begin(9600);

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
  Serial.print("Intenzita svetla: ");
  Serial.println(photoSensorValue);

  return String(photoSensorValue);
}

String getTemperatureValues() {
  int temperature = 32;
  Serial.print("Teplota: ");
  Serial.print(temperature);
  Serial.println(" °C");

  return String(temperature);
}

String getHumidity1Values() {
  float humidityValue = digitalRead(humiditySensor);
  Serial.print("Vlhkost1: ");
  Serial.println(humidityValue);

  return String(humidityValue);
}


String getHumidity2Values() {
  float humidityValue = digitalRead(humiditySensor);
  Serial.print("Vlhkost2: ");
  Serial.println(humidityValue);

  return String(humidityValue);
}


String getHumidity3Values() {
  float humidityValue = digitalRead(humiditySensor);
  Serial.print("Vlhkost3: ");
  Serial.println(humidityValue);

  return String(humidityValue);
}


String getHumidity4Values() {
  float humidityValue = digitalRead(humiditySensor);
  Serial.print("Vlhkost4: ");
  Serial.println(humidityValue);

  return String(humidityValue);
}

String getWaterLevelValues() {
  float waterLevel = analogRead(waterSensor);
  waterLevel = (waterLevel / 1024) * 100;
  Serial.print("Hladina vody: ");
  Serial.print(waterLevel);
  Serial.println("%");

  return String(waterLevel);
}

void loop() {
  String data = getPostData();
  if (NodeMCU.available() > 0) {
    Serial.println(data.c_str());
    NodeMCU.write(data.c_str());
    delay(1000);
  }
}
