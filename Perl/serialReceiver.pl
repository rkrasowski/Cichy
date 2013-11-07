#!/usr/bin/perl
######################################## serialTest.pl ##################################
#											#
#	Setting up serial pin for communication with simple program transmitting text 	#
#	pin 21 ans 22 in P9 								#
#	by Robert J. Krasowski 								#
#	7/23/2012									#
#											#
#########################################################################################

use strict;
use warnings;
use Device::SerialPort;

# set pins in appropriate modes:
# Set UART 2
# Set Tx pin

`echo 1 > /sys/kernel/debug/omap_mux/spi0_d0`;
print "UART2 Tx set done....PIN 21\n";

# set Rx pin
`echo 21 > /sys/kernel/debug/omap_mux/spi0_sclk`;
print "UART2 Rx set done....PIN 22\n";

# Activate serial connection:
my $PORT = "/dev/ttyO2"; 
my $serialData;

my $ob = Device::SerialPort->new($PORT) || die "Can't Open $PORT: $!";

$ob->baudrate(9600) || die "failed setting baudrate";
$ob->parity("none") || die "failed setting parity";
$ob->databits(8) || die "failed setting databits";
$ob->handshake("none") || die "failed setting handshake";
$ob->write_settings || die "no settings";
$| = 1;



open( DEV, "<$PORT" ) || die "Cannot open $PORT: $_";


while ( $serialData = <DEV> ) { 
	
	
	
	print"Received data: $serialData\n";
	
										

}

 undef $ob;

