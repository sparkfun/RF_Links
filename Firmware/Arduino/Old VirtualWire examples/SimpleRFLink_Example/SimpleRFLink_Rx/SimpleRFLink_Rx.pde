/*
 RF ASK Tx and Rx Example Code
 Created in 2011 by NPoole @ SparkFun Electronics
 
 modified 5 Feb 2015
 by Bobby Chan @ SparkFun Electronics 
 
 Description:
 This code depends on the VirtualWire Library for Arduino and is
 based on the example code provided by Mike McCauley (mikem@open.com.au)
 To download the most recent VirtualWire Library =>
 http://www.airspayce.com/mikem/arduino/VirtualWire/index.html
 See VirtualWire.h for detailed API docs. You will need to use this code
 with the SimpleRFLink_Tx.pde.
 
 This example shows how to use the VirtualWire library to send and receive
 simple messages and use them to control digital I/O pins with the RF Links. 
 Can be used for either the 315MHz or 434MHz frequency bands. Be sure that the
 transmitter and the receiver are using the same frequency in order to transmit
 data. Buttons are connected to the transmitting Arduino on pins 8-11 and ground.
 Arduino's internal pullup resistor is used with the button. Pin 13 is enabled
 as a status LED to indicate when characters are being sent.
 
 For the receiving side, they are set up in the same fashion, where LEDs are 
 connected to the receiving Arduino on pins 8-11. When a button is pressed on the
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

// RF LINK RECEIVER CODE
#include <VirtualWire.h>

void setup()
{
  Serial.begin(9600);	// Debugging only
  Serial.println("Initialize RF Link Rx Code");

  //Initialize the IO and ISR
  vw_set_ptt_inverted(true); // Required for DR3100
  vw_setup(2000);	    // Bits per sec
  vw_set_rx_pin(2);         //Pin 2 is connected to "Digital Output" of receiver
  vw_rx_start();           // Start the receiver PLL running

  //Set pins for LED Output
  pinMode(8, OUTPUT);

  //Set pin for LED as status indicator
  pinMode (13, OUTPUT);

}

void loop()
{
  //Initialize/reinitialize LEDs
  digitalWrite(8, LOW);

  //Set buffer array based on max message length
  uint8_t buf[VW_MAX_MESSAGE_LEN];

  //Set variable to indicate buffer length
  uint8_t buflen = VW_MAX_MESSAGE_LEN;

  if (vw_get_message(buf, &buflen)) // Non-blocking
  {
    // Flash status LED to show received data
    digitalWrite(13, true); 

    // Message with a good checksum received, dump it.
    Serial.print("Received message: ");

    for (int i = 0; i < buflen; i++){
      // Print message received in buffer through this loop
      Serial.print(buf[i]);
      //add space to distinguish characters from each other if showing ASCII decimal #
      //Serial.print(" "); 

      //if character received matches, turn on associated LED
      if(buf[i] == '1'){
        digitalWrite(8, HIGH);
      }
    }
    //Print next character on new line
    Serial.println("");

    //Turn off status LED
    digitalWrite(13, false);
  }
}






