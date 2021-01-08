#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>

/* Údaje k WIFI */
const char *ssid = "MI 9";
const char *password = "huhuhuhu";
boolean ledState = false;

// Vytvoření webového serveru, který komunikuje přes HTTP na portu 80
ESP8266WebServer server(80);

void handleRoot() {
  // Zobrazí zprávu, pokud je vše správně nakonfigurované
  server.send(200, "text/html", "<h1>Uspesne pripojeno</h1>");
}

void setup() {
  pinMode(BUILTIN_LED, OUTPUT);
  delay(1000);
  Serial.begin(9600);
  
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
  IPAddress ip(192, 168, 43, 195);
  IPAddress gateway(192, 168, 1, 1);
  IPAddress subnet(255, 255, 255, 0);
  WiFi.config(ip, gateway, subnet);

// Url pro akce
  server.on("/", handleRoot);
  server.on("/led", toggleLed);
  server.begin();
  Serial.println("Pripojeno");
}

void toggleLed() {
  ledState = ! ledState;
  if (ledState == true) {
    digitalWrite(BUILTIN_LED, ledState);
    server.send(200, "text/plain", "vypnuto");
    Serial.println("LED vypnuta");
  } else {
    digitalWrite(BUILTIN_LED, ledState);
    server.send(200, "text/plain", "zapnuto");
    Serial.println("LED zapnuta");
  }
}

void loop() {
  server.handleClient();
}
