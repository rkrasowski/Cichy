#!/usr/bin/perl
use warnings;
use strict;
require '/home/ubuntu/1-Wire/W1TempReader.pm';  # module to read temp
use POSIX qw(floor ceil);



############### mainMessageCoderDecoder.pl ##############################
#									#
#	Program coding and decding main message for telemetry system	#
#	by Robert J. Krasowski						#
#	May 7, 2013							#
#									#
#########################################################################


my $UNIXtime;
my $lat;
my $NS;
my $lon;
my $EW;
my $COG;
my $SOG;
my $barPres;
my $presChange3h ;
my $presChange6h;
my $tempCPU;
my $tempOUT;
my $tempIN ;
my $tempENG ;
my $temp2;
my $volt1;
my $volt2;
my $volt3;
my $meanX;
my $sdX;
my $maxX;
my $minX;
my $meanY;
my $sdY;
my $maxY;
my $minY;
my $meanZ;
my $sdZ;
my $maxZ;
my $minZ;
my $light;
my $debug = 1;	# if 0- no debugging messages , if 1 debug messages are shown
	

# Code the message:

my $coded =coderMainMessage ();
print "$coded\n";


exit();

# Decode message:

my %decoded = decoderMainMessage($coded);




$UNIXtime = $decoded{'UNIXtime'};

print "Unix time decoded is: $UNIXtime\n";

my $latDec = $decoded{'lat'};
print "Lat : $latDec\n";

my $lonDec = $decoded{'lon'};
print "Lat : $lonDec\n";

$SOG = $decoded{'SOG'};
print "SOG: $SOG\n";

$COG = $decoded{'COG'};
print "COG: $COG\n";

$barPres = $decoded{'barPres'};
print "Bar Presure: $barPres hPa\n";

$presChange3h = $decoded{'presChange3h'};
print "Pres change 3h: $presChange3h\n";

$presChange6h = $decoded{'presChange6h'};
print "Pres change 6h: $presChange6h\n";


$tempCPU = $decoded{'tempCPU'};
print "tempCPU: $tempCPU C\n";

$tempOUT = $decoded{'tempOUT'};
print "tempOUT: $tempOUT C\n";

$tempIN = $decoded{'tempIN'};
print "tempIN: $tempIN C\n";

$tempENG = $decoded{'tempENG'};
print "tempENG: $tempENG C\n";

$temp2 = $decoded{'temp2'};
print "temp2: $temp2 C\n";

$volt1 = $decoded{'volt1'};
print "volt1: $volt1 V\n";

$volt2 = $decoded{'volt2'};
print "volt2: $volt2 V\n";

$volt3 = $decoded{'volt3'};
print "volt3: $volt3 V\n";

$meanX = $decoded{'meanX'};
print "meanX: $meanX\n";

$sdX = $decoded{'sdX'};
print "sdX: $sdX\n";

$meanY = $decoded{'meanY'};
print "meanY: $meanY\n";

$sdY = $decoded{'sdY'};
print "sdY: $sdY\n";

$meanZ = $decoded{'meanZ'};
print "meanZ: $meanZ\n";

$sdZ = $decoded{'sdZ'};
print "sdZ: $sdZ\n";

$light = $decoded{'light'};
print "Light: $light\n";

################################################################ Subroutines ####################################


