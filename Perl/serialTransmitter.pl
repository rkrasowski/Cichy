#!/usr/bin/perl
use strict;
use warnings;
use Device::SerialPort;

## Set UART 2
# Set Tx pin

`echo 1 > /sys/kernel/debug/omap_mux/spi0_d0`;
print "UART2 Tx set done....PIN 21\n";

# set Rx pin
`echo 21 > /sys/kernel/debug/omap_mux/spi0_sclk`;
print "UART2 Rx set done......PIN 22\n";



# Activate serial connection:
my $PORT = "/dev/ttyO2";
my $serialData;

my $ob = Device::SerialPort->new($PORT) || die "Can't Open $PORT: $!";

$ob->baudrate(19200) || die "failed setting baudrate";
$ob->parity("none") || die "failed setting parity";
$ob->databits(8) || die "failed setting databits";
$ob->handshake("none") || die "failed setting handshake";
$ob->write_settings || die "no settings";
$| = 1;


while (1){
sleep(1);
my $count_out = $ob->write("Serial port test\n");
}

