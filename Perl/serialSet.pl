#!/usr/bin/perl
use warnings;
use strict;

################  serialSet.pl ##########################
#							#
#	Set UART2 for serial communication 		#
#	by Robert J Krasowski				#
#							#
#########################################################


## Set UART 1 
# Set Tx pin
`echo 0 > /sys/kernel/debug/omap_mux/uart1_txd`;
print "UART1 Tx set done....PIN 24\n";

# Set Rx pin
`echo 20 > /sys/kernel/debug/omap_mux/uart1_rxd`;
print "UART1 Rx set done....PIN 26 \n";



## Set UART 2
# Set Tx pin

`echo 1 > /sys/kernel/debug/omap_mux/spi0_d0`;
print "UART2 Tx set done....PIN 21\n";

# set Rx pin
`echo 21 > /sys/kernel/debug/omap_mux/spi0_sclk`;
print "UART2 Rx set done......PIN 22\n";

