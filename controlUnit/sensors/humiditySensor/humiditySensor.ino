const int humiditySensor1 = 3; // left top
const int waterPump1 = 5; // left top

const int humiditySensor2 = 4; // right bottom
const int waterPump2 = 6; // right bottom

const int humiditySensor3 = A1; // left bottom
const int waterPump3 = 7; // left bottom

const int humiditySensor4 = A0; // right top
const int waterPump4 = 8; // right top


const int waterSensor = A3;
float waterLevel = 0;

void setup() {
  pinMode(waterSensor, INPUT);
  pinMode(humiditySensor1, INPUT);
  pinMode(humiditySensor2, INPUT);
  pinMode(humiditySensor3, INPUT);
  pinMode(humiditySensor4, INPUT);

  //  pinMode(waterPump1, OUTPUT);
  //  digitalWrite(waterPump1, LOW);
  //  delay(2000);
  //  digitalWrite(waterPump1, HIGH);

  //  pinMode(waterPump2, OUTPUT);
  //  digitalWrite(waterPump2, LOW);
  //  delay(2000);
  //  digitalWrite(waterPump2, HIGH);

  //  pinMode(waterPump3, OUTPUT);
  //  digitalWrite(waterPump3, LOW);
  //  delay(2000);
  //  digitalWrite(waterPump3, HIGH);

  pinMode(waterPump4, OUTPUT);
  digitalWrite(waterPump4, HIGH);

  Serial.begin(9600);
}

void loop() {
  digitalWrite(waterPump4, LOW);
  delay(5000);
  digitalWrite(waterPump4, HIGH);
  delay(10000);

//  float humidity1 = analogRead(humiditySensor1);
//  float humidity2 = analogRead(humiditySensor2);
//  float humidity3 = analogRead(humiditySensor3);
//  float humidity4 = analogRead(humiditySensor4);
//
//  humidity1 = 100 - (humidity1 / 1024) * 100;
//  Serial.print("Vlhkost 1: ");
//  Serial.print(humidity1);
//  Serial.println();
//
//  humidity2 = 100 - (humidity2 / 1024) * 100;
//  Serial.print("Vlhkost 2: ");
//  Serial.print(humidity2);
//  Serial.println();
//
//  humidity3 = 100 - (humidity3 / 1024) * 100;
//  Serial.print("Vlhkost 3: ");
//  Serial.print(humidity3);
//  Serial.println();
//
//  humidity4 = 100 - (humidity4 / 1024) * 100;
//  Serial.print("Vlhkost 4: ");
//  Serial.print(humidity4);
//  Serial.println();
//
//  waterLevel = analogRead(waterSensor);
//  waterLevel = (waterLevel / 1024) * 100;
//  Serial.print("Hladina vody: ");
//  Serial.print(waterLevel);
//  Serial.println();

  //  if (waterLevel > 70.00) {
  //    digitalWrite(waterPump4, LOW);
  //    delay(2000);
  //    digitalWrite(waterPump4, HIGH);
  //  }

//  delay(10000);

}
