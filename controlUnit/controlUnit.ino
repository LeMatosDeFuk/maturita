#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>
#include <OneWire.h>
#include <DallasTemperature.h>

const char *ssid = "MI9";
const char *password = "huhuhuhu";

const char *host = "http://maturita-web.cernymatej.cz/api/sensor-data";

const int Dallas = 5;
//const int photoResistor = A0;
const int humiditySensor = 3;
const int waterSensor = A0;
int sensorValue;

OneWire oneWireDS(Dallas);
DallasTemperature sensorDallas(&oneWireDS);

void setup() {
  //  pinMode(photoResistor, INPUT);
  pinMode(waterSensor, INPUT);
  sensorDallas.begin();

  delay(1000);
  Serial.begin(115200);
  WiFi.mode(WIFI_OFF);        // Zabraňuje problémům při připojování
  delay(1000);
  WiFi.mode(WIFI_STA);        // Schová zobrazení ESP jako wifi hotspot

  // Připojení k wifi
  WiFi.begin(ssid, password);
  Serial.println("");
  Serial.print("Připojování");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  //Pokud se úspěšně připojí, zobrazí IP do monitoru
  Serial.println("");
  Serial.print("Připojeno k ");
  Serial.println(ssid);
  Serial.print("IP adresa: ");
  Serial.println(WiFi.localIP());  //IP adresa ESP
}

//String getLightingValues() {
//  float photoSensorValue = analogRead(photoResistor);
//  Serial.print("Intenzita svetla: ");
//  Serial.println(photoSensorValue);
//
//  return String(photoSensorValue);
//}

String getTemperatureValues() {
  sensorDallas.requestTemperatures();
  Serial.print("Teplota: ");
  Serial.print(sensorDallas.getTempCByIndex(0));
  Serial.println(" °C");

  return String(sensorDallas.getTempCByIndex(0));
}

String getHumidityValues() {
  float humidityValue = digitalRead(humiditySensor);
  Serial.print("Vlhkost: ");
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
  HTTPClient http;

  String temperature, humidity, lighting, postData, waterLevel;
  temperature = getTemperatureValues();
  humidity = getHumidityValues();
  //  lighting = getLightingValues();
  waterLevel = getWaterLevelValues();

  postData = "temperature=" + temperature + "&humidity=" + humidity + "&lighting=" + 500 + "&waterLevel=" + waterLevel;
  http.begin(host);
  http.addHeader("Content-Type", "application/x-www-form-urlencoded");
  int httpCode = http.POST(postData);
  String payload = http.getString();

  Serial.println(httpCode);
  Serial.println(payload);
  http.end();
  delay(5000);
}
