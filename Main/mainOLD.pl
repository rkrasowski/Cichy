#!/usr/bin/perl
use warnings;
use strict;
use POSIX qw(floor ceil);
require '/home/ubuntu/1-Wire/W1TempReader.pm';	# module to read temp



my $Time="NA";
my $Date="NA";
my $Lat="NA";
my $Lon="NA";
my $COG="NA";
my $SOG="NA";
my $barPress="NA";
my $voltage1="NA";
my $voltage2="NA";
my $voltage3="NA";
my $light="NA";
my $xMean="NA";
my $xSD="NA";
my $xMax="NA";
my $xMin="NA";
my $yMean="NA";
my $ySD="NA";
my $yMax="NA";
my $yMin="NA";
my $zMean="NA";
my $zSD="NA";
my $zMax="NA";
my $zMin="NA";

# Config variable
my $time2Sleep;
my @time2Sleep;
my $LED;
my @LED;

###################################################
## set basic pins in BeagleBone

`echo 77 > /sys/class/gpio/export`;				# red LED
`echo 88 > /sys/class/gpio/export`;				# yellow LED
`echo 89 > /sys/class/gpio/export`;				# green LED
`echo 20 > /sys/kernel/debug/omap_mux/uart1_rxd`;		# RX pin for GPS
`echo bmp085 0x77 > /sys/class/i2c-adapter/i2c-3/new_device`;	# I2C for Barometer
`sudo modprobe ti_tscadc`;					# AIN on Ubuntu

print "\n\nStarting......\nPins are set ........\n";
###################################################
## 3 blinks all LEDs

my $i;

for ($i=0;$i<3;$i++)
        {
           
                # to turn it on
                `echo "high" > /sys/class/gpio/gpio77/direction`;
                `echo "high" > /sys/class/gpio/gpio88/direction`;
                `echo "high" > /sys/class/gpio/gpio89/direction`;

                select(undef,undef,undef,0.25);

                # to turn it off:
                `echo "low" > /sys/class/gpio/gpio77/direction`;
                `echo "low" > /sys/class/gpio/gpio88/direction`;
                `echo "low" > /sys/class/gpio/gpio89/direction`;

                select(undef,undef,undef,0.25);
        }

		`echo "high" > /sys/class/gpio/gpio89/direction`;	# Turn Greed LED on 

#####################################################
## Start background programs

# Start /GPS/gpsReader.pl

system("/home/ubuntu/GPS/gpsReader.pl &");
print "\ngpsReader started and running on background.......\n";

system("/home/ubuntu/Main/communicatorDeamon.pl &");
print "communicatorDeamon started and runnung on background........\n";

system("/home/ubuntu/Acceler/accData.pl &");
print "Accelerometer started ..........\n\nGetting data.......\n";


###########################################################
###########################################################

