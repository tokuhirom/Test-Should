use strict;
use warnings;
use utf8;
use Test::More;
use Test::Should;

{
    package MyObj;
    sub new {
        my $class = shift;
        bless {}, $class;
    }
}

subtest 'autobox' => sub {
    1->should_be_ok();
    0->should_not_be_ok();
    [1,2,3]->should_include(3);
};

subtest 'universal' => sub {
    my $obj = MyObj->new();
    $obj->should_be_ok();
};

done_testing;

