#!/usr/bin/perl
use strict;
use warnings;

# Set up time on BeageBone base on GPS time

   # nn is a two digit month, between 01 to 12
   # dd is a two digit day, between 01 and 31, with the regular rules for days according to month and year applying
   # hh is two digit hour, using the 24-hour period so it is between 00 and 23
   # mm is two digit minute, between 00 and 59
   # yyyy is the year; it can be two digit or four digit: your choice. I prefer to use four digit years whenever I can for better clarity and less confusion
   # ss is two digit seconds. Notice the period ‘.’ before the ss.


# get sentence GPRMC 
# f.ex $GPRMS,A,161229.487,lat,N,lon,W,speed,'course,100112,
# UTC : hhmmss.sss
# Date : ddmmyy
#######################################################################

# start GPS

#!/usr/bin/perl
######################################## gpsReader.pl ##################################
#                                                                                       #
#       Setting up serial pin for communication with simple program transmitting text   #
#       pin 21 ans 22 in P9                                                             #
#       by Robert J. Krasowski                                                          #
#       7/23/2012                                                                       #
#                                                                                       #
#########################################################################################

use strict;
use warnings;
use Device::SerialPort;

# set pins in appropriate modes:
# Set UART 1

# Set Rx pin



`echo 20 > /sys/kernel/debug/omap_mux/uart1_rxd`;
print "UART1 Rx set done....PIN 26 \n";



my $PORT = "/dev/ttyO1";
my $serialData;

my $ob = Device::SerialPort->new($PORT) || die "Can't Open $PORT: $!";

$ob->baudrate(4800) || die "failed setting baudrate";
$ob->parity("none") || die "failed setting parity";
$ob->databits(8) || die "failed setting databits";
$ob->handshake("none") || die "failed setting handshake";
$ob->write_settings || die "no settings";
$| = 1;


#print "Ready to receive\n";
open( DEV, "<$PORT" ) || die "Cannot open $PORT: $_";


#print "Port is open\n";
while ( $serialData = <DEV> )
         {

                if ($serialData =~ m/GPRMC/)
                        {

                              # print $serialData;

				
                                # split gps data by coma

                                my @GPRMC = split (/\,/,$serialData);
                             

                             ###########################################
                                # check if GPS data is valid 
                                # Status  A - data valid,  V - data not valid

                                my $status = $GPRMC[2];
                                 if ($status eq "A")
                                       {

											my @array = split(/,/,$serialData);
											my $time = $array[1];

											my @time = split(/\./,$time);
											my $time1 = $time[0];
											print "Time $time1\n";
											my @time1 = split(//,$time1);
											my $hour = $time1[0].$time1[1];
											print "Hour $hour\n";
											my $minute = $time1[2].$time1[3];
											print "Minutes $minute\n";
											my $second = $time1[4].$time1[5];
											print "Seconds $second\n";


											my $date = $array[9];
											print "Date $date\n";
											my @date = split(//,$date);
											my $day = $date[0].$date[1];
											print "Day $day\n";

											my $month = $date[2].$date[3];
											print "Month $month\n";

											my $year = "20".$date[4].$date[5];
											print "Year $year\n";

											my $time2set = $month.$day.$hour.$minute.$year.".".$second;

											print "Time 2set $time2set\n";

											`sudo date $time2set`;
											print "\nTime was synchronized with GPS\n\n";
											exit();

										}
						}
								


}

