#include <ESP8266WiFi.h>
#include <WiFiClient.h> 
#include <ESP8266WebServer.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>
#include <OneWire.h>
#include <DallasTemperature.h>
 
const char *ssid = "HUB 2.0";  
const char *password = "hubvplzni";
 
const char *host = "http://192.168.101.238/laravel/maturita-web/api/get-data";

const int Dallas = 5;
const int photoResistor = A0;
const int waterSensor = 3;
int sensorValue;          // Proměnná pro uložení hodnoty z fotorezistoru (0-1023)

OneWire oneWireDS(Dallas);
DallasTemperature sensorDallas(&oneWireDS);

void setup() {
pinMode(photoResistor, INPUT);
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

String getLightingValues() {
  float photoSensorValue = analogRead(photoResistor);
  Serial.print("Intenzita svetla: ");
  Serial.println(photoSensorValue);

  return String(photoSensorValue);
}

String getTemperatureValues() {
  sensorDallas.requestTemperatures();
  Serial.print("Teplota: ");
  Serial.print(sensorDallas.getTempCByIndex(0));
  Serial.println(" °C");

  return String(sensorDallas.getTempCByIndex(0));
}

String getWaterSensorValues() {
  float waterSensorValue = digitalRead(waterSensor);
  Serial.print("Hladina vody: ");
  Serial.println(waterSensorValue);

  return String(waterSensorValue);
}
 
void loop() {
  HTTPClient http;

  String temperature, humidity, postData;
  temperature = getDallasSensorValues();
  water = getWaterSensorValues();
  lighting = getPhotoSensorValues();
 
  postData = "temperature=" + temperature + "&waterLevel=" + waterLevel + "&lighting=" + lighting;
  http.begin(host);
  http.addHeader("Content-Type", "application/x-www-form-urlencoded");
  int httpCode = http.POST(postData);
  String payload = http.getString();
 
  Serial.println(httpCode);
  Serial.println(payload);
  http.end();
  delay(5000);
}
