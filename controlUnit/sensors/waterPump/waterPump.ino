const int waterPump1 = 5;

void setup() {
  pinMode(waterPump1, OUTPUT);
  Serial.begin(9600);

  digitalWrite(waterPump1, HIGH);
  delay(2000);
  digitalWrite(waterPump1, LOW);
  delay(2000);
}

void loop() {}
