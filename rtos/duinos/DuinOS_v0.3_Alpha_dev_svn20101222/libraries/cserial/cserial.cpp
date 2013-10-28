/*
  cserial.cpp - these two c functions are required so that stdout can be initialized for the stdio library
  This binds the printf function to the hardware serial port
    
  Copyright (c) 2010  Paula Keezer

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
   * Neither the name of the copyright holders nor the names of
     contributors may be used to endorse or promote products derived
     from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE.
*/

#include “cserial.h”
#include “wiring_private.h”

static int serial_write(char c, FILE *f) {

/* Wait for transmit buffer to be empty */
while ((UCSR0A & _BV(UDRE0)) == 0)
;

/* Put byte into transmit buffer */
UDR0 = c;

return 0;
}

static FILE sio_stdout = {0} ;                           /* added to support the DH mod eliminating stdio malloc requirements */

void serial_stdout_init (long speed) {
/* Set baud rate */
uint16_t factor = (F_CPU / 16 + speed / 2) / speed – 1;
UBRR0H = factor >> 8;
UBRR0L = factor;

/* Set format (8N1) */
UCSR0C = 3 << UCSZ00;

/* Enable transmitter */

UCSR0B = _BV(TXEN0);

/* Set up stdout to write to the serial port */
/* stdout = fdevopen (serial_write, NULL);  replaced with the following care of DH */

fdev_setup_stream(&sio_stdout, serial_write, NULL,_FDEV_SETUP_WRITE);
stdout = &sio_stdout ;

}

