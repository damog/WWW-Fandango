#!/usr/bin/perl

use Modern::Perl;
use Data::Dumper;
use Net::Fandango::Search;

my $s = Net::Fandango::Search->new(
	query => shift
);

for my $movie (@{ $s->movies }) {
	print Dumper $movie;
}

# print Dumper $m;