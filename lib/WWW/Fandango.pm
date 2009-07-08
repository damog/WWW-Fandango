package WWW::Fandango;

use Moose;
use Modern::Perl;
use Data::Dumper;
use WWW::Mechanize;
use HTML::TreeBuilder;

our $VERSION = '0.0.1.1';

# wha!

# I stole most of this from Net::Twitter
around BUILDARGS => sub {
	my $m = shift; my $self = shift;
	
	my $args = $self->$m(@_);
	
	my $fandango_defaults = delete $args->{fandango_defaults} || {
		fandango_uri => "http://www.fandango.com",
	};
	
	return {
		%$fandango_defaults, %$args
	}
};

has 'fandango_uri' => (
        isa    => 'Str', is => 'rw', required => 1,
);

has 'mech' => (
	is => 'ro',
	builder => '_mech',	
);

has 'p' => ( # p stands for parser: HTML::TreeBuilder
	is => 'ro',
	builder => '_p',
);

sub _p {
	my $p = HTML::TreeBuilder->new;
	$p;
};

sub _mech {
	my $mech = WWW::Mechanize->new;
	$mech->timeout(10);
	$mech;
}

no Moose;
__PACKAGE__->meta->make_immutable;

=head1 NAME

WWW::Fandango - Perl interface for the Fandango website

=head1 DESCRIPTION

C<WWW::Fandango> is a set of subclasses that lets you deal and interact with the different
items and concepts that the Fandango website shows, such as movies, theaters, casts, search,
showtimes, etc.

C<WWW::Fandango> is built with Moose because I<"Moose is cool">, -Larry Wall.

=head1 USAGE

You don't necessarily have to deal with the C<Net::Fandango> class, but to its classes. Please,
take a look at the documentation of each or see L<WWW::Fandango::Cookbook>.

=head1 SUBCLASSES

=head2 WWW::Fandango::Movie

Abstracts the concept of a movie on the Fandango website. Please see L<WWW::Fandango::Movie>
for more information.

=head2 WWW::Fandango::Theater

Abstracts the concept of a movie theather from the Fandango website. Please see
L<WWW::Fandango::Theater> for more information.

=head2 WWW::Fandango::Showtime

Abstracts the concept of a showtime from the Fandango website. A movie might been shown
on a number of theaters correlating C<WWW::Fandango::Location> and some date. Please see
L<WWW::Fandango::Showtime> for more information.

=head2 WWW::Fandango::Location

Location abstraction object for the addresses items that Fandango uses. Please see
L<WWW::Fandango::Location> for more information.

=head2 WWW::Fandango::Search

Interaction with the Fandango search.

=head1 AUTHOR

David Moreno E<lt>david@axiombox.comE<gt>.

If interested, the author maintains a weblog with news about this and other developments
called B<Infinite Pig Theorem>, L<http://log.damog.net>.

=head1 LICENSE

Copyright 2009 by David Moreno E<lt>david@axiombox.comE<gt>.

This library is free software; you can redistribute it and/or modify it under the terms of the WTFPL.
