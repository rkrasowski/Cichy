#!/usr/bin/perl
use warnings;
use strict;


my $pinNum = 77;

# Set up mux for pin P8_40
`echo $pinNum > /sys/class/gpio/export`;

# to turn it on:

`echo "high" > /sys/class/gpio/gpio$pinNum/direction`;

