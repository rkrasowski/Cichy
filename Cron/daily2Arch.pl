#!/usr/bin/perl
use strict;
use warnings;

##############################  ###############


 my ($sec,$min,$hour,$mday,$mon,$year,
          $wday,$yday,$isdst) = gmtime time;
$mon = $mon +1;
$year = $year + 1900;

my $fileName = $hour.":".$min."_".$mday."_".$mon."_".$year."."."bz2";

`bzip2 /home/ubuntu/Archives/daily.arch`;
`cp /home/ubuntu/Archives/daily.arch.bz2 /home/ubuntu/CompressArchives/$fileName`;
`rm /home/ubuntu/Archives/daily.arch.bz2`;

