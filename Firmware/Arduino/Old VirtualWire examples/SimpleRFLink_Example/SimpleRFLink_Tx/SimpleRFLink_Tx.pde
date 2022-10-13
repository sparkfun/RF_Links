/*
 RF ASK Tx and Rx Simple Example
 Created in 2011 by NPoole @ SparkFun Electronics 
 
 modified 5 Feb 2015
 by Bobby Chan @ SparkFun Electronics 
 
 Description:
 This code depends on the VirtualWire Library for Arduino and is
 based on the example code provided by Mike McCauley (mikem@open.com.au)
 To download the most recent VirtualWire Library =>
 http://www.airspayce.com/mikem/arduino/VirtualWire/index.html
 See VirtualWire.h for detailed API docs. You will need to use this code
 with the SimpleRFLink_Rx.pde.
 
 This example shows how to use the VirtualWire library to send and receive
 simple messages and use them to control digital I/O pins with the RF Links. 
 Can be used for either the 315MHz or 434MHz frequency bands. Be sure that the
 transmitter and the receiver are using the same frequency in order to transmit
 data. Button is connected to the transmitting Arduino on pins 8 and ground.
 Arduino's internal pullup resistor is used with the button. Pin 13 is enabled 
 as a status LED to indicate when characters are being sent.
 
 For the receiving side, it is set up in the same fashion, where the LED is 
 connected to the receiving Arduino on pins 8. When a button is pressed on the
 transmitter, the corresponding LED will light on the receiver if the character
 matches what is expected. Pin 13 is enabled as a status LED to indicate
 when characters are being received.
 
 Note: The reason why this is still in a .pde extension file is so that it can
 be used for either Arduino 00xx and Arduino 1.0.x. If Rx code is compiled
 in Arduino 0023 and below, the serial monitor will output as the ASCII characters.
 If Rx code is compiled in Arduino 1.0+, the serial monitor will 
 output the decimal value of the ASCII character. Check out the ASCII Table
 http://www.asciitable.com/ for more information.
 */

// RF LINK TRANSMITTER CODE
#include <VirtualWire.h>

void setup()
{
  Serial.begin(9600);	  // Debugging only
  Serial.println("Initialize RF Link Tx Code");

  // Initialise the IO and ISR
  vw_set_ptt_inverted(true); // Required for DR3100
  vw_setup(2000);	    // Bits per sec
  vw_set_tx_pin(3);         //Pin 3 is connected to "Digital Output" of transmitter

  //Set pins as input for buttons
  pinMode(8, INPUT_PULLUP);

  //Set pin for LED as status indicator
  pinMode (13, OUTPUT);

  //Initialize button pins
  digitalWrite(8, HIGH);
}

void loop()
{
  char *msg;

  if(digitalRead(8) == LOW){
    digitalWrite(13, true);  //Flash status LED to show transmitting

    char *msg = "1"; //message to send
    tx_debug(msg); //output message to serial monitor for debugging.
    vw_send((uint8_t *)msg, strlen(msg));//send message
    vw_wait_tx(); // Wait until the whole message is gone

    digitalWrite(13, false); //Turn off status LED
  }
}

void tx_debug(char *temp_msg){
  //output to serial monitor to indicate which button pressed
  Serial.print("Button was pressed, sending msg = ");
  Serial.println(temp_msg);
}



