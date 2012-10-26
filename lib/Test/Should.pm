package Test::Should;
use strict;
use warnings;
use 5.010001;
our $VERSION = '0.01';
use Test::Should::Engine;

use parent qw/autobox/;

sub import {
    my $class = shift;
    $class->SUPER::import( 'DEFAULT' => 'Test::Should::Impl' );
}

my $ddf = sub {
    local $Data::Dumper::Terse = 1;
    local $Data::Dumper::Indent = 0;
    local $Data::Dumper::MaxDepth = 0;
    Data::Dumper::Dumper(@_);
};

sub _autoload {
    my $method = shift;
    my $test = Test::Should::Engine->run($method, @_);
    my $builder = Test::Builder->new();
    $builder->ok($test, join('',
        $ddf->($_[0]),
        ' ',
        $method,
        $_[1] ? ' ' . $ddf->($_[1]) : ''
    ));
}

package # hide from pause
    Test::Should::Impl;
use Carp ();
use Data::Dumper ();
use Test::Builder;

our $AUTOLOAD;
sub AUTOLOAD {
    $AUTOLOAD =~ s/.*:://;
    if ($AUTOLOAD =~ /^should_/) {
        local $Test::Builder::Level = $Test::Builder::Level + 1;
        Test::Should::_autoload("$AUTOLOAD", @_);
    } else {
        Carp::croak("Unknown method: $AUTOLOAD");
    }
}

package UNIVERSAL;
sub DESTROY { }

our $AUTOLOAD;
sub AUTOLOAD {
    $AUTOLOAD =~ s/.*:://;
    if ($AUTOLOAD =~ /^should_/) {
        Test::Should::_autoload("$AUTOLOAD", @_);
    } else {
        Carp::croak("Unknown method: $AUTOLOAD");
    }
}

1;
__END__

=encoding utf8

=head1 NAME

Test::Should - Should it be ok??

=head1 SYNOPSIS

    use Test::More;
    use Test::Should;

    1->should_be_ok;
    [1,2,3]->should_include(3);

    done_testing;

    # testing result:
    ok 1 - 1 should_be_ok
    ok 2 - [1,2,3] should_include 3
    1..2

=head1 DESCRIPTION

Test::Should is yet another testing library to write human readable test case.

And this module generates human readable test case description.

B<This is a development release. I may change the api in the future>

For more method name details, please look L<Test::Should::Engine>

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom AAJKLFJEF@ GMAIL COME<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
