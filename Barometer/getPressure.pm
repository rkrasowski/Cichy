#!/usr/bin/perl 
use strict;
use warnings;

######## getPressure.pm #########
#	Gets data from ain	#
#	by Robert J Krasowski	#
#	8/4/2012		#
#################################

######################## Subroutines #################################


sub getPressure 
{


	my @array;
	my $numEl;
	my $correction = 1.03;
	my $value;
		do 	
			{
				open (FH, "\/sys\/bus\/i2c\/drivers\/bmp085\/3-0077\/pressure0_input") or die $!;
				while (<FH>)
				{
				
					chomp $_;
					push (@array,"$_");
				
				}	


				$numEl = @array;

				close(FH);


		} until  ($numEl == 12);		
		
		shift @array;
		pop @array;
		my $total = 0;
		($total+=$_) for @array;
		$value = $total / 10;

		$value = $value/100;
		$value = $value * $correction;
		$value = sprintf("%.1f", $value); 
		return $value;
}
1;


