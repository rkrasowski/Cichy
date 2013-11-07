#!/usr/bin/perl
use warnings;
use strict;

# Turning red LED nicely

my $pinNum = 88;


# find the PID
my $PID = `pgrep -x yellow.pl`;

# kill the process

`kill $PID`;

# turn LED off

`echo "low" > /sys/class/gpio/gpio$pinNum/direction`;

