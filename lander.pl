#!/usr/bin/perl
use SDL; #needed to get all constants
use SDL::Events ':all';
use SDLx::App;
use SDLx::Sprite;

use strict;
use warnings;

my $app = SDLx::App->new(
    title  => "Lunar Lander",
    width  => 800,
    height => 600,
    depth  => 32,
    dt     => 1,
);

my $background = SDLx::Sprite->new( image => 'images/background.jpg' );
my $ship       = SDLx::Sprite->new( image => 'images/ship.jpg' );

my $height   = 1000; # m
my $velocity = 0;    # m/s
my $gravity  = 1;    # m/s^2

my $t = 0;

my $script_re = qr/(\d+) \D+ (\d+)/x;
my %up = map { $_ =~ $script_re } <DATA>;

sub move {
    if ( $height > 0 ) {
        print "at $t s height = $height m, velocity = $velocity m/s\n";

        if ( $up{$t} ) {
            my $a = $up{$t};
            print "(accellerating $a m/s^2)\n";
            $velocity = $velocity - $a;
        }

        $height   = $height - $velocity;
        $velocity = $velocity + $gravity;
        $t        = $t + 1;
    } elsif ( $velocity > 10 ) {
        print "CRASH!!!\n";
    } else {
        print "You landed on the surface safely! :-D\n";
    }
}

sub draw {
    my ( $x, $y ) = ( 100, $height ); # spaceship position

    # fix $y for screen resolution
    $y = 450 * ( 1000 - $y ) / 1000;

    $background->draw($app);
    $ship->draw_xy( $app, $x, $y );

    $app->update;
}

sub on_event {
    my ($event) = @_;

    return 0 if $event->type == SDL_QUIT;
    return 0 if $event->key_sym == SDLK_ESCAPE;

    return 1;
}

$app->add_event_handler( \&on_event );
$app->add_show_handler( \&draw );
$app->add_move_handler( \&move );

$app->run;

__DATA__
at 41s, accelerate 10 m/s^2 up
at 43s, 10 m/s^2
at 45s, 10
at 47s, 10
at 49s, 10
