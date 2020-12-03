#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ArduinoJson.h>
#include <OneWire.h>
#include <DallasTemperature.h>

const int Dallas = 5;
const int photoResistor = A0;
int sensorValue;				  // Proměnná pro uložení hodnoty z fotorezistoru (0-1023)

OneWire oneWireDS(Dallas);
DallasTemperature sensorDallas(&oneWireDS);

/* Údaje k WIFI */
const char *ssid = "MI 9";
const char *password = "huhuhuhu";

// Vytvoření webového serveru, který komunikuje přes HTTP na portu 80
ESP8266WebServer server(80);

void handleRoot() {
  // Zobrazí zprávu, pokud je vše správně nakonfigurované
  server.send(200, "text/html", "<h1>Uspesne pripojeno</h1>");
}

void setup() {
  pinMode(photoResistor, INPUT);
  Serial.begin(9600);
  sensorDallas.begin();


  // Připojení k WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print("*");
  }
  Serial.println("");
  Serial.println("Local IP:");
  Serial.println(WiFi.localIP());

  // Zde je potřeba upravit IP adresu (IP ze sériového monitoru)
  IPAddress ip(192, 168, 43, 82);
  IPAddress gateway(192, 168, 1, 1);
  IPAddress subnet(255, 255, 255, 0);
  WiFi.config(ip, gateway, subnet);

  // Url pro akce
  server.on("/", handleRoot);
  server.on("/photo-sensor", getPhotoSensorValues);
  server.on("/dallas-sensor", getDallasSensorValues);
  server.begin();
  Serial.println("Pripojeno");
}

void getPhotoSensorValues() {
  //    float sensorValue = analogRead(photoResistor);
  //    String json = "{ \"photoSensorValue\": " + String(sensorValue) + " }"; // Knihovna nepodporuje int ani float
  //    server.send(200, "application/json", json);
  //    Serial.println(sensorValue);

  float sensorValue = analogRead(photoResistor);
  server.send(200, "text/plain", String (sensorValue)); // Knihovna nepodporuje int ani float
  Serial.println(sensorValue);
}

void getDallasSensorValues() {
  sensorDallas.requestTemperatures();
  Serial.print("Teplota: ");
  Serial.print(sensorDallas.getTempCByIndex(0));
  Serial.println(" °C");

  server.send(200, "text/plain", String(sensorDallas.getTempCByIndex(0)));

}

void loop() {
  server.handleClient();
}
