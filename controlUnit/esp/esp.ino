#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266HTTPClient.h>
#include <SoftwareSerial.h>

SoftwareSerial Arduino_Recieve(D7, D8);
SoftwareSerial Arduino_Send(D5, D6);

const char *ssid = "MI9";
const char *password = "huhuhuhu";

const char *updateData = "http://maturita-web.cernymatej.cz/api/sensor-data";
const char *actions = "http://maturita-web.cernymatej.cz/api/actions";

int httpCode;

void setup() {
  Serial.begin(9600);
  Arduino_Send.begin(9600);
  Arduino_Recieve.begin(9600);

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

void loop() {
  HTTPClient http;

  // send data
  http.begin(updateData);
  http.addHeader("Content-Type", "application/x-www-form-urlencoded");
  String postData = Arduino_Recieve.readString();
  Serial.println(postData);
  httpCode = http.POST(postData);
  Serial.println(httpCode);
  http.end();

  // get actions
  http.begin(actions);
  httpCode = http.GET();
  String payload = http.getString();
  Serial.println(httpCode);
  Serial.println(payload);

  Arduino_Send.write(payload.c_str());

  http.end();
  delay(5000);
}
