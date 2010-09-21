#!/usr/bin/perl
use SDL; #needed to get all constants
use SDL::Events ':all';
use SDLx::App;
use SDLx::Sprite;
use SDLx::Controller::Interface;

use strict;
use warnings;

my $app = SDLx::App->new(
    title  => "Lunar Lander",
    width  => 800,
    height => 600,
    depth  => 32,
    dt     => 0.05,
);

my $background = SDLx::Sprite->new( image => 'images/background.jpg' );
my $ship       = SDLx::Sprite->new( image => 'images/ship.jpg' );

my $height   = 1000; # m
my $velocity = 0;    # m/s
my $gravity  = 1;    # m/s^2

my $script_re = qr/(\d+) \D+ (\d+)/x;
my %up = map { $_ =~ $script_re } <DATA>;

sub accel {
    my ( $t, $state ) = @_;

    if ( $state->y > 0 ) {
        my $sec = int($t);
        my $a = $up{$sec} ? $up{$sec} : 0;
        return (0, $a - $gravity, 0);
    } elsif ( $state->v_y > 10 ) {
        print "CRASH!!!\n";
        $state->v_y(0);
        return (0, 0, 0);
    } else {
        print "You landed on the surface safely! :-D\n";
        $state->v_y(0);
        return (0, 0, 0);
    }
}

my $ship_i = SDLx::Controller::Interface->new(
    x   => 100,
    y   => $height,
    v_y => $velocity,
);

$ship_i->set_acceleration( \&accel );

sub draw_background {
    $background->draw($app);
}

sub draw_ship {
    my ($state) = @_;

    # fix $y for screen resolution
    my $y = 450 * ( 1000 - $state->y ) / 1000;

    $ship->draw_xy( $app, $state->x, $y );
}

sub update_app {
    $app->update;
}

sub on_event {
    my ($event) = @_;

    return 0 if $event->type == SDL_QUIT;
    return 0 if $event->key_sym == SDLK_ESCAPE;

    return 1;
}

$app->add_show_handler( \&draw_background );
$ship_i->attach( $app, \&draw_ship );
$app->add_show_handler( \&update_app );

$app->add_event_handler( \&on_event );

$app->run;

__DATA__
at 41s, accelerate 10 m/s^2 up
at 43s, 10 m/s^2
at 45s, 10
at 47s, 10
at 49s, 10
