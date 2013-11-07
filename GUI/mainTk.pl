#!/usr/bin/perl
use strict;
use Tk;

my $mw = MainWindow->new;
# Mainwindow: sizex/y, positionx/y
$mw->geometry("800x480+0+0");
$mw->title("Sailing management software");
#$mw->overrideredirect(1);		# Hide windows decorations

my $font_code = $mw->fontCreate( -family => 'curier',
								-size => 24,
								-weight => 'bold');


my $butNav = $mw -> Button(-text => "Navigation",
		-padx => 10,
		-font => $font_code,
		-command =>\&push_Nav);
		
my $butMeteo = $mw -> Button(-text => "Meteo ",
		-padx => 10,
		-font => $font_code,
		-command =>\&push_Meteo);
				
my $butTime = $mw -> Button(-text => "Czasy",
		-padx => 10,
		-font => $font_code,
		-command =>\&push_Time);
		
my $butMessage = $mw -> Button(-text => "Wiadomosci",
		#-padx => 10,
		-font => $font_code,
		-command =>\&push_Message);		
						
my $butAlarm = $mw -> Button(-text => "S.O.S.", 
		-background => "red",
		#-padx => 10,
		-font => $font_code,
		-command =>\&push_SOS);		
		


$butNav -> grid(-row=>1,-column=>0,-sticky => "nsew", -ipadx => 220, -ipady => 15,-padx => 10, -pady => 3);
$butMeteo -> grid(-row=>2,-column=>0,-sticky => "nsew", -ipadx => 90, -ipady => 15, -padx => 10, -pady => 3);
$butTime -> grid(-row=>3,-column=>0,-sticky => "nsew", -ipadx => 90, -ipady => 15, -padx => 10, -pady => 3);
$butMessage -> grid(-row=>4,-column=>0,-sticky => "nsew", -ipadx => 90, -ipady => 15, -padx => 10, -pady => 3);
$butAlarm -> grid(-row=>5,-column=>0,-sticky => "nsew", -ipadx => 90, -ipady => 15, -padx => 10, -pady => 3);



MainLoop;


#This is executed when the button is pressed 
sub push_Nav {
	
	`/home/ubuntu/GUI/navigation.pl`;
	print "Navigation pressed\n";
	
	
}
sub push_Meteo {
	
	`/home/ubuntu/GUI/meteo.pl`;
	print "Meteo pressed\n";
}
sub push_Time {
	`/home/ubuntu/GUI/time.pl`;
	print "Time pressed\n";
}
sub push_Message {
	`/home/ubuntu/GUI/message.pl`;
	print "Message pressed\n";
}
sub push_SOS {
	`/home/ubuntu/GUI/sos.pl`;
	print "SOS pressed\n";
}

