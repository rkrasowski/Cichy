#!/usr/bin/perl 
use strict;
use warnings;

print "Before system function\n";

system("/home/ubuntu/LED/3blinks.pl &");

print "Post system\n\n";
