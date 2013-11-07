#!/usr/bin/perl
use warnings;
use strict;


my $pinNum = 77;

# turn LED off

`echo "low" > /sys/class/gpio/gpio$pinNum/direction`;

