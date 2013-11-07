#!/usr/bin/perl
use warnings;
use strict;

############# requiredTest.pl ###################################
#                                                               #
#       Reads temperature from 18F20 Dallas 1-wire sensor	#
#	using require					        #
#       by Robert J. Krasowski                                  #
#       7/25/2012                                               #
#                                                               #
#################################################################

require 'W1TempReader.pm';
# Program example: 
# To get sensor ID "cd /sys/bus/w1/devices" and "ls" 



my $sensorID ="28-000003611860";                # sensor ID


while (1) {
sleep(1);
my $temp =  W1Temp($sensorID);
print "Temp is $temp C\n";

open TEMPCPUARCHIVES, ">/home/ubuntu/Data/tempCPU.dat" or die $!;
print TEMPCPUARCHIVES "TempCPU  = $temp\n";
close TEMPCPUARCHIVES;

}


