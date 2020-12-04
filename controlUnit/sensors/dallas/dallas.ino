#include <OneWire.h>
#include <DallasTemperature.h>

const int dallas = 5;

OneWire oneWireDS(dallas);
DallasTemperature sensorDallas(&oneWireDS);

void setup(void) {
  Serial.begin(9600);
  sensorDallas.begin();
}

void loop(void) {
  sensorDallas.requestTemperatures();
  Serial.print("Teplota: ");
  Serial.print(sensorDallas.getTempCByIndex(0));
  Serial.println(" °C");
  delay(1000);
}