while (1) 
{


# Check configuration file for instructions

open (CONFIG, "\/home\/ubuntu\/Config\/config.txt") or die $!;

while( <CONFIG>)
	{
		if ($_ =~ /time2Sleep/)
                        {
                                my @time2Sleep = split(/=/,$_);
                                $time2Sleep = $time2Sleep[1];
                                chomp $time2Sleep;
                        }
		
		 if ($_ =~ /LED/)
                        {
                                my @LED = split(/=/,$_);
                                $LED = $LED[1];
                                chomp $LED;	
				print "LED is $LED\n\n\n";
                        }
 
	}

close (CONFIG);



#####################################################
## Get lates data from GPS file

open (GPSDATA, '/home/ubuntu/Data/gps.dat');

while (<GPSDATA>) 
	{
		 if ( $_ =~ /Time/)		
			{	
				my @Time = split (/=/,$_);
				$Time = $Time[1];
				chomp $Time;
				print "Time is $Time\n\n";
			}		

               if ( $_ =~ /Date/)
                        {
                                my @Date = split (/=/,$_);
                                $Date = $Date[1];
				chomp $Date;
                                print "Date is $Date\n\n";
                        }
                if ( $_ =~ /Lat/)
                        {
                                my @Lat = split (/=/,$_);
                                $Lat = $Lat[1];
				chomp $Lat;
                                print "Lat is $Lat\n\n";
                        }
                 if ( $_ =~ /Lon/)
                        {
                                my @Lon = split (/=/,$_);
                                $Lon =$Lon[1];
				chomp $Lon;
                                print "Lon is $Lon\n\n";
                        }
                 if ( $_ =~ /SOG/)
                        {
                                my @SOG = split (/=/,$_);
                                $SOG = $SOG[1];
				chomp $SOG;
                                print "SOG is $SOG\n\n";
                        }

                 if ( $_ =~ /COG/)
                        {
                                my @COG = split (/=/,$_);
                                $COG = $COG[1];
				chomp $COG;
                                print "COG is $COG\n\n";
                        }

	}

close (GPSDATA);


#####################################################
## Read temperature from sensors

# CPU sensor:
my $sensorTempCPU ="28-000003611860";                # sensor ID
my $tempCPU;


my $fileTempCPU = "\/sys\/bus\/w1\/devices/$sensorTempCPU\/w1_slave";

if ( -e $fileTempCPU)					# check if sensor is connected
        {
		$tempCPU =  W1Temp($sensorTempCPU);
		$tempCPU = sprintf("%.1f", $tempCPU);
		print "TempCPU is $tempCPU\n";
	}
else 	{
		$tempCPU = "NA";
		print "TempCPU not available\n";
	}


# External senor:
my $sensorTempOUT ="28-000003611860";                # sensor ID
my $tempOUT;

my $fileTempOUT = "\/sys\/bus\/w1\/devices/$sensorTempOUT\/w1_slave";

if ( -e $fileTempOUT)                                   # check if sensor is connected
        {
                $tempOUT =  W1Temp($sensorTempOUT);
		$tempOUT = sprintf("%.1f", $tempOUT);
                print "TempOUT is $tempOUT\n";
        }
else    {
                $tempOUT = "NA";
                print "TempOUT not available\n";
        }


# Internal sensor:

my $sensorTempIN ="28-000003611860";                # sensor ID
my $tempIN;

my $fileTempIN = "\/sys\/bus\/w1\/devices/$sensorTempIN\/w1_slave";

if ( -e $fileTempIN)                                   # check if sensor is connected
        {
                $tempIN =  W1Temp($sensorTempIN);
		$tempIN = sprintf("%.1f", $tempIN);
                print "TempIN is $tempIN\n";
        }
else    {
                $tempIN = "NA";
                print "TempIN not available\n";
        }

# Engine sensor:

my $sensorTempENG ="28-000003611860";                # sensor ID
my $tempENG;

my $fileTempENG = "\/sys\/bus\/w1\/devices/$sensorTempENG\/w1_slave";

if ( -e $fileTempENG)                                   # check if sensor is connected
        {
                $tempENG =  W1Temp($sensorTempENG);
		$tempENG = sprintf("%.1f", $tempENG);
                print "TempENG is $tempENG\n";
        }
else    {
                $tempENG = "NA";
                print "TempENG not available\n";
        }


# Water sensor:

my $sensorTempH2O ="28-0dd00003611860";                # sensor ID
my $tempH2O;

my $fileTempH2O = "\/sys\/bus\/w1\/devices/$sensorTempH2O\/w1_slave";

if ( -e $fileTempH2O)                                   # check if sensor is connected
        {
                $tempH2O =  W1Temp($sensorTempH2O);
		$tempH2O = sprintf("%.1f", $tempH2O);
                print "TempH2O is $tempH2O\n";
        }
else    {
                $tempH2O = "NA";
                print "TempH2O not available\n";
        }

######################################################
## Read barometer

$barPress = getPres();
print "Pressure is $barPress\n";


######################################################
## Get data from AIN's - Voltage

my $ain6 = "ain6";

my $voltage6 = getAIN($ain6);


print "\nVoltage 6 is  $voltage6\n\n";


######################################################
## Get data from accelerometer file

open (ACCELEROMETERCUR, " \/home\/ubuntu\/Data\/accelerometerCur.dat") or die $!;
while(<ACCELEROMETERCUR>)
	{    
		if ($_ =~ /xMean/)
			{
				my @xMean = split(/=/,$_);
				$xMean = $xMean[1];
				chomp $xMean;
			}
		
		 if ($_ =~ /xSD/)
                        {
                                my @xSD = split(/=/,$_);
                                $xSD = $xSD[1];
				chomp $xSD;
                        }

		 if ($_ =~ /xMax/)
                        {
                                my @xMax = split(/=/,$_);
                                $xMax = $xMax[1];
				chomp $xMax;
                        }

		 if ($_ =~ /xMin/)
                        {
                                my @xMin = split(/=/,$_);
                                $xMin = $xMin[1];
				chomp $xMin;
                        }

		 if ($_ =~ /yMean/)
                        {
                                my @yMean = split(/=/,$_);
                                $yMean = $yMean[1];
                                chomp $yMean;
                        }

                 if ($_ =~ /ySD/)
                        {
                                my @ySD = split(/=/,$_);
                                $ySD = $ySD[1];
                                chomp $ySD;
                        }

                 if ($_ =~ /yMax/)
                        {
                                my @yMax = split(/=/,$_);
                                $yMax = $yMax[1];
                                chomp $yMax;
                        }

                 if ($_ =~ /yMin/)
                        {
                                my @yMin = split(/=/,$_);
                                $yMin = $yMin[1];
                                chomp $yMin;
                        }

		 if ($_ =~ /zMean/)
                        {
                                my @zMean = split(/=/,$_);
                                $zMean = $zMean[1];
                                chomp $zMean;
                        }

                 if ($_ =~ /zSD/)
                        {
                                my @zSD = split(/=/,$_);
                                $zSD = $zSD[1];
                                chomp $zSD;
                        }

                 if ($_ =~ /zMax/)
                        {
                                my @zMax = split(/=/,$_);
                                $zMax = $zMax[1];
                                chomp $zMax;
                        }

                 if ($_ =~ /zMin/)
                        {
                                my @zMin = split(/=/,$_);
                                $zMin = $zMin[1];
                                chomp $zMin;
                        }


	}
close ACCELEROMETERCUR;



######################################################
## Put data into current.dat



open (CURRENT, "> \/home\/ubuntu\/Data\/current.dat") or die $!;

print CURRENT "Time=$Time\nDate=$Date\nLat=$Lat\nLon=$Lon\nSOG=$SOG\nCOG=$COG\nPres=$barPress\nTempCPU=$tempCPU\nTempOUT=$tempOUT\nTempIN=$tempIN\nTempENG=$tempENG\nTempH20=$tempH2O\nVoltage1=$voltage1\nVoltage2=$voltage2\nVoltage3=$voltage3\nVoltage6=$voltage6\nLight=$light\nxMean=$xMean\nxSD=$xSD\nxMax=$xMax\nxMin=$xMin\nyMean=$yMean\nySD=$ySD\nyMax=$yMax\nyMin=$yMin\nzMean=$zMean\nzSD=$zSD\nzMax=$zMax\nzMin=$zMin\n";

close (CURRENT);

print "Data entered into crrent.dat.\n";


#####################################################
## Put data into daily archives

open (DAILYARCH, ">> \/home\/ubuntu\/Archives\/daily.arch") or die $!;

print DAILYARCH "$Time,$Date,$Lat,$Lon,$SOG,$COG,$barPress,$tempCPU,$tempOUT,$tempIN,$tempENG,$tempH2O,$voltage1,$voltage2,$voltage3,$voltage6,$light,$xMean,$xSD,$xMax,$xMin,$yMean,$ySD,$yMax,$yMin,$zMean,$zSD,$zMax,$zMin\n";

close (DAILYARCH);

print "Data entered into daily.arch.\n";


# blink yellow LED 

if ($LED eq "on")
	{
		`echo "high" > /sys/class/gpio/gpio88/direction`;
		select(undef,undef,undef,0.25);
		`echo "low" > /sys/class/gpio/gpio88/direction`;
	}

########################################################
# Tme to sleep


print "Going to sleep for $time2Sleep sec ........................\n\n";
sleep($time2Sleep);

}

####################################################################################################
############################################  Subroutines ##########################################

sub getPres 
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



sub getAIN 
{
my $ain = shift;
my @array;
my $numEl;

do
        {
                open (FH, "\/sys\/devices\/platform\/omap\/tsc\/$ain") or die $!;


                select (undef,undef,undef,0.25);
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



sub memStatistics {
my $memory = `df -h`;
#print "My memeory: $memory\n";

my @memory = split(/\n/,$memory);

# Get first line
my $first = $memory[1];

# Get available memory
my @memoryFirst = split(/ /,$first);
my $memoryFirst;

my $usedMem = $memoryFirst[5];
my $availableMem = $memoryFirst[8];
my $percentageMem = $memoryFirst[11];

my @array = ($usedMem,$percentageMem,$availableMem);
return @array;

}

