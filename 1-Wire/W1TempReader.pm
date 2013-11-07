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
1;