sub coderMainMessage{
	
my $UNIXtime; 
my $lat;
my $NS;
my $lon;
my $EW;
my $COG;
my $SOG;
my $barPres;
my $presChange3h;
my $presChange6h;
my $tempCPU;
my $tempOUT;
my $tempIN;
my $tempENG;
my $temp2;
my $volt1;
my $volt2;
my $volt3;
my $meanX;
my $sdX;
my $meanY;
my $sdY;
my $meanZ;
my $sdZ;
my $light;
my $lightSensor = "ain4";
my $volt1AIN = "ain1";
my $volt2AIN = "ain2";
my $volt3AIN = "ain3";

## start AIN on Ubuntu

`sudo modprobe ti_tscadc`; 

## get data from GPS archives
my $gpsCurr = '/home/ubuntu/Data/gps.dat';	
open GPS, "$gpsCurr" or die $!;
my @lines = <GPS>;	
my $lines;		
	foreach(@lines)
		{
					
			if ($_ =~ m/UNIXTime/)
				{
					my @UNIX = split(/=/,$_);
					my $UNIX;
					$UNIXtime =   $UNIX[1];
					chomp $UNIXtime;
					# remove first 2 numbers from UNIX time:
					$UNIXtime =~ s/.//;
					$UNIXtime =~ s/.//;

				}
			if ($_ =~ m/Lat/)
				{
					my @Lat = split(/=/,$_);
					my $Lat;
					$lat =   $Lat[1];
					chomp $lat;
				}
			if ($_ =~ m/Lon/)
				{
					my @Lon = split(/=/,$_);
					my $Lon;
					$lon =   $Lon[1];
					chomp $lon;
				}
			if ($_ =~ m/COG/)
				{
					my @COG = split(/=/,$_);
					$COG =   $COG[1];
					chomp $COG;
				}
			
				if ($_ =~ m/SOG/)
				{
					my @SOG = split(/=/,$_);
					$SOG =   $SOG[1];
					chomp $SOG;
				}	
			}
	
		close(GPS);


if ( $lat =~ m/-/)
        {
                $NS = "-";
        }
else {$NS = "+"};

$lat =~ s/-//;                                   # remove "-" in front
$lat = sprintf("%08.5f", $lat);
$lat =~ s/\.//;                                  # remove "period"
debug("Lat: $lat\n");

if ( $lon =~ m/-/)
        {
                $EW = "-";
        }
else {$EW = "+"};

$lon =~ s/-//;                                    # remove "-" in front
$lon = sprintf("%09.5f", $lon);
$lon =~ s/\.//;                                   # remove "period"
debug("Lon: $lon\n");


$SOG = $SOG * 10;
$SOG = sprintf("%03d", $SOG);
$COG = sprintf("%03d", $COG);
debug("SOG: $SOG\n");
debug("COG: $COG\n");	
	
## Get data from Barometic Pressure Archives		

my $presCurr = '/home/ubuntu/Data/pressure.dat';	
open PRESS, "$presCurr" or die $!;
my @presLines = <PRESS>;
my $presLines;
	
$barPres = pop@presLines;
chomp $barPres;

$barPres = $barPres * 10;
$barPres = sprintf("%05d", $barPres);

my $pres3h = $presLines[20] * 10;
$pres3h = sprintf("%05d", $pres3h);
$presChange3h = $barPres - $pres3h;
$presChange3h = sprintf("%03d", $presChange3h);

my $pres6h = $presLines[17] * 10;
$pres6h = sprintf("%05d", $pres6h);
$presChange6h = $barPres - $pres6h;
$presChange6h = sprintf("%03d", $presChange6h);

close(PRESS);	
debug("Barometric pressure: $barPres\n");
debug("PresChange3h: $presChange3h\n");	
debug("PresChange6h: $presChange6h\n");

## get temperatures

# CPU sensor:
my $sensorTempCPU ="10-0008026a7a2c";                # sensor ID

my $fileTempCPU = "\/sys\/bus\/w1\/devices/$sensorTempCPU\/w1_slave";

if ( -e $fileTempCPU)                                   # check if sensor is connected
        {
                $tempCPU =  W1Temp($sensorTempCPU);
                $tempCPU = sprintf("%.1f", $tempCPU);
             #   print "TempCPU is $tempCPU\n";
		$tempCPU = $tempCPU * 10;
		$tempCPU = sprintf("%03d", $tempCPU);

        }
else    {
                $tempCPU = "000";
              #  print "TempCPU not available\n";
        }
debug("tempCPU: $tempCPU\n");

# OUT sensor:
my $sensorTempOUT ="10-0008026a8f55";                # sensor ID

my $fileTempOUT = "\/sys\/bus\/w1\/devices/$sensorTempOUT\/w1_slave";

if ( -e $fileTempOUT)                                   # check if sensor is connected
        {
                $tempOUT =  W1Temp($sensorTempOUT);
                $tempOUT = sprintf("%.1f", $tempOUT);
               # print "TempOUT is $tempOUT\n";
		$tempOUT = $tempOUT * 10;
		$tempOUT = sprintf("%03d", $tempOUT);
        }
else    {
                $tempOUT = "000";
               # print "TempOUT not available\n";
        }
debug("tempOUT: $tempOUT\n");


## Temp Inside sensor:

my $sensorTempIN ="10-00";                # sensor ID

my $fileTempIN = "\/sys\/bus\/w1\/devices/$sensorTempIN\/w1_slave";

if ( -e $fileTempIN)                                   # check if sensor is connected
        {
                $tempIN =  W1Temp($sensorTempIN);
                $tempIN = sprintf("%.1f", $tempIN);
              #  print "TempIN is $tempIN\n";
		$tempIN = $tempIN * 10;
		$tempIN = sprintf("%03d", $tempIN);


        }
else    {
                $tempIN = "000";
              #  print "TempIN not available\n";
        }
debug("tempIN: $tempIN\n");

## Temp Engine sensor:

my $sensorTempENG ="10-00";                # sensor ID

my $fileTempENG = "\/sys\/bus\/w1\/devices/$sensorTempENG\/w1_slave";

if ( -e $fileTempENG)                                   # check if sensor is connected
        {
                $tempENG =  W1Temp($sensorTempENG);
                $tempENG = sprintf("%.1f", $tempENG);
              #  print "TempENG is $tempENG\n";
                $tempENG = $tempENG * 10;
                $tempENG = sprintf("%04d", $tempENG);


        }
else    {
                $tempENG = "0000";
             #   print "TempENG not available\n";
        }
debug("tempENG: $tempENG\n");



## Temp 2 sensor: 

my $sensorTemp2 ="10-00";                # sensor ID

my $fileTemp2 = "\/sys\/bus\/w1\/devices/$sensorTemp2\/w1_slave";

if ( -e $fileTemp2)                                   # check if sensor is connected
        {
                $temp2 =  W1Temp($sensorTemp2);
                $temp2 = sprintf("%.1f", $temp2);
              #  print "Temp2 is $temp2\n";
                $temp2 = $temp2 * 10;
                $temp2 = sprintf("%03d", $temp2);


        }
else    {
                $temp2 = "000";
             #   print "Temp2 not available\n";
        }

debug("temp2: $temp2\n");
## get volt1 reading 

$volt1 = getAIN($volt1AIN);
$volt1 = $volt1 * 10;
$volt1 = sprintf("%03d", $volt1);
debug("volt1: $volt1\n");

## get volt2 reading 
$volt2 = getAIN($volt2AIN);
$volt2 = $volt2 * 10;
$volt2 = sprintf("%03d", $volt2);
debug("volt2: $volt2\n");


## get volt3 reading
$volt3 = getAIN($volt3AIN);
$volt3 = $volt3 * 10;
$volt3 = sprintf("%03d", $volt3);
debug("volt3: $volt3\n");


## Get accelerometer data from accelerometerCur.dat


my $accelerometerCur = '/home/ubuntu/Data/accelerometerCur.dat';	
open ACC, "$accelerometerCur" or die $!;
my @accLines = <ACC>;		
	foreach(@accLines)
		{
					
			if ($_ =~ m/meanX=/)
				{
					my @meanX = split(/=/,$_);
					$meanX =   $meanX[1];
					$meanX = sprintf ("%04d", $meanX);
					chomp $meanX;
					debug ("meanX : $meanX\n");
				}
			if ($_ =~ m/sdX=/)
				{
					my @sdX = split(/=/,$_);
					$sdX =   $sdX[1];
					$sdX = sprintf ("%04d", $sdX);
					chomp $sdX;
					debug("sdX : $sdX\n");
				}	
			if ($_ =~ m/maxX=/)
				{
					my @maxX = split(/=/,$_);
					$maxX =   $maxX[1];
					$maxX = sprintf ("%04d", $maxX);
					chomp $maxX;
					debug("maxX : $maxX\n");
				}		
			if ($_ =~ m/minX=/)
				{
					my @minX = split(/=/,$_);
					$minX =   $minX[1];
					$minX = sprintf ("%04d", $minX);
					chomp $minX;
					debug("minX : $minX\n");
				}		
				
			if ($_ =~ m/meanY=/)
				{
					my @meanY = split(/=/,$_);
					$meanY =   $meanY[1];
					$meanY = sprintf ("%04d", $meanY);
					chomp $meanY;
					debug("meanY : $meanY\n");
				}
			if ($_ =~ m/sdY=/)
				{
					my @sdY = split(/=/,$_);
					$sdY =   $sdY[1];
					$sdY = sprintf ("%04d", $sdY);
					chomp $sdY;
					debug("sdY : $sdY\n");
				}	
			if ($_ =~ m/maxY=/)
				{
					my @maxY = split(/=/,$_);
					$maxY =   $maxY[1];
					$maxY = sprintf ("%04d", $maxY);
					chomp $maxY;
					debug("maxY : $maxY\n");
				}		
			if ($_ =~ m/minY=/)
				{
					my @minY = split(/=/,$_);
					$minY =   $minY[1];
					$minY = sprintf ("%04d", $minY);
					chomp $minY;
					debug("minY : $minY\n");
				}	
				
			if ($_ =~ m/meanZ=/)
				{
					my @meanZ = split(/=/,$_);
					$meanZ =   $meanZ[1];
					$meanZ = sprintf ("%04d", $meanZ);
					chomp $meanZ;
					debug("meanZ : $meanZ\n");
				}
			if ($_ =~ m/sdZ=/)
				{
					my @sdZ = split(/=/,$_);
					$sdZ =   $sdZ[1];
					$sdZ = sprintf ("%04d", $sdZ);
					chomp $sdZ;
					debug("sdZ : $sdZ\n");
				}	
			if ($_ =~ m/maxZ=/)
				{
					my @maxZ = split(/=/,$_);
					$maxZ =   $maxZ[1];
					$maxZ = sprintf ("%04d", $maxZ);
					chomp $maxZ;
					debug("maxZ : $maxZ\n");
				}		
			if ($_ =~ m/minZ=/)
				{
					my @minZ = split(/=/,$_);
					$minZ =   $minZ[1];
					$minZ = sprintf ("%04d", $minZ);
					chomp $minZ;
					debug("minZ : $minZ\n");
				}			
		}


## Get data from light sensor

$light = getAIN($lightSensor);
$light = sprintf("%02d", $light);
debug("Light :$light\n");


my $coded = "%"."$UNIXtime"."$NS"."$lat"."$EW"."$lon"."$COG"."$SOG"."$barPres"."$presChange3h"."$presChange6h"."$tempCPU"."$tempOUT"."$tempIN"."$tempENG"."$temp2"."$volt1"."$volt2".
"$volt3"."$meanX"."$sdX"."$meanY"."$sdY"."$meanZ"."$sdZ"."$light"."%";


my $codedLength =length($coded);


debug("\nNumber of bytes in coded message $codedLength\n\n");
return $coded;


sub debug 
	{	
		my $sentence = shift;
		if ($debug == 1)
			{
				print "$sentence";
			}
	}
}


