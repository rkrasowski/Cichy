#!/usr/bin/perl
use warnings;
use strict;

my $pressure  = getPressure();
#print "Pressure is $pressure\n";




#my $file = '/home/ubuntu/Data/pressure.dat' or die $!;		# Name the file
open INFO, "/home/ubuntu/Data/pressure.dat" or die $!;		# Open the file
my @lines = <INFO>;		# Read it into an array
close(INFO);			# Close the file
print @lines;			# Print the array







 open PRESARCHIVES, "/home/ubuntu/Data/pressure.dat" or die $!;
 @lines = <PRESARCHIVES>;
			

                         #       print PRESARCHIVES "Presuure is $pressure\n";
                                close PRESARCHIVES;

print @lines;


################################# Subroutine #####################################














sub openfile{
    (my $filename) = @_;
    open FILE,"$filename" or die $!;
    my @lines = <FILE>;
    return @lines;
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
