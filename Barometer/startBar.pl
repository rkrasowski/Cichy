#!/usr/bin/perl 
use strict;
use warnings;

`echo bmp085 0x77 > /sys/class/i2c-adapter/i2c-3/new_device`;
