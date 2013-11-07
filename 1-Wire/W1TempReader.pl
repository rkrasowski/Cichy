#!/usr/bin/perl
use warnings;
use strict;

############# W1TempReader.pl ###################################
#								#
#	Reads temperature from 18F20 Dallas 1-wire sensor	#
#	by Robert J. Krasowski					#
#	7/25/2012						#
#								#
#################################################################


# Program example: 
# To get sensor ID "cd /sys/bus/w1/devices" and ls 

my $sensorCPU ="10-0008026a7a2c";		# sensor ID
my $sensorOUT = "10-0008026a8f55";

my $CPUtemp =  W1Temp($sensorCPU);
my $OUTtemp = W1Temp($sensorOUT);
print "CPU Temp is $CPUtemp C\n";
print "OUT Temp is $OUTtemp C\n\n";



######################## Subroutine ##########################


sub W1Temp {

my $sensor = shift;
open (FH, "\/sys\/bus\/w1\/devices/$sensor\/w1_slave") or die $!;

while(<FH>)
	 {
		if ($_ =~ ("t="))
		{		
			my @array = split(/ /,$_);
			foreach (@array)
				{
					if ($_ =~ ("t="))
					{	
						
						my $temp = substr($_, 2);
						chomp $temp;
						#print "Total temp $temp\n";
						my $deg = substr($temp, 0, - 3);
						#print "Deg $deg\n";
						my $frac = substr($temp,-3);
						#print "Frac $frac\n";
						$temp = $deg.".".$frac;
						return $temp;								
					}
				}	
		}
	}
}
