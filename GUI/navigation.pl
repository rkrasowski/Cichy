#!/usr/bin/perl

use Tk;

#my $start = `/home/robert/TelemetryBox/serialXBeeGOOD.pl`;

my $mw = new MainWindow; # Main Window
$mw->geometry("800x480+0+0");
$mw->title("Navigation data");
$mw->optionAdd('*font', 'Helvetica -20 ');


my $font_code = $mw->fontCreate( -family => 'curier',
								-size => 24,
								-weight => 'bold');
								
my $font_code_values = $mw->fontCreate( -family => 'curier',
								-size => 26,
								-weight => 'bold');							





# Values of variables

my $time;
my $date;
my $lat;
my $lon;
my $speed;
my $course;
my $temperature;
my $pressure;
my $tilt;
my $battery;


# Color of background

my $colorTime = "grey";
my $colorDate = "grey";
my $colorLat = "green";
my $colorLon = "green";
my $colorSpeed = "grey";
my $colorCourse = "grey";
my $colorTemperature = "grey";
my $colorPressure = "grey";
my $colorTilt = "grey";
my $colorBattery = "grey";

# Bacground changing 

my @colorGray = qw/gray gray/;
my @colorRed = qw/red gray/;
my @colorYellow = qw/yellow gray/;
my @colorRedBat = qw/red gray/;




# Labels that are not changing 

my $Titulus = $mw -> Label(-text=>"Aktualne dane:", -font => $font_code);

my $Date = $mw -> Label(-text=>"Data:", -font => $font_code,-width=>15,-anchor =>'e');
my $Time = $mw -> Label(-text=>"Godzina:", -font => $font_code,-width=>15,-anchor =>'e');
my $Lat = $mw -> Label(-text=>"Szerokosc:", -font => $font_code,-width=>15,-anchor =>'e');
my $Lon = $mw -> Label(-text=>"Dlugosc:", -font => $font_code,-width=>15,-anchor =>'e');
my $Speed = $mw -> Label(-text=>"Predkosc:", -font => $font_code,-width=>15,-anchor =>'e');
my $Course = $mw -> Label(-text=>"Kurs:", -font => $font_code,-width=>15,-anchor =>'e');

my $exit = $mw->Button(-text => "Wroc", -font => $font_code, -command => sub { exit });


# Labels that are changing 

my $DateValue = $mw -> Label(-textvariable => \$date, -font => $font_code_values,-background => $colorDate, -width=>15, -justify => 'left',-anchor =>'w');
my $TimeValue = $mw -> Label(-textvariable => \$time, -font => $font_code_values,-background => $colorTime, -width=>15,  -justify => 'left',-anchor =>'w');
my $LatValue = $mw -> Label(-textvariable => \$lat, -font => $font_code_values,-background => $colorLat, -width=>15, -justify => 'left',-anchor =>'w');
my $LonValue = $mw -> Label(-textvariable => \$lon, -font => $font_code_values,-background => $colorLon, -width=>15, -justify => 'left',-anchor =>'w');
my $SpeedValue = $mw -> Label(-textvariable => \$speed, -font => $font_code_values,-background => $colorSpeed, -width=>15, -justify => 'left',-anchor =>'w');
my $CourseValue = $mw -> Label(-textvariable => \$course, -font => $font_code_values,-background => $colorCourse, -width=>15, -justify => 'left',-anchor =>'w');






my $txt = $mw -> Text(-width=>30, -height=>5);


#Geometry Management

$Titulus -> grid(-row=>1,-column=>1);

$Date -> grid(-row=>2,-column=>1);
$Time -> grid(-row=>3,-column=>1);
$Lat -> grid(-row=>4,-column=>1);
$Lon -> grid(-row=>5,-column=>1);
$Speed -> grid(-row=>6,-column=>1);
$Course -> grid(-row=>7,-column=>1);

$exit -> grid(-row=>12,-column=>2,-sticky => "nsew", -ipadx => 90, -ipady => 15,-padx => 10, -pady => 20);




