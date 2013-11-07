#!/usr/bin/perl
######################################## serialTest.pl ##################################
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
#print "UART1 Rx set done....PIN 26 \n";

# set variables:

my $COG = "00.0";
my $SOG = "000";
my $gpsTime = "";
my $gpsDate = "";
my $LatDDMM = "";
my $googleLat = "";
my $LonDDMM = "";
my $googleLon = "";
my $status = "";



# Activate serial connection:
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

                             #   print $serialData;

				print "GPRMS: $serialData\n";
                                # split gps data by coma

                                my @gps = split (/\,/,$serialData);
                                my $gps;

                                ###########################################
                                # check if GPS data is valid 
                                # Status  A - data valid,  V - data not valid

                                $status = $gps[2];
                                                        if ($status eq "A"){

                                ##########################################
                                # get time
                                $gpsTime = $gps[1];
                                my @gpsTime = split(//,$gpsTime);
                                my $hour = $gpsTime[0].$gpsTime[1];
                                my $min = $gpsTime[2].$gpsTime[3];
                                my $sec = $gpsTime[4].$gpsTime[5];
                                $gpsTime = $hour.":".$min.":".$sec;

                                ###########################################
                                # get date
                                $gpsDate = $gps[9];
                                my @gpsDate = split(//,$gpsDate);
                                my $day = $gpsDate[0].$gpsDate[1];
                                my $month = $gpsDate[2].$gpsDate[3];
                                my $year = $gpsDate[4].$gpsDate[5];
                                $gpsDate = $month."/".$day."/".$year;

                                ###########################################
                                # get Lat 
                                my $gpsLat = $gps[3];
                                my @degminsec = split (/\./,$gpsLat);
                                my $degminsec;
                                my @degmin = split (//,$degminsec[0]);
                                my $degLat = $degmin[0].$degmin[1];
                                my $minLat = $degmin[2].$degmin[3];
                                my $decMinLat = $degminsec[1];
                                my $NS = $gps[4];

                                $LatDDMM = $NS.$degLat."deg".$minLat.".".$decMinLat."min";      # DD MM.mmm format
                                my $minDecMinLat  = $minLat.".".$decMinLat;
                                my $decDD = $minDecMinLat * 1667;
                                $decDD = sprintf ("%5d",$decDD);
                                my $plusMinusNS;
                                if ($NS eq "N")
                                        {
                                                $plusMinusNS = "";
                                        }
                                else {$plusMinusNS = "-";}

                                $googleLat = $plusMinusNS.$degLat.".".$decDD;           # DD.ddddd format

                                ###########################################################################
                                # get Longitude
                                my $gpsLon = $gps[5];
                                my @degminsecLon = split (/\./,$gpsLon);
                                my $degminsecLon;
                                my @degminLon = split (//,$degminsecLon[0]);
                                my $degLon = $degminLon[0].$degminLon[1].$degminLon[2];
                                my $minLon = $degminLon[3].$degminLon[4];
                                my $decMinLon = $degminsecLon[1];
                                my $EW = $gps[6];

                                $LonDDMM = $EW.$degLon."deg".$minLon.".".$decMinLon."min";      # DD MM.mmm format

                                my $minDecMinLon  = $minLon.".".$decMinLon;
                                my $decDDLon = $minDecMinLon * 1667;
                                $decDDLon = sprintf ("%5d",$decDDLon);
                                my $plusMinusEW;
                                if ($EW eq "E")
                                        {
                                                $plusMinusEW = "";
                                        }
                                else {$plusMinusEW = "-";}

                                $googleLon = $plusMinusEW.$degLon.".".$decDDLon;                # DD.ddddd format

                                ##########################################################################
                                # get SOG

                                $SOG = $gps[7];
                                $SOG = sprintf("%.1f",$SOG);
                        #       $SOG = sprintf("%02d",$SOG);

                                #########################################################################
                                # get COG 

                                $COG = $gps[8];
                                if ($COG eq ""){
                                        $COG = 000;}
                                $COG = sprintf("%03d",$COG);

                                }

                                else
                                        {
                                                $gpsDate = "00\/00\/00";
                                                $gpsTime = "00:00";
                                                $LatDDMM = "00deg00.00000min";
                                                $googleLat = "00.00000";
                                                $LonDDMM = "000deg 00.00000min";
                                                $googleLon = "000.00000";
                                        }
                                ########################################################################
                                ########################################################################


                                #print "gpsDate is $gpsDate\n";
                                #print "gpsTime is $gpsTime\n";
		                #print "Lat is $LatDDMM\n";
                                #print "Google Lat is $googleLat\n";
                                #print "Lon is $LonDDMM\n";
                                #print "Google Lon is $googleLon\n";
                                #print "SOG is $SOG\n";
                                #print "Cog is $COG\n";
                                #print "Status is $status\n";
	#			print "GPS is on\n";

chomp $gpsDate;
chomp $gpsTime;
chomp $googleLat;
chomp $googleLon;
chomp $SOG;
chomp $COG;
                                open GPSARCHIVES, ">/home/ubuntu/Data/gps.dat" or die $!;
                                print GPSARCHIVES "Date=$gpsDate\nTime=$gpsTime\nLat=$googleLat\nLon=$googleLon\nSOG=$SOG\nCOG=$COG\nStatus=$status\n";
                                close GPSARCHIVES;



                        }



        }

 undef $ob;

