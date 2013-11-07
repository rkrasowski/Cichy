#!/usr/bin/perl
use warnings;
use strict;


my $pinNum = 70;		# Red LED 
my $buzz = 74;			# Buzz pin

# Set up mux for pin P8_40
`echo $pinNum > /sys/class/gpio/export`;


while (1) {
# to turn it on:

`echo "high" > /sys/class/gpio/gpio$pinNum/direction`;
`echo "high" > /sys/class/gpio/gpio$buzz/direction`;
select(undef,undef,undef,0.1);
# to turn it off:

`echo "low" > /sys/class/gpio/gpio$pinNum/direction`;
`echo "low" > /sys/class/gpio/gpio$buzz/direction`;
select(undef,undef,undef,3);
}