# end coder messsage subroutine





sub decoderMainMessage {
	
	$coded = shift;
	my @array = split (//, $coded);
	my $array;
	my $UNIXtime = "1"."3"."$array[1]"."$array[2]"."$array[3]"."$array[4]"."$array[5]"."$array[6]"."$array[7]"."$array[8]";
	
	
	my $NS = $array[9];
	if ($NS eq "+")
		{
			$NS = "";
		}
		
	my $lat = "$NS"."$array[10]"."$array[11]"."."."$array[12]"."$array[13]"."$array[14]"."$array[15]"."$array[16]";
	
	my $EW = $array[17];
	
	if ($EW eq "+")
		{
			$EW = "";
		}
		
	my $lon = "$EW"."$array[18]"."$array[19]"."$array[20]"."."."$array[21]"."$array[22]"."$array[23]"."$array[24]"."$array[25]";
	
	my $COG = "$array[26]"."$array[27]"."$array[28]";
	my $SOG = "$array[29]"."$array[30]"."$array[31]";
	$SOG = $SOG /10;
	
	my $barPres = "$array[32]"."$array[33]"."$array[34]"."$array[35]"."$array[36]";
	$barPres = $barPres /10;
	
	
	my $presChange3h = "$array[37]"."$array[38]"."$array[39]";
	$presChange3h = $presChange3h /10;
	
	my $presChange6h = "$array[40]"."$array[41]"."$array[42]";
	$presChange6h = $presChange6h /10;
	
	
	
	my $tempCPU = "$array[43]"."$array[44]"."$array[45]";
	$tempCPU = $tempCPU /10;
	
	my $tempOUT = "$array[46]"."$array[47]"."$array[48]";
	$tempOUT = $tempOUT /10;
	
	my $tempIN = "$array[49]"."$array[50]"."$array[51]";
	$tempIN = $tempIN /10;
	
	my $tempENG = "$array[52]"."$array[53]"."$array[54]"."$array[55]";
	$tempENG = $tempENG /10;
	
	my $temp2 = "$array[56]"."$array[57]"."$array[58]";
	$temp2 = $temp2 /10;
	
	my $volt1 = "$array[59]"."$array[60]"."$array[61]";
	$volt1 = $volt1 /10;
	
	my $volt2 = "$array[62]"."$array[63]"."$array[64]";
	$volt2 = $volt2 /10;
	
	my $volt3 = "$array[65]"."$array[66]"."$array[67]";
	$volt3 = $volt3 /10;
	
	my $meanX = "$array[68]"."$array[69]"."$array[70]"."$array[71]";
	my $sdX = "$array[72]"."$array[73]"."$array[74]"."$array[75]";
	my $meanY = "$array[76]"."$array[77]"."$array[78]"."$array[79]";
	my $sdY = "$array[80]"."$array[81]"."$array[82]"."$array[83]";
	my $meanZ = "$array[84]"."$array[85]"."$array[86]"."$array[87]";
	my $sdZ = "$array[88]"."$array[89]"."$array[90]"."$array[91]";
	my $light = "$array[92]"."$array[93]";
	
	
	
	my %decoded = ( 'UNIXtime' => $UNIXtime,
					'NS' => $NS,
					'lat' => $lat,
					'EW' => $EW,
					'lon' => $lon,
					'SOG' => $SOG,
					'COG' => $COG,
					'barPres' => $barPres,
					'presChange3h' => $presChange3h,
					'presChange6h' => $presChange6h,
					'tempCPU' => $tempCPU,
					'tempOUT' => $tempOUT,
					'tempIN' => $tempIN,
					'tempENG' => $tempENG,
					'temp2' => $temp2,
					'volt1' => $volt1,
					'volt2' => $volt2,
					'volt3' => $volt3,
					'meanX' => $meanX,
					'sdX' => $sdX,
					'meanY' => $meanY,
					'sdY' => $sdY,
					'meanZ' => $meanZ,
					'sdZ' => $sdZ,
					'light' => $light
					
					); 
	
	return %decoded;
	
}



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

