#!/usr/bin/perl
use warnings;
use strict;



my $rcvCommand = "%?SST";



	if ($rcvCommand =~ m/%?SMN/i)
		{
			SMN();
		}


	if ($rcvCommand =~ /%?SFQ/i)
		{
			my @frq = split ('Q',$rcvCommand);
			my $frq;
			SFQ($frq[1]);
		}	

	if ($rcvCommand =~ m/%?GPS/i)
		{
			GPS();
		}

	if ($rcvCommand =~ /%?BTQ/i)
		{
			my @frq = split ('Q',$rcvCommand);
			my $frq;
			BTQ($frq[1]);
		}
	if ($rcvCommand =~ /%?LTQ/i)
		{
			my @frq = split ('Q',$rcvCommand);
			my $frq;
			LTQ($frq[1]);
		}

	if ($rcvCommand =~ /%?AAD/i)
		{
			my @dis = split ('=',$rcvCommand);
			my $dis;
			ANCHORALARM($dis[1]);
		}



	if ($rcvCommand =~ /%?ME/i)
		{
			my $rcvMessage = substr($rcvCommand,4);
			rcvMessage($rcvMessage);
			
		}
	
	
	
	if ($rcvCommand =~ m/%?CON/i)
		{
			CONTACT();
		}
	
	

	  
	if ($rcvCommand =~ m/%?SCH/i)
		{
			sysCheck();
		}
	
	
	if ($rcvCommand =~ m/%?REBOOT/i)
		{
			REBOOT();
		}


	if ($rcvCommand =~ m/%?FMEM/i)
		{
			FMEM();
		}
	
	if ($rcvCommand =~ m/%?ALARM/i)
		{
			ALARM();
		}
	
	
	if ($rcvCommand =~ m/%?SST/i)
		{
			sysTIME();
		}
	
	
	
######################## Subroutines ########################



sub SMN {
	print "Sending standart message now \n";
}

sub SFQ {
	my $frq = shift;
	
	print "Will send message q $frq h\n";
}

sub GPS {
			print "Sending GPS data now\n";
}

sub BTQ {
	my $frq = shift;
	
	print "Will send barometers data q $frq h\n";
}

sub LTQ {
	my $frq = shift;
	 
	print "Will send light  data q $frq h\n";
}




sub REBOOT {
	print "Rebooting now !!\n";
}


sub FMEM {
	print "Checking free memory  !!\n";
	my $memory;
		{
			local(*PS, $/);
			open(PS,"free -t -m |");
			$memory = <PS>;
		}

my @arrMemory = split (/\n/,$memory);
my $arrMemory;

my @freeMemory = split (/ /,$arrMemory[4]);

my $freememory;
my $totMem = $freeMemory[9];
my $usedMem = $freeMemory[18];
my $freeMem = $freeMemory[26];


print "Total mem: $totMem\nUsed memory: $usedMem\nFree mem: $freeMem\n\n"; 
}

sub ALARM {
	print "Alarm !!\n";
}


sub rcvMessage 
		{
			my $rcvMessage = shift;
			print "Received message: $rcvMessage\n";
			 }

sub sysCheck 

	{
		print "Runing system check\n";
	}

sub sysTIME 
	{
		my $time = gmtime();
		print "System time is $time\n";
	}


sub CONTACT 
	{
		print "Contact request received\n";
	}


sub ANCHORALARM 
	{
		my $dis = shift;
		print "Setting anchor alarm on $dis m\n";
	}

