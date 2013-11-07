#!/usr/bin/perl
use warnings;
use strict;


my $pinNum = 88;
# turn LED off

`echo "low" > /sys/class/gpio/gpio$pinNum/direction`;

