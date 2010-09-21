#!/usr/bin/perl
use SDL; #needed to get all constants
use SDLx::App;
use SDLx::Sprite;

use strict;
use warnings;

my $app = SDLx::App->new(
    title  => "Lunar Lander",
    width  => 800,
    height => 600,
    depth  => 32,
);

my $background = SDLx::Sprite->new( image => 'images/background.jpg' );
my $ship       = SDLx::Sprite->new( image => 'images/ship.jpg' );

sub draw {
    my ( $x, $y ) = @_; # spaceship position

    # fix $y for screen resolution
    $y = 450 * ( 1000 - $y ) / 1000;

    $background->draw($app);
    $ship->draw_xy( $app, $x, $y );

    $app->update;
}

my $height   = 1000; # m
my $velocity = 0;    # m/s
my $gravity  = 1;    # m/s^2

my $t = 0;

my $script_re = qr/(\d+) \D+ (\d+)/x;
my %up = map { $_ =~ $script_re } <DATA>;

while ( $height > 0 ) {
    print "at $t s height = $height m, velocity = $velocity m/s\n";

    if ( $up{$t} ) {
        my $a = $up{$t};
        print "(accellerating $a m/s^2)\n";
        $velocity = $velocity - $a;
    }

    $height   = $height - $velocity;
    $velocity = $velocity + $gravity;
    $t        = $t + 1;

    draw( 100, $height );
    $app->delay(10);
}

if ( $velocity > 10 ) {
    print "CRASH!!!\n";
} else {
    print "You landed on the surface safely! :-D\n";
}

# small delay to let us view the window
# in the end, before closing
sleep 2;

__DATA__
at 41s, accelerate 10 m/s^2 up
at 43s, 10 m/s^2
at 45s, 10
at 47s, 10
at 49s, 10
