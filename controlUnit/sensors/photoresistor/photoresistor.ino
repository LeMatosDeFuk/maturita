const int photoResistor = A0;
int sensorValue;				          // Proměnná pro uložení hodnoty z fotorezistoru (0-1023)

void setup(){
 pinMode(photoResistor, INPUT);
 Serial.begin(9600);
}

void loop(){
  sensorValue = analogRead(photoResistor);
  Serial.println(sensorValue);

  delay(500);
}
