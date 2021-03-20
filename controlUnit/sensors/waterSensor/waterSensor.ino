const int waterSensor = A0;
float waterLevel = 0;

void setup() {
  // initialize LED_BUILTIN as an output pin.
  pinMode(waterSensor, INPUT);
  Serial.begin(115200);
}

void loop() {
  waterLevel = analogRead(waterSensor);
  waterLevel = (waterLevel / 1024) * 100;
  Serial.println(waterLevel);
  delay(500);
}
