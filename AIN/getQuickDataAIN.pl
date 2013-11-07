#!/usr/bin/perl 
use strict;
use warnings;
use POSIX qw(floor ceil);
######## getDataAIN.pl ##########
#	Gets data from ain	#
#	by Robert J Krasowski	#
#	7/29/2012		#
#################################

# to activate AIN's do sudo sudo modprobe ti_tscadc 


 
my $ain = "ain4";

my $value = getAIN($ain);


print "\nFinal is  $value\n\n";



######################## Subroutines #################################

sub getAIN 
	{
		my $ain = shift;
		my @array;
		my $numEl;

		do 
			{
				open (FH, "\/sys\/devices\/platform\/omap\/tsc\/$ain") or die $!;
				select (undef,undef,undef,0.01);
				while (<FH>)
					{	
						chomp $_;
						$_ =~ s/\0//g;
						#print "Value is $_\n";	
						push (@array,"$_");		
					}

		 		$numEl = @array;
				close(FH);
			} until  ($numEl == 12);
	
		shift @array;
		pop @array;
		my $total = 0;
		($total+=$_) for @array;
		my $value = $total / 10;

		$value = $value/40;
		$value = floor($value);
		return $value;
	}



