/*RF ASK Tx and Rx Example Code
  Created in 2011 by NPoole @ SparkFun Electronics
q
  modified 13 Oct 2022
  by Bobby Chan @ SparkFun Electronics

  Description:
  This code depends on the RadioHead Library for Arduino and is
  based on the example code provided by Mike McCauley.
  It is based on the ask_receivier.pde example.
  To download the most recent RadioHead Library =>
  http://www.airspayce.com/mikem/arduino/RadioHead/index.html
  See RH_ASK.h for detailed API docs. You will need to use this code
  with the 01-RadioHead-Simple_RFLink_Tx.ino.

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

  This was tested on an Arduino Uno w/ ATmega328P and RF Link Transmitters (315MHz 434MHz).
*/

// RF LINK RECEIVER LIBRARY
#include <RH_ASK.h>
#ifdef RH_HAVE_HARDWARE_SPI
#include <SPI.h> // Not actually used but needed to compile
#endif

RH_ASK driver(2000, 2, 3, 0); //2000bps, rxPin = 2, txPin = 3
//RH_ASK driver;  //defaults 2000bps, rxPin = 11, txPin = 1
// RH_ASK driver(2000, 4, 5, 0); // ESP8266 or ESP32: do not use pin 11 or 2
// RH_ASK driver(2000, 3, 4, 0); // ATTiny, RX on D3 (pin 2 on attiny85) TX on D4 (pin 3 on attiny85),
// RH_ASK driver(2000, PD14, PD13, 0); STM32F4 Discovery: see tx and rx on Orange and Red LEDS

void setup() {
#ifdef RH_HAVE_SERIAL
  Serial.begin(9600);	  // Debugging only
  Serial.println("Initialize RF Link Rx Code");
#endif
  if (!driver.init())
#ifdef RH_HAVE_SERIAL
    Serial.println("init failed");
#else
    ;
#endif

  //Set pins for LED Output
  pinMode(8, OUTPUT);

  //Set pin for LED as status indicator
  pinMode (13, OUTPUT);
}

void loop() {

  //Initialize/reinitialize LEDs
  digitalWrite(8, LOW);

  //Set buffer array based on max message length
  uint8_t buf[RH_ASK_MAX_MESSAGE_LEN];

  //Set variable to indicate buffer length
  uint8_t buflen = sizeof(buf);

  if (driver.recv(buf, &buflen)) // Non-blocking
  {
    // Flash status LED to show received data
    digitalWrite(13, true);

    //Note: This line of code just prints the buffer with space
    //      you will see the ASCII value instead of the character
    // Message with a good checksum received, dump it.
    //driver.printBuffer("Got:", buf, buflen);


    // Message with a good checksum received, dump it.
    Serial.print("Received message: ");

    //print each character individually, this is useful if you are just checking for certain characters and printing it as character
    //Note: The original code for the ask_receiver.pde used `int i` but it 
    //doesn't appear to be used. Just in case, we'll create another variable `j`
    for (int j = 0; j < buflen; j++) {

      // Print message received in buffer through this loop as a character by typcasting it as a char
      Serial.print((char)buf[j]);
      //add space to distinguish characters from each other if showing ASCII decimal #
      //Serial.print(" ");

      //if character received matches, turn on associated LED
      if (buf[j] == '1') {
        digitalWrite(8, HIGH);
      }

    }
    //Print next character on new line
    Serial.println("");

    //Short delay to see the LEDs toggle, comment out if necessary
    delay(200);

    //Turn off status LED
    digitalWrite(13, false);

  }
}
