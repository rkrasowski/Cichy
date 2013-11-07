#! /usr/bin/perl -w

use strict;
use Gtk2 '-init';
use Glib qw/TRUE FALSE/; 
 
#standard window creation, placement, and signal connecting
my $window = Gtk2::Window->new('toplevel');
$window->signal_connect('delete_event' => sub { Gtk2->main_quit; });
$window->set_border_width(5);
$window->set_position('center_always');

#this vbox will geturn the bulk of the gui
my $vbox = &ret_vbox();

#add and show the vbox
$window->add($vbox);
$window->show();

#our main event-loop
Gtk2->main();


sub ret_vbox {

my $vbox = Gtk2::VBox->new(FALSE,5);

	my $frame = Gtk2::Frame->new("Basic Gtk2::TextView");
		
	#method of Gtk2::Container
	$frame->set_border_width(5);
	
		my $sw = Gtk2::ScrolledWindow->new (undef, undef);
    		$sw->set_shadow_type ('etched-out');
		$sw->set_policy ('automatic', 'automatic');
		#This is a method of the Gtk2::Widget class,it will force a minimum 
		#size on the widget. Handy to give intitial size to a 
		#Gtk2::ScrolledWindow class object
		$sw->set_size_request (500, 400);
		#method of Gtk2::Container
		$sw->set_border_width(5);
		
			my $tview = Gtk2::TextView->new();
				my $content = `cat ./lyrics.txt`;
  			my $buffer = $tview->get_buffer();
			$buffer->set_text($content);
			
		$sw->add($tview);
	$frame->add($sw);
$vbox->pack_start($frame,TRUE,TRUE,4);
	
	my $table = Gtk2::Table->new(4,5,FALSE);
		#editable toggle
		my $btn_editable = Gtk2::CheckButton->new("_Editable");
			$btn_editable->set_active(TRUE);
		$btn_editable->signal_connect('toggled' =>sub {
			if($btn_editable->get_active){
				$tview->set_editable(TRUE);
			}else{
				$tview->set_editable(FALSE);
			}
		});
		
	$table->attach_defaults($btn_editable,0,1,0,1);
		#visible cursor toggle
		my $btn_cursor = Gtk2::CheckButton->new("_Cursor Visible");
			$btn_cursor->set_active(TRUE);
		$btn_cursor->signal_connect('toggled' =>sub {
			if($btn_cursor->get_active){
				$tview->set_cursor_visible(TRUE);
			}else{
				$tview->set_cursor_visible(FALSE);
			}
		});
	$table->attach_defaults($btn_cursor,0,1,1,2);
		#left margin toggle
		my $btn_mar_l = Gtk2::CheckButton->new("_Left Margin");
		$btn_mar_l->signal_connect('toggled' =>sub {
			if($btn_mar_l->get_active){
				$tview->set_left_margin (50);
			}else{
				$tview->set_left_margin (0);
			}
		});
	$table->attach_defaults($btn_mar_l,0,1,2,3);
		#right margin toggle
		my $btn_mar_r = Gtk2::CheckButton->new("_Right Margin");
		$btn_mar_r->signal_connect('toggled' =>sub {
			if($btn_mar_r->get_active){
				$tview->set_right_margin (50);
			}else{
				$tview->set_right_margin (0);
			}
		});
	
	$table->attach_defaults($btn_mar_r,0,1,3,4);
		#wrap mode
		my $lbl_wrap = Gtk2::Label->new("Wrap Mode:");
	$table->attach_defaults($lbl_wrap,1,2,0,1);	
		
		my $combo_wrap = Gtk2::ComboBox->new_text();
		
			$combo_wrap->append_text("none");
			$combo_wrap->append_text("word");
			$combo_wrap->append_text("char");
			$combo_wrap->set_active(0);
			
		$combo_wrap->signal_connect('changed' =>sub{
		
			$tview->set_wrap_mode ($combo_wrap->get_active_text);
		});
			
	$table->attach_defaults($combo_wrap,2,3,0,1);
		#justification mode
		my $lbl_just = Gtk2::Label->new("Justification:");
	$table->attach_defaults($lbl_just,1,2,1,2);	
	
		my $combo_just = Gtk2::ComboBox->new_text();
		
			$combo_just->append_text("left");
			$combo_just->append_text("right");
			$combo_just->append_text("center");
			$combo_just->set_active(0);
			
		$combo_just->signal_connect('changed' =>sub{
		
			$tview->set_justification ($combo_just->get_active_text);
		});
			
	$table->attach_defaults($combo_just,2,3,1,2);
	
$vbox->pack_start($table,FALSE,FALSE,0);
$vbox->show_all();
return $vbox;
}

