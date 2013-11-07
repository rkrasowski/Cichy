#!/usr/bin/perl
use strict;
use warnings;



print "before external commands\n";

my $pid = fork();

# if this is the parent, just exit
if ($pid) {
   exit 0;
}
# otherwise this is the child, run the other process
else {
   system("/home/ubuntu/GPS/gpsReader.pl");
   print STDERR "shouldn't be here, there was an error: $!";
}


print "after external commands\n";

exit();




my $value = SFQRetrieve();

print "Before: $value pa\n";


$value =~  s/\r\n//;
#chomp $value;

print "After: $value pa\n";




################################################################






sub SFQRetrieve 
	{		
		
		my $file = '/home/ubuntu/Config/config.txt';	
		open INFO, "$file" or die $!;
		my @lines = <INFO>;	
		my $lines;
		
		foreach(@lines)
			{
					
					if ($_ =~ m/SFQ/)
						{
							my @frq = split(/=/,$_);
							my $frq;
							return  $frq[1];
						}
			}
		
		close(INFO);
	}
