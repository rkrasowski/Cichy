#!/usr/bin/perl 
use strict;
use warnings;

require 'getPressure.pm';

while (1) {
my $pressure = getPressure();

sleep(30);


open (FH, ">>data.txt") or die $!;

print FH "$pressure\n";

close (FH);


print "Pressure  is  $pressure hPa\n";
}

