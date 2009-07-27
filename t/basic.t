use strict;
use warnings;

use Test::More tests => 4;
use Test::Exception;


my %config;

# Stolen from Catalyst::Plugin::Session t/01_setup.t
{
    package MockContext;

    use MRO::Compat;

    use base 'Catalyst::Plugin::Session::AsObject';

    sub new { bless {}, $_[0] }
    sub config { \%config }

    sub debug { }

    my @mock_isa =
        qw( Catalyst::Plugin::Session::State Catalyst::Plugin::Session::Store );

    sub isa
    {
        my $self  = shift;
        my $class = shift;

        grep { $_ eq $class } @mock_isa or $self->SUPER::isa($class);
    }
}

throws_ok( sub { MockContext->new()->setup() },
           qr/\QMust provide an object_class in the session config when using Catalyst::Plugin::Session::AsObject/,
           'cannot use Session::AsObject without setting object_class config item' );

$config{session}{object_class} = 'DoesNotExist';

throws_ok( sub { MockContext->new()->setup() },
           qr/\QThe object_class in the session config is either not loaded or does not have a new() method/,
           'object_class must already be loaded' );

{
    package MySession;

    sub new { bless {}, $_[0] }
}

$config{session}{object_class} = 'MySession';

lives_ok( sub { MockContext->new()->setup() },
          'setup works when object_class exists' );

my $c = MockContext->new();
$c->setup();

isa_ok( $c->session_object(), 'MySession',
        '$c->session_object' );
