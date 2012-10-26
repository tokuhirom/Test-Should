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

package Test::Should::Impl;
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

Test::Should - What you should do.

=head1 SYNOPSIS

  use Test::Should;

=head1 DESCRIPTION

Test::Should is

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom AAJKLFJEF@ GMAIL COME<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
