#!/usr/bin/perl

################################## modemTest.pl #########################
#									#
#	Check communication with iridium modem over serial connection 	#
#	by Robert J. Krasowski						#
#	3/16/2013							#
#									#
#########################################################################


use strict;
use warnings;
use Device::SerialPort;

# set pins in appropriate modes:
# Set UART 1
# Set Tx pin
`echo 1 > /sys/kernel/debug/omap_mux/spi0_d0`;
print "\nUART2 Tx set to....PIN 21\n";

# set Rx pin
`echo 21 > /sys/kernel/debug/omap_mux/spi0_sclk`;
print "UART2 Rx set to......PIN 22\n";



# Activate serial connection:
my $PORT = "/dev/ttyO2";
my $serialData;
my $tx;
my $rx;
my $i;

my $sigStrenght;
my $network;
my $MO;
my $MOMSN;
my $MT;
my $MTMSN;
my $registration;
my $inMessage= "";

my $ob = Device::SerialPort->new($PORT) || die "Can't Open $PORT: $!";

$ob->baudrate(19200) || die "failed setting baudrate";
$ob->parity("none") || die "failed setting parity";
$ob->databits(8) || die "failed setting databits";
$ob->handshake("none") || die "failed setting handshake";
$ob->write_settings || die "no settings";
$| = 1;


print "\nSerial port is open, communicationg with modem ....\n";

# Check if modem is on line:



#checkModem();
#registrationNotification();
checkBuffer();
#message2Buffer();

#signalNetwork();

print "Will read now\n\n";
#exchangeSatellite();
#print "Checking buffer after exchange with satellite\n";

#checkBuffer();
readBuffer();
#print "Checking buffer after reading the message, should be empty\n";
#checkBuffer();
#checkBuffer();
#message2Buffer();

#listen4Ring();
#echoOFF();
#test();

#checkBuffer();
#clearBufffer();
#setModem();
#storedConfig();
#timeClock();
#signalQuality();

print "\n\nINMESSAGE : $inMessage\n\n";
############################################## Subroutines #####################################################


sub checkModem{

$i =1;

while ($i < 6)
        {
                        
	      	$ob->write("AT\r");
		print "Checking if modem in accesable ....trial $i\n";
		$i++;
		sleep(1);
                       
                       
               	$rx = $ob->read(255);
                if ($rx =~ m/OK/)
                   	{
                            goto READY;
                        }
                       
        }
         print "Can not find Iridium 9602 !!!!!\n";
         exit();

READY:{print "Iiridium 9602 identyfied and ready to work....\n\n";}
}





sub signalNetwork{


                $ob->write("AT+CIER=1,1,1,0\r");
                print "Checking network and signal strenght\n";
		do 
			{
                		sleep(1);
                		$rx = $ob->read(255);
				
				if ($rx)
					{
						



						if ($rx =~ m/CIEV:1/)
                                        		{
                                               			 print "\nNetwork available\n\n";
                                                		my @array = split(':',$rx);
                                                		my $array;
                                                		@array = split(',',$array[1]);
								$network = substr($array[1], 0, 1);
                                                 		if ($network  == 1)
									{
										print "Network available\n";
									}
                                        		}	



						if  ($rx =~ m/CIEV:0/)
 		                                       {
                                               
                           		                     	my @array2 = split(':',$rx);
                                        		     	my $array2;
                                            			    #print $array[1];
                                                		@array2 = split(',',$array2[1]);
                                                		$sigStrenght = substr( $array2[1],0,1);
                                                		print "Sig streght = $sigStrenght\n";
                                               
                                        		}
				

					}
				
			}
				until ($sigStrenght >2);
				print "Ready to send message\n";
       
}



sub registrationNotification 
	{
	BEGININGREG:	$ob->write("AT+SBDREG?\r");
			print "Checking registratin\n";
		sleep(1);

		$rx = $ob->read(255);

		if ($rx =~ m/SBDREG/)
			{	
				my @array = split(':',$rx);
				my $array;
				$registration = $array[1];
				$registration = substr( $registration,0,1);
				if ($registration == 0)
					{
						$ob->write("AT+SBDREG\r");
						print "Will register again\n";
						sleep(1);
						$rx = $ob->read(255);
						if ($rx =~ m/OK/)
							{	
								goto BEGININGREG;	
							}
					}

			}

		print "Registration done : $registration\n";

		$ob->write("AT+SBDMTA=1\r");
		sleep(1);
		$rx = $ob->read(255);
                 if ($rx =~ m/OK/)
            	        {
                             print "Notification enabled\n";
                   	}


	}



