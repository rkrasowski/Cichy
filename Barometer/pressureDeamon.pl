#!/usr/bin/perl
use warnings;
use strict;


while (1)
	{
		my $pressure  = getPressure();
		addPressure2file($pressure);
		sleep(1800);
	}








################################# Subroutine #####################################

sub addPressure2file {
	
my $pressure = shift;
my $file = '/home/ubuntu/Data/pressure.dat';		# Name the file

 unless (-e $file) {
 qx(touch $file);
 } 



open INFO, "$file" or die $!;
my @lines = <INFO>;		
my $numelements=@lines;

if ($numelements < 24)	
	{
		print "In if function\n";
		open INFO, ">>$file" or die $!;
		print INFO "$pressure\n";
		close(INFO);
	}
	
else {
		
		open INFO, "$file" or die $!;
		my @lines2 = <INFO>;
		shift @lines2;
		push(@lines2, "$pressure\n");
		close INFO;
		open INFO, ">$file";
		print INFO @lines2;
		close(INFO);
			
	}

}





sub getPressure {
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
