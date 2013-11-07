#!/usr/bin/perl
use strict;
use Tk;
#use Astro::Sunrise;

my $mw = MainWindow->new;
# Mainwindow: sizex/y, positionx/y
$mw->geometry("800x480+0+0");
$mw->title("Time data");


my $font_code = $mw->fontCreate( -family => 'curier',
								-size => 22,
								-weight => 'bold');
								
								
my $font_code_values = $mw->fontCreate( -family => 'curier',
								-size => 20,
								-weight => 'bold');								
								

################ Labels not changing
my $UTC = $mw -> Label(-text=>"UTC:", -font => $font_code,-width=>18,-anchor =>'e');
my $polski = $mw -> Label(-text=>"Czas polski:", -font => $font_code,-width=>18,-anchor =>'e');
my $local = $mw -> Label(-text=>"Czas lokalny:", -font => $font_code,-width=>18,-anchor =>'e');
my $sunrise = $mw -> Label(-text=>"Wschod slonca:", -font => $font_code,-width=>18,-anchor =>'e');
my $sunset = $mw -> Label(-text=>"Zachod slonca:", -font => $font_code,-width=>18,-anchor =>'e');
my $time2Sunrise = $mw -> Label(-text=>"Czas do wschodu:", -font => $font_code,-width=>18,-anchor =>'e');
my $time2Sunset = $mw -> Label(-text=>"Czas do zachodu:", -font => $font_code,-width=>18,-anchor =>'e');
my $totalTime = $mw -> Label(-text=>"Czas od startu:", -font => $font_code,-width=>18,-anchor =>'e');
my $time2Go = $mw -> Label(-text=>"Czas do mety:", -font => $font_code,-width=>18,-anchor =>'e');


################ Labels that change

my $UTCReal;
my $polskiReal = "12:34:54";
my $localReal;
my $sunriseReal;
my $sunsetReal;
my $time2SunriseReal;
my $time2SunsetReal;
my $totalReal;
my $time2goReal;

my $colorUTC;
my $colorPolski;
my $colorLocal;
my $colorSunrise;
my $colorSunset;
my $colorTime2Sunrise;
my $colorTime2Sunset;
my $colorTotal;
my $colorTime2go;

my $UTCValue =$mw -> Label(-textvariable=>\$UTCReal, -font => $font_code_values,-width=>26, -background=> 'red', -anchor =>'w');
#my $polskiValue = $mw -> Label(-textvariable => \$polskiReal, -font => $font_code_values,-background => $colorPolski, -width=>15,  -justify => 'left',-anchor =>'w');
my $localValue =$mw -> Label(-textvariable=>\$localReal, -font => $font_code_values,-width=>26, -background=> 'green', -anchor =>'w');
#my $sunriseValue = $mw -> Label(-textvariable => \$sunriseReal, -font => $font_code_values,-background => $colorSunrise, -width=>15, -justify => 'left',-anchor =>'w');
#my $sunsetValue = $mw -> Label(-textvariable => \$sunsetReal, -font => $font_code_values,-background => $colorSunset, -width=>15, -justify => 'left',-anchor =>'w');
#my $time2SunriseValue = $mw -> Label(-textvariable => \$time2SunriseReal, -font => $font_code_values,-background => $colorTime2Sunrise, -width=>15, -justify => 'left',-anchor =>'w');
#my $time2SunsetValue = $mw -> Label(-textvariable => \$time2SunsetReal, -font => $font_code_values,-background => $colorTime2Sunset, -width=>15, -justify => 'left',-anchor =>'w');
#my $totalValue = $mw -> Label(-textvariable => \$totalReal, -font => $font_code_values,-background => $colorTotal, -width=>15,  -justify => 'left',-anchor =>'w');
#my $time2goValue = $mw -> Label(-textvariable => \$time2goReal, -font => $font_code_values,-background => $colorTime2go, -width=>15, -justify => 'left',-anchor =>'w');


my $exit = $mw->Button(-text => "Wroc", 
						-font => $font_code,
						-command => sub { exit });
						
						
						
						
$UTC -> grid(-row=>2,-column=>1);
$polski -> grid(-row=>3,-column=>1);
$local -> grid(-row=>4,-column=>1);
$sunrise -> grid(-row=>5,-column=>1);
$sunset -> grid(-row=>6,-column=>1);
$time2Sunrise -> grid(-row=>7,-column=>1);
$time2Sunset -> grid(-row=>8,-column=>1);
$totalTime -> grid(-row=>9,-column=>1);
$time2Go -> grid(-row=>10,-column=>1);	







$UTCValue -> grid(-row=>2,-column=>2);
#$polskiValue -> grid(-row=>3,-column=>1);
$localValue -> grid(-row=>4,-column=>2);
#$sunriseValue -> grid(-row=>5,-column=>1);
#$sunsetValue -> grid(-row=>6,-column=>1);
#$time2SunriseValue -> grid(-row=>7,-column=>1);
#$time2SunsetValue -> grid(-row=>8,-column=>1);
#$totalTimeValue -> grid(-row=>9,-column=>1);
#$time2GoValue -> grid(-row=>10,-column=>1);

$exit -> grid(-row=>11,-column=>2,-sticky => "nsew", -ipadx => 100, -ipady => 15,-padx => 10, -pady => 3);


$mw->repeat(1000, sub{ $UTCReal = getUTC(); } );
$mw->repeat(1000, sub{ $localReal = getLocal(); } );

MainLoop;


sub getUTC {
	
my $UTC = gmtime();
return $UTC;
}

sub getLocal {
	
my $local = localtime();
return $local;
}

sub getSunrise {
	
}

sub getSunset {
	
}

