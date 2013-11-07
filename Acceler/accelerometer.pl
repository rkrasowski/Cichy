#!/usr/bin/perl 
use strict;
use warnings;

############### acceerometer.pl #####################
#													#
#	Reads accelemeter data via c program mma7455 	#
#	and return x,y,z value							#
# 	by Robert J. Krasowski							#
#	8/7/2012										#
#													#
#####################################################


my $x;
my $y;
my $z;

my $xCorr = 11;
my $yCorr = 18;
my $zCorr = 56;


my $array;

open(PS,"./mma7455 |") || die "Failed: $!\n";
while ( <PS> )
{
  my @array = split (/\|/,$_);
  
  	$x = $array[0];
	
	$y = $array[1];
	
	$z = $array[2];
	
}
 
close(PS);

$x = $x + $xCorr;
$y = $y + $yCorr;
$z = $z + $zCorr;



print "X = $x\nY = $y\nZ = $z\n";



