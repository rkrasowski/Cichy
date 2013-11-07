#!/usr/bin/perl 
use strict;
use warnings;
######## getDataAIN.pl ##########
#	Gets data from ain	#
#	by Robert J Krasowski	#
#	7/29/2012		#
#################################

# to activate AIN's do sudo sudo modprobe ti_tscadc 


 
my $ain = "ain4";



open (FH, "\/sys\/devices\/platform\/omap\/tsc\/$ain") or die $!;

while (<FH>)
	{
		my $value = $_;
		chomp $value;
		print "Before $value\n";
		$value =~ s/\0//;
		$value = $value / 40;
		print "Post $value\n\n";
		
	}

close(FH);


