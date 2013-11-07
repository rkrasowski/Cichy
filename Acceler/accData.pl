#!/usr/bin/perl 
use strict;
use warnings;


############################### AccData.pl ##############################
#									#
#	Gets data from accelerometer, put t into array,			#
#	calculate mean,max, min, SD, put it into permanent data		#
#	as well as to active file					#
#									#
#########################################################################


# set up variable:

my $numCheck = 10;			# number of checks 
my $xCorr = 11;				# correction for X
my $yCorr = 18;				# correction for Y	
my $zCorr = 56;				# correction for Z



# used variable: 

my $x;
my $xMean;
my $xMax;
my $xMin;
my $xSD;
my @arrayX;


my $y;
my $yMean;
my $yMax;
my $yMin;
my $ySD;
my @arrayY;

my $z;
my $zMean;
my $zMax;
my $zMin;
my $zSD;
my @arrayZ;



while(1) {

# getting data 
for (my $i=0;$i<$numCheck;$i++)
	{
		open(PS,"/home/ubuntu/Acceler/mma7455 |") || die "Failed: $!\n";
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

		push(@arrayX, $x);		
		push(@arrayY, $y);
		push(@arrayZ, $z);

	#	print "ArrayX @arrayX\n";
		sleep (1);

	}



# calculating average, SD, max, min

@arrayX = sort @arrayX;
$xMax = $arrayX[0];
$xMin = $arrayX[-1];
$xMean = average(\@arrayX);
$xMean = sprintf ("%0.1f",$xMean);
$xSD = stdev(\@arrayX);
$xSD = sprintf ("%0.2f",$xSD);
#print "xMean is $xMean\nxSD is $xSD\nxMax is $xMax\nxMin is $xMin\n\n";

@arrayY = sort @arrayY;
$yMax = $arrayY[0];
$yMin = $arrayY[-1];
$yMean = average(\@arrayY);
$yMean = sprintf ("%0.1f",$yMean);
$ySD = stdev(\@arrayY);
$ySD = sprintf ("%0.2f",$ySD);
#print "yMean is $yMean\nySD is $ySD\nyMax is $yMax\nyMin is $yMin\n\n";

@arrayZ = sort @arrayZ;
$zMax = $arrayZ[0];
$zMin = $arrayZ[-1];
$zMean = average(\@arrayZ);
$zMean = sprintf ("%0.1f",$zMean);
$zSD = stdev(\@arrayZ);
$zSD = sprintf ("%0.2f",$zSD);
#print "zMean is $zMean\nzSD is $zSD\nzMax is $zMax\nzMin is $zMin\n\n";


# putting data into current data

open (ACCELEROMETERCUR, "> \/home\/ubuntu\/Data\/accelerometerCur.dat") or die $!;
print ACCELEROMETERCUR "meanX=$xMean\nsdX=$xSD\nmaxX=$xMax\nminX=$xMin\nmeanY=$yMean\nsdY=$ySD\nmaxY=$yMax\nminY=$yMin\nmeanZ=$zMean\nsdZ=$zSD\nmaxZ=$zMax\nminZ=$zMin\n";
close ACCELEROMETERCUR;

}

####################################################### Subroutines #######################





sub average{
        my($data) = @_;
        if (not @$data) {
                die("Empty array\n");
        }
        my $total = 0;
        foreach (@$data) {
                $total += $_;
        }
        my $average = $total / @$data;
        return $average;
}


sub stdev{
        my($data) = @_;
        if(@$data == 1){
                return 0;
        }
        my $average = &average($data);
        my $sqtotal = 0;
        foreach(@$data) {
                $sqtotal += ($average-$_) ** 2;
        }
        my $std = ($sqtotal / (@$data-1)) ** 0.5;
        return $std;
}