$DateValue -> grid(-row=>2,-column=>2);
$TimeValue -> grid(-row=>3,-column=>2);
$LatValue -> grid(-row=>4,-column=>2);
$LonValue -> grid(-row=>5,-column=>2);
$SpeedValue -> grid(-row=>6,-column=>2);
$CourseValue -> grid(-row=>7,-column=>2);




$mw->repeat(1000, sub{ $date = getDate(); } );
$mw->repeat(1000, sub{ $time = getTime(); } );
$mw->repeat(1000, sub{ $lat = getLat(); } );
$mw->repeat(1000, sub{ $lon = getLon(); } );
$mw->repeat(1000, sub{ $speed = getSpeed(); } );
$mw->repeat(1000, sub{ $course = getCourse(); } );


MainLoop;

################################  Subroutines ###########################

sub getDate{

open FH, "/home/ubuntu/Data/gps.dat" or die $!;

while (my $line = <FH>) 
	{
		if ($line=~/Date/) 
			{
		
				my @word = split ("=",$line);
				$line = $word[1];
				chomp $line;
				return $line;
			}	
	}
close(FH);
}


sub getTime{

open FH, "/home/ubuntu/Data/gps.dat" or die $!;

while (my $line = <FH>) 
	{
		if ($line=~/Time/) 
			{
		
				my @word = split ("=",$line);
				$line = $word[1];
				chomp $line;
				return $line;
			}	
	}
close(FH);
}




sub getLat{

open FH, "/home/ubuntu/Data/gps.dat" or die $!;

while (my $line = <FH>) 
	{
		if ($line=~/Lat/) 
			{
		
				my @word = split ("=",$line);
				$line = $word[1];
				chomp $line;
				$line = "$line"." Deg";
				chomp $line;
				return $line;
			}	
	}
close FH;
}

sub getLon{

open FH, "/home/ubuntu/Data/gps.dat" or die $!;

while (my $line = <FH>) 
	{
		if ($line=~/Lon/) 
			{
		
				my @word = split ("=",$line);
				$line = $word[1];
				chomp $line;
				$line = "$line"." Deg";
				chomp $line;
				return $line;
			}	
	}
close FH;
}



sub getSpeed{

open FH, "/home/ubuntu/Data/gps.dat" or die $!;

while (my $line = <FH>) 
	{
		if ($line=~/SOG/) 
			{
		
				my @word = split ("=",$line);
				$line = $word[1];
				chomp $line;
				$line = "$line"." kts";
				chomp $line;
				return $line;
			}	
	}
close FH;
}

sub getCourse{

open FH, "/home/ubuntu/Data/gps.dat" or die $!;

while (my $line = <FH>) 
	{
		if ($line=~/COG/) 
			{
		
				my @word = split ("=",$line);
				$line = $word[1];
				chomp $line;
				$line = "$line"." Deg";
				chomp $line;
				return $line;
			}	
	}
close FH;
}



sub logicSpeed {
	my $tt = getSpeed();
	if ($tt <5){ 
		labelConfigSpeedGray();
	}
	if ($tt >=5){
		labelConfigSpeedRed();
	}
}

sub labelConfigSpeedGray {$SpeedValue->configure(-bg=>$colorGray[0]);
                               @colorGray=reverse(@colorGray);
                               ;}

sub labelConfigSpeedRed {$SpeedValue->configure(-bg=>$colorRed[0]);
                               @colorRed=reverse(@colorRed);
                               ;}





sub logicBattery {
	my $tt = getBat();
	if ($tt >=7){ 
		labelConfigBatteryGray();
	}
	
	
	
	if (($tt <7) && ($tt > 5)) {
		labelConfigBatteryYellow();
	}
	
	
	if ($tt <= 5){
		labelConfigBatteryRed();
	}
}



sub labelConfigBatteryGray {$BatteryValue->configure(-bg=>$colorGray[0]);
                               @colorGray=reverse(@colorGray);
                               ;}
sub labelConfigBatteryYellow {$BatteryValue->configure(-bg=>$colorYellow[0]);
                               @colorYellow=reverse(@colorYellow);
                               ;}                               
                               
sub labelConfigBatteryRed {$BatteryValue->configure(-bg=>$colorRedBat[0]);
                               @colorRedBat =reverse(@colorRedBat);
                               ;}                                  
                               
                               



