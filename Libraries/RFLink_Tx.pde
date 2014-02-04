// RF ASK Tx and Rx Example
// Created in 2011 by NPoole @ SparkFun Electronics 
//
// This code depends on the VirtualWire Library for Arduino and is
// based on the example code provided by Mike McCauley (mikem@open.com.au)
// To download the most recent VirtualWire Library =>
// http://www.airspayce.com/mikem/arduino/VirtualWire/index.html
// See VirtualWire.h for detailed API docs. 
//
// This example shows how to use the VirtualWire library to send and receive
// simple messages and use them to control digital I/O pins. Buttons are 
// connected to the transmitting Arduino on pins 8-11, a 10kOhm resistor, and ground.
// Pin 13 is enabled as a status LED to indicate when characters are being sent.
//
// For the receiving side, they are set up in the same fashion, where LEDs are 
// connected to the receiving Arduino on pins 8-11. When a button is pressed on the
// transmitter, the corresponding LED will light on the receiver if the character
// matches what is expected.
// Pin 13 is enabled as a status LED to indicate when characters are being received.
// 
// Note: If Rx code compiled in Arduino 0023 and below, the serial monitor will output
// in characters. If Rx code is compiled in Arduino 1.0+, the serial monitor will 
// output the decimal value of the ASCII character.

//TRANSMITTER CODE
#include <VirtualWire.h>

void setup()
{
  Serial.begin(9600);	  // Debugging only
  Serial.println("setup");

  // Initialise the IO and ISR
  vw_set_ptt_inverted(true); // Required for DR3100
  vw_setup(2000);	 // Bits per sec
  vw_set_tx_pin(3); //Pin 3 is connected to "Digital Output" of receiver

  //Set pins as input for buttons
  pinMode(8, INPUT);
  pinMode(9, INPUT);
  pinMode(10, INPUT);
  pinMode(11, INPUT);

  //Set pin for LED as status indicator
  pinMode (13, OUTPUT);

  //Initialize button pins
  digitalWrite(8, HIGH);
  digitalWrite(9, HIGH);
  digitalWrite(10, HIGH);
  digitalWrite(11, HIGH);
}

void loop()
{
  char *msg;

  if(digitalRead(8) == LOW){
    char *msg = "1";
    digitalWrite(13, true);  //Flash status LED to show transmitting
    vw_send((uint8_t *)msg, strlen(msg));
    vw_wait_tx(); // Wait until the whole message is gone
    digitalWrite(13, false); //Turn off status LED
  }

  if(digitalRead(9) == LOW){
    char *msg = "2";
    digitalWrite(13, true);  //Flash status LED to show transmitting
    vw_send((uint8_t *)msg, strlen(msg));
    vw_wait_tx(); // Wait until the whole message is gone
    digitalWrite(13, false); //Turn off status LED
  }

  if(digitalRead(10) == LOW){
    char *msg = "3";
    digitalWrite(13, true);  //Flash status LED to show transmitting
    vw_send((uint8_t *)msg, strlen(msg));
    vw_wait_tx(); // Wait until the whole message is gone
    digitalWrite(13, false); //Turn off status LED
  }

  if(digitalRead(11) == LOW){
    char *msg = "4";
    digitalWrite(13, true);  //Flash status LED to show transmitting
    vw_send((uint8_t *)msg, strlen(msg));
    vw_wait_tx(); // Wait until the whole message is gone
    digitalWrite(13, false); //Turn off status LED
  }
}

