#!/usr/bin/perl 
use strict;
use warnings;

#######################  sendM2M.pl #############################
#								#
#	Every few hours check and send data to central server 	#
#								#
#################################################################



# Variable for configuration
my $time2sleep;							# number of hours of sleep between sending a message


# Variables from sensors:
my $lat = "12.38298";
my $lon = "-34.12345";
my $SOG = 4.7;
my $COG = 034;
my $pres = 1011.4;
my $presChange1h = 1.2;
my $presChange4h = 2.0;
my $tempCPU;
my $tempOUT = 23.4;
my $tempENG = 67.1;
my $tempH2O = 18.2;
my $batt1 = 12.3;
my $batt2 = 12.4;
my $batt3 = 11.8;
my $batt4 = 14.0;
my $light = 65;
my $xMean = 12;
my $xSD = 3;
my $yMean = 9;
my $ySD = 2;
my $zMean = 32;
my $zSD = 4;









# Main routine :


while (1) {

# Check configuration file for instructions

open (CONFIG, "\/home\/ubuntu\/Config\/config.txt") or die $!;

my @configArray = <CONFIG>;

close (CONFIG);


# get time2sleep value
my $configArray;

$time2sleep = $configArray[0];

#################################################################################################
# get data from GPS






#################################################################################################
# get data from accelerometer file


open (ACC, "\/home\/ubuntu\/Data\/accCurrent.dat") or die $!;

my @ACCArray = <ACC>;

close (ACC);

my $ACCArray;

$xMean = $ACCArray[0];
chomp $xMean;
$xSD = $ACCArray[1];
chomp $xSD;
$yMean = $ACCArray[2];
chomp $yMean;
$ySD = $ACCArray[3];
chomp $ySD;
$zMean = $ACCArray[4];
chomp $zMean;
$zSD = $ACCArray[5];
chomp $zSD;

#################################################################################################
# get data from termometers

# tempCPU 
my $sensorCPUID ="28-000003611860";                # sensor tempCPU ID
$tempCPU =  W1Temp($sensorCPUID);
$tempCPU = sprintf("%.1f", $tempCPU);
print "TempCPU is $tempCPU\n\n";

# tempOUT

# tempENG 

# tempH2O


#################################################################################################
# get data from ac converters - battery voltage 




#################################################################################################
# get data from barometer





################################################################################################
# format message for M2M
$SOG = $SOG * 10;			# to eliminate period
$pres = $pres * 10;
$presChange1h = $presChange1h * 10;
$presChange4h = $presChange4h * 10;
$tempCPU = $tempCPU * 10;
$tempOUT = $tempOUT *10;
$tempENG = $tempENG * 10;
$tempH2O = $tempH2O * 10;
$batt1 = $batt1 * 10;
$batt2 = $batt2 * 10;
$batt3 = $batt3 * 10;
$batt4 = $batt4 * 10;
my $time = time();


my $message = "%".$time.",".$lat.",".$lon.",".$SOG.",".$COG.",".$pres.",".$presChange1h.",".$presChange4h.",".$tempCPU.",".$tempOUT.",".$tempENG.",".$tempH2O.",".$batt1.",".$batt2.",".$batt3.",".$batt4.",".$xMean.",".$xSD.",".$yMean.",".$ySD.",".$zMean.",".$zSD."%";


# for developement calculate the number of chracters

my @Chars = split("", $message);
my $num = @Chars;

print "\nNum of elements is  $num\n";
print "Message is $message\n";




##############################################################################################
# send the message 





###############################################################################################
# waiting routine 

print "Before sleep\n";
print "Time2sllep is $time2sleep\n..............................\n\n";

sleep ($time2sleep);

print "After sleep\n";

}








############################################################################################
##################  subroutines  ###########################################################



sub W1Temp {

my $sensor = shift;
open (FH, "\/sys\/bus\/w1\/devices/$sensor\/w1_slave") or die $!;

while(<FH>)
         {
                if ($_ =~ ("t="))
                {
                        my @array = split(/ /,$_);
                        foreach (@array)
                                {
                                        if ($_ =~ ("t="))
                                        {

                                                my $temp = substr($_, 2);
                                                chomp $temp;
                                                #print "Total temp $temp\n";
                                                my $deg = substr($temp, 0, - 3);
                                                #print "Deg $deg\n";
                                                my $frac = substr($temp,-3);
                                                #print "Frac $frac\n";
                                                $temp = $deg.".".$frac;
                                                return $temp;
                                        }
                                }
                }
        }
}

