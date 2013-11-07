#!/usr/bin/perl
use warnings;
use strict;

require 'getDataAIN.pm';

my $ain = "ain6";



while (1){
sleep(1);
my $value = getAIN($ain);
print "Solar intensity is  $value%\n";
}
