# Copyright (C) 2015-2016 Yoann Le Garff, Nicolas Boquet and Yann Le Bras
# navel-collector-test-stress is licensed under the Apache License, Version 2.0

#-> BEGIN

#-> initialization

package Navel::Collector::Test::Stress;

use Navel::Base;

use Navel::AnyEvent::Pool;

#-> class variables

my $plugin_pool = Navel::AnyEvent::Pool->new();

#-> methods

sub init {
    $plugin_pool->attach_timer(
        name => $_,
        singleton => 1,
        interval => 1,
        callback => sub {
            my $timer = shift->begin();

            W::queue()->enqueue(
                W::event(
                    [
                        0..W::collector()->{backend_input}->{array_size}
                    ]
                )
            );

            $timer->end();
        }
    ) for 0..W::collector()->{backend_input}->{number_of_job};
}

sub enable {
    $_->enable() for @{$plugin_pool->timers()};

    shift->(1);
}

sub disable {
    $_->disable() for @{$plugin_pool->timers()};

    shift->(1);
}

# sub AUTOLOAD {}

# sub DESTROY {}

1;

#-> END

__END__

=pod

=encoding utf8

=head1 NAME

Navel::Collector::Twitter::Stream::Track

=head1 COPYRIGHT

Copyright (C) 2015-2016 Yoann Le Garff, Nicolas Boquet and Yann Le Bras

=head1 LICENSE

navel-collector-test-stress is licensed under the Apache License, Version 2.0

=cut
