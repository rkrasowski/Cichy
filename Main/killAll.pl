#!/usr/bin/perl
use warnings;
use strict;



killProcess('gpsReader.pl');

killProcess('communicatorDeamon.pl');

killProcess('accData.pl');

sub killProcess 
	{
		my $process = shift;
		my $PID = `pgrep -f $process`;
		print "\nPID of $process is $PID";
		`kill $PID`;
		print "$process is killed\n";
	}