sub checkBuffer
	{
		$ob->write("AT+SBDS\r");
		sleep(1);
		$rx = $ob->read(255);
                if ($rx =~ m/SBDS:/)
                       	{
                                                
                          	my @array = split(':',$rx);
                           	my $array;
                           	my $Part2 = $array[1];
                           	my @array2 = split(',',$Part2);
                           	my $array2;
                                $MO = $array2[0];     	# Mobile originated message 0 - no, 1 - yes
                             	$MOMSN = $array2[1];		# Mobile originated message sequence number
                                $MT = $array2[2];		# Terminal originated message 
                                $MTMSN = $array2[3];		# Terminal originated message sequence number
                                               
            		}
                                        
                                        
print "MO: $MO\nMOMSN: $MOMSN\nMT: $MT\nMTMSN: $MTMSN\n\n";


	}



sub message2Buffer {

                $ob->write("012345678901234567890123456789012345678901234567890\r");
               
             
                sleep(1);


                $rx = $ob->read(255);
                print $rx;
                if ($rx =~ m/OK/)
                        {
                            print "Message in buffer\n";

			}

}

sub readBuffer {

			$ob->write("AT+SBDRT\r");
			print "Reading Buffer\n\n";
			sleep(1);
			$rx = $ob->read(255);	
			my @array = split(':',$rx);
			my $array;
			$rx = $array[1];

			$rx =~ s/^\s+//; #remove leading spaces
			$rx =~ s/\s+$//; #remove trailing spaces


			my $okRead = substr($rx, -2);
			
			$inMessage = substr($rx, 0, -2);
				
}


sub exchangeSatellite{

#this one cost money
print "Exchanging messages\n";
$ob->write("AT+SBDIXA\r");
while(1){
$rx = $ob->read(255);
print $rx;}
}



sub clearBufffer{
$ob->write("AT+SBDD0\r");
sleep(1);
$rx = $ob->read(255);
print $rx;

}

sub setModem{

$ob->write("AT&K0\r");
do 
	{
		 $rx = $ob->read(255);
		print $rx;
	}
	until ($rx =~ m/OK/);

	print "Flow disable\n";

$ob->write("AT\*R1\r");

do
        {
                 $rx = $ob->read(255);
                print $rx;
        }
        until ($rx =~ m/OK/);

        print "Radio enabled\n";


$ob->write("AT+SBDMTA=1\r");

do
        {
                 $rx = $ob->read(255);
                print $rx;
        }
        until ($rx =~ m/OK/);

        print "\nEnabled SBD ring indicators\n";


$ob->write("AT&W0\r");

do
        {
                 $rx = $ob->read(255);
                print $rx;
        }
        until ($rx =~ m/OK/);

        print "\nStore configuration as profile 0\n";


$ob->write("AT&Y0\r");

do
        {
                 $rx = $ob->read(255);
                print $rx;
        }
        until ($rx =~ m/OK/);

        print "\nSelecte profile 0 as the power-up default\n\n###########################################################\n";


}


sub storedConfig {

$ob->write("AT&V\r");

do
        {
                 $rx = $ob->read(255);
                print $rx;
        }
        until ($rx =~ m/OK/);

        print "\nDone\n";


}



sub echoOFF {

$ob->write("ATEn\r");

sleep(1);
        
                 $rx = $ob->read(255);
                print $rx;
        
        

        print "\nEcho should be off \n";

}

sub test {
$ob->write("AT+SBDRT\r");

sleep(1);
       
$rx = $ob->read(255);
	

			
				
print"$rx\n";
                	
        
        

}


sub listen4Ring {

		while(1)
			{
				sleep(1);
				$rx = $ob->read(255);
				print $rx;
				if ($rx =~ m/SBDRING/)
					{	
						print "\n\nRing received\n\n";
					}
			}

}
