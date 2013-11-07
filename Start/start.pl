#!/usr/bin/perl
use warnings;
use strict;



`echo 72 > /sys/class/gpio/export`;                             # yellow LED
`echo 70 > /sys/class/gpio/export`;                             # red LED
`echo 74 > /sys/class/gpio/export`;				# buzzer

`echo 20 > /sys/kernel/debug/omap_mux/uart1_rxd`;               # RX pin for GPS
`echo bmp085 0x77 > /sys/class/i2c-adapter/i2c-3/new_device`;   # I2C for Barometer
`sudo modprobe ti_tscadc`;                                      # AIN on Ubuntu

print "\n\nStarting......\nPins are set ........\n";
###################################################
## 3 blinks all LEDs

my $i;

for ($i=0;$i<5;$i++)
        {

                # to turn it on
                `echo "high" > /sys/class/gpio/gpio72/direction`;
                `echo "high" > /sys/class/gpio/gpio70/direction`;
                `echo "high" > /sys/class/gpio/gpio74/direction`;

                select(undef,undef,undef,0.15);

                # to turn it off:
                `echo "low" > /sys/class/gpio/gpio72/direction`;
                `echo "low" > /sys/class/gpio/gpio70/direction`;
                `echo "low" > /sys/class/gpio/gpio74/direction`;

                select(undef,undef,undef,0.15);
        }

         
