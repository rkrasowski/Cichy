#!/usr/bin/perl
use warnings;
use strict;

# Turning red LED nicely

my $pinNum = 70;
my $PID;

# find the PID
$PID = `pgrep -x fastRed.pl`;

# kill the process

`kill $PID`;

# turn LED off

`echo "low" > /sys/class/gpio/gpio$pinNum/direction`;

