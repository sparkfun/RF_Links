/*RF ASK Tx and Rx Example Code
  Created in 2011 by NPoole @ SparkFun Electronics

  modified 13 Oct 2022
  by Bobby Chan @ SparkFun Electronics

  Description:
  This code depends on the RadioHead Library for Arduino and is
  based on the example code provided by Mike McCauley.
  It is based on the ask_transmitter.pde example.
  To download the most recent RadioHead Library =>
  http://www.airspayce.com/mikem/arduino/RadioHead/index.html
  See RH_ASK.h for detailed API docs. You will need to use this code
  with the 02-RadioHead-Simple_RFLink_Rx.ino.

  This example shows how to use the RadioHead Library to send and receive
  simple messages and use them to control digital I/O pins with the RF Links.
  Can be used for either the 314MHz or 434MHz frequency bands. Be sure that the
  transmitter and the receiver are using the same frequency in order to transmit
  data. Buttons are connected to the transmitting Arduino on pins 8-11 and ground.
  Arduino's internal pullup resistor is used with the button. Pin 13 is enabled
  as a status LED to indicate when characters are being sent.

  For the receiving side, they are set up in the same fashion, where LEDs are
  connected to the receiving Arduino on pin 8. When a button is pressed on the
  transmitter, the corresponding LED will light on the receiver if the character
  matches what is expected. Pin 13 is enabled as a status LED to indicate
  when characters are being received.

  Note: You may need to check out the ASCII Table
  when viewing the output as it is the ASCII value
  http://www.asciitable.com/ for more information.

  This was tested on an Arduino Uno w/ ATmega328P and RF Link Transmitters (315MHz 434MHz)
*/

// RF LINK RECEIVER LIBRARY
#include <RH_ASK.h>
#ifdef RH_HAVE_HARDWARE_SPI
#include <SPI.h> // Not actually used but needed to compile
#endif

RH_ASK driver(2000, 2, 3, 0);  //2000bps, rxPin = 2, txPin = 3
//RH_ASK driver;  //defaults 2000bps, rxPin = 11, txPin = 1
// RH_ASK driver(2000, 4, 5, 0); // ESP8266 or ESP32: do not use pin 11 or 2
// RH_ASK driver(2000, 3, 4, 0); // ATTiny, RX on D3 (pin 2 on attiny85) TX on D4 (pin 3 on attiny85),
// RH_ASK driver(2000, PD14, PD13, 0); STM32F4 Discovery: see tx and rx on Orange and Red LEDS

void setup() {
#ifdef RH_HAVE_SERIAL
  Serial.begin(9600);	  // Debugging only
  Serial.println("Initialize RF Link Tx Code");
#endif
  if (!driver.init())
#ifdef RH_HAVE_SERIAL
    Serial.println("init failed");
#else
    ;
#endif

  //Set pin for LED as status indicator
  pinMode (13, OUTPUT);

  //Set pins as input for buttons
  pinMode(8, INPUT_PULLUP);

  //Initialize button pins
  digitalWrite(8, HIGH);

  const char *msg = "hello";

  tx_debug(msg);
  driver.send((uint8_t *)msg, strlen(msg));
  driver.waitPacketSent();
  delay(200);
}

void loop() {

  if (digitalRead(8) == LOW) {
    digitalWrite(13, true);  //Flash status LED to show transmitting
    char *msg_button1 = "1"; //message to send
    tx_debug(msg_button1);
    driver.send((uint8_t *)msg_button1, strlen(msg_button1));
    driver.waitPacketSent();
    delay(200);
  }

  //Turn off status LED
  digitalWrite(13, false);

  //Short delay to see the LEDs toggle, comment out if necessary
  delay(200);

}


void tx_debug(char *temp_msg) {
  //output to serial monitor to indicate which button pressed
  Serial.print("Button was pressed, sending msg = ");
  Serial.println(temp_msg);
}
