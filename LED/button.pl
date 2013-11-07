#!/usr/bin/perl
######################################## bbSerialPortTester.pl ##################################
#                                                                                       #
#       Setting up serial pin for communication with simple program transmitting text   #
#       pin 21 ans 22 in P9                                                             #
#       by Robert J. Krasowski                                                          #
#       7/23/2012                                                                       #
#                                                                                       #
#########################################################################################

use strict;
use warnings;

my $PID;
my $pinRed = 70;
my $pinYellow = 75;
my $buttonPin = 71;
# Set pin 71  2_7)

`echo $buttonPin > /sys/class/gpio/export`; 
`echo "in" > /sys/class/gpio/gpio$buttonPin/direction`;


while(1){
open (FH, "\/sys\/class\/gpio\/gpio$buttonPin\/value") or die $!;


                                while (<FH>)
                                {
                                        if ($_ == 1 )
						{
							print "Nacisniety\n";

							
							# find the PID of redLED
							$PID = `pgrep -x fastRed.pl`;
							if ($PID){
							# kill the process
							`kill $PID`;}
							
							 $PID = `pgrep -x fastYellow.pl`;
                                                        if ($PID){
							# kill the process
                                                        `kill $PID`;}

							# turn LED off
							`echo "low" > /sys/class/gpio/gpio$pinRed/direction`;
							`echo "low" > /sys/class/gpio/gpio$pinYellow/direction`;



			
							
						}
                                }

			
                                

                                close(FH);
				select(undef,undef,undef,0.15);
			}


