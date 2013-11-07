#!/usr/bin/perl 
use strict;
use warnings;

my $pinNumRed = 77;
my $pinNumGreen = 89;
my $pinNumYellow = 88;

my $i;

for ($i=0;$i<3;$i++)
	{
		# Set up pins
		`echo $pinNumRed > /sys/class/gpio/export`;
		`echo $pinNumGreen > /sys/class/gpio/export`;
		`echo $pinNumYellow > /sys/class/gpio/export`;

		# to turn it on
		`echo "high" > /sys/class/gpio/gpio$pinNumRed/direction`;
		`echo "high" > /sys/class/gpio/gpio$pinNumGreen/direction`;
		`echo "high" > /sys/class/gpio/gpio$pinNumYellow/direction`;

		select(undef,undef,undef,0.25);

		# to turn it off:
		`echo "low" > /sys/class/gpio/gpio$pinNumRed/direction`;
		`echo "low" > /sys/class/gpio/gpio$pinNumGreen/direction`;
		`echo "low" > /sys/class/gpio/gpio$pinNumYellow/direction`;

		select(undef,undef,undef,0.25);
	}

