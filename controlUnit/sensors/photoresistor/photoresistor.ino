const int photoResistor = A4;
int sensorValue;

void setup(){
 pinMode(photoResistor, INPUT);
 Serial.begin(9600);
}

void loop(){
  sensorValue = analogRead(photoResistor);
  Serial.println(sensorValue);

  delay(500);
}
