#!/usr/bin/perl
use strict;
use Tk;

my $mw = MainWindow->new;
# Mainwindow: sizex/y, positionx/y
$mw->geometry("800x480+0+0");
$mw->title("!!! S.O.S. !!!!");


my $font_code = $mw->fontCreate( -family => 'curier',
								-size => 24,
								-weight => 'bold');



my $exit = $mw->Button(-text => "Wroc", 
						-font => $font_code,
						-command => sub { exit });

$exit -> grid(-row=>3,-column=>3,-sticky => "nsew", -ipadx => 100, -ipady => 15,-padx => 10, -pady => 3);

MainLoop;
