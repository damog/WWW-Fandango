#!/usr/bin/perl

use Modern::Perl;
use Data::Dumper;
use Net::Fandango::Search;
use Net::Fandango::Location;

my $m = Net::Fandango::Movie->new(
	id => 'transformers:revengeofthefallen_111307'
);

$m->location(
	Net::Fandango::Location->new(zip => 10039)
);

$m->date(
	DateTime->now->add(days => 1)
);

print Dumper $m->showtimes();

# for my $movie ($s->movies) {
# 	say "URL: ".$movie->url;
# 	say $movie->title;
# 	say $movie->description;
# 	say "";
# }
# 
# # print Dumper $m;