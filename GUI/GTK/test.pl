#!/usr/bin/perl 

use Glib qw/TRUE FALSE/;
use Gtk2 '-init';

# Our callback.
# The data passed to this function is printed to stdout
sub callback
{
	my ($widget, $data) = @_;
	print "Hello again - $data was pressed\n";
}

sub openNew 
{
`./testWindow.pl`;	
}


# This callback quits the program
sub delete_event
{
	Gtk2->main_quit;
	return FALSE;
}


# Create a new window
$window = Gtk2::Window->new('toplevel');

# Set the window title
$window->set_title("Boat menagement system");

# Set size of the window
$window->set_size_request(800,480);


# Set a handler for delete_event that immediately exits GTK.
$window->signal_connect(delete_event => \&delete_event);

# Sets the border width of the window.
$window->set_border_width(20);

# Create a 3x0 table
$table = Gtk2::Table->new(5, 0, TRUE);

# Put the table in the main window
$window->add($table);

# Create first button
$button = Gtk2::Button->new("Navigation data");
$button->set_border_width(10);

# When the button is clicked, we call the "callback" function
# with the string "button 1" as its argument
$button->signal_connect(clicked => \&callback, 'Navigation data');

# Insert button 1 into the upper left quadrant of the table
$table->attach_defaults($button, 0, 1, 0, 1);

$button->show;

# Create second button
$button = Gtk2::Button->new("Clocks");

$button->set_border_width(10);

# When the button is clicked, we call the "callback" function
# with the string "button 2" as its argument
$button->signal_connect(clicked => \&callback, 'Clock');

# Insert button 2 into the upper right quadrant of the table
$table->attach_defaults($button, 0, 1, 1, 2);

$button->show;

# Create "Meteorological Data" button
$button = Gtk2::Button->new("Meteorological data");
$button->set_border_width(10);
$button->signal_connect(clicked => \&openNew, 'Meteo data');
$table->attach_defaults($button, 0, 1, 2, 3);
$button->show;


# Create "SOS" button
$button = Gtk2::Button->new("S.O.S");
$button->set_border_width(10);
$button->modify_fg(normal => Gtk2::Gdk::Color->new(0xffff, 0, 0));



$button->signal_connect(clicked => \&callback, 'SOS');
$table->attach_defaults($button, 0, 1, 3, 4);
$button->show;


# Create "Quit" button
$button = Gtk2::Button->new("Quit");
$button->set_border_width(10);
$button->signal_connect(clicked => \&delete_event);
$table->attach_defaults($button, 0, 1, 4, 5);
$button->show;





$table->show;
$window->show;

Gtk2->main;

0;


