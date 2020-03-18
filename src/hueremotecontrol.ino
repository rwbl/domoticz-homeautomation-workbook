/*
 * Explore setting the brightness of a Hue light connected to Domoticz Home Automation, by 
 * using a ESP8266 microcontroller (WeMOS D1) with a potentiometer slider and 7-segment-4-digit-display.
 * Domoticz device idx = 118.
 * The Domoticz Json response is parsed using ArduinoJson (Check object size https://arduinojson.org/v6/assistant/ ).
 * To reduce noise, a delta level is used to trigger change.
 * Author: rwbl 
 * Version: 20190411
 */

#include <ESP8266HTTPClient.h>;
#include <ESP8266WiFi.h>;
#include <ArduinoJson.h>;
#include <TM1637Display.h> 

// potmeter
int potPin = 0;             // A0 input pin for the potentiometer
int ledPin = BUILTIN_LED;   // build in led when the slider is moved
int potValue = 0;           // value from the potmeter 0-1023
int newLevel = 0;           // store new brightness level 0-100
int oldLevel = 0;           // store previous brightness level 0-100
int deltaLevel = 0;         // determine delta between new and oldlevel
int noiseLevel = 5;         // set new level when deltaLevel > noiseLevel
    
// 7-segment-4-digit-display pins
const int CLKPin = D5; 
const int DIOPin = D6; 
 
// display object
TM1637Display display(CLKPin, DIOPin); 

// network
const char* ssid = "your ssid";
const char* password = "your password";

// domoticz
// urlused to set the brightness
String baseUrl = "http://your_url:8080/json.htm?type=command&param=switchlight&idx=118&switchcmd=Set%20Level&level=";
const int deviceIdx = 118;

void setup() {

  // serial connection
  Serial.begin(115200);

  // declare ledPin as an OUTPUT
  pinMode(ledPin, OUTPUT);

  // led display
  // set brightness to medium (range is 0x00 (dark) - 0x0f (bright)
  display.setBrightness(0x0a);
  uint8_t data[] = { 0xff, 0xff, 0xff, 0xff };
  // put the number of segments
  display.setSegments(data);
  // initial value
  display.showNumberDec(0); 
  delay(10);

  // network

  // wifi setup connection and hide the ssid
  WiFi.begin(ssid, password);
  WiFi.mode(WIFI_STA);
  // wait for the wifi connection completion
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.println("Waiting for connection...");
  }
 
}
 
void loop() {
  
  // check the wifi connection status
  if(WiFi.status()== WL_CONNECTED){
    // object of class HTTPClient forcommunication with domoticz server
    HTTPClient http;
    // url sent to domoticz containing the api commands
    String domoticzUrl;
    
    // get the potentiometer analog value and convert to level 0-100
    potValue = analogRead(potPin);
    newLevel = map(potValue, 0, 1023, 0, 100);
    // handle noise at low level
    if (newLevel <= noiseLevel){
      newLevel = 0;
    }

    // get the absolute delta value from the new and old value
    deltaLevel = abs(newLevel - oldLevel);

    // set the new level if the deltalevel is greater noise level
    if (deltaLevel > noiseLevel){
      Serial.println(newLevel);
      // set the led to high
      digitalWrite(ledPin, HIGH);
      // assign the new to the old level - important
      oldLevel = newLevel;
      // update the display
      display.showNumberDec(newLevel); 
      // Serial.println(level);

      // build the domoticz api url
      domoticzUrl = baseUrl + newLevel;
      Serial.println(domoticzUrl);
      
      // specify the http request destination
      http.begin(domoticzUrl);
      http.addHeader("Content-Type", "text/plain");
      // send the request to the domoticz server
      int httpCode = http.POST("ESP8266 request set Hue Level");
      // get the response payload
      String payload = http.getString();
      // Serial.println(httpCode);   
      Serial.println(payload);

      // parse the domoticz http response, which is a json string
      // allocate the JSON document - size determined by the HTTP response, i.e.
      // {"status" : "OK", "title" : "SwitchLight"} or in case of an error {"status" : "ERR"}
      // use http://arduinojson.org/v6/assistant to compute the capacity.
      const size_t capacity = JSON_OBJECT_SIZE(2) + 1000;
      DynamicJsonDocument doc(capacity);
   
      // parse JSON object
      DeserializationError error = deserializeJson(doc, payload);
      if (error) {
        Serial.print(F("deserializeJson() failed: "));
        Serial.println(error.c_str());
        return;
      }

      // extract value "status" from the response
      Serial.println(F("Response:"));
      Serial.println(doc["status"].as<char*>());

      // close http connection
      http.end();
 
    }
    else {
      // turn the ledPin off    
      digitalWrite(ledPin, LOW);
    }

  }
  else {
    Serial.println("Error WiFi connection");
  }
  
  delay(100);
 
}
