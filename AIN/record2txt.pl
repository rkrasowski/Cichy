#!/usr/bin/perl
use warnings;
use strict;

require 'getDataAIN.pm';

my $ain = "ain6";



while (1){
sleep(30);
my $solar = getAIN($ain);

open (FH, ">>data.txt") or die $!;

print FH "$solar\n";

close (FH);


print "Solar intensity is  $solar%\n";
}
