package Net::Fandango::Movie;

use Moose;
use Modern::Perl;
use Data::Dumper;
use autodie qw(:all);

# wha!
extends 'Net::Fandango';

has 'id' => (
	is => 'rw',
	required => 1,
);

has 'url' => (
	is => 'ro',
	lazy => 1,
	default => sub {
		my($movie) = shift;
		$movie->fandango_uri . '/' . $movie->id . '/movieoverview';
	}
);

has 'title' => (
	is => 'ro',
	lazy => 1,
	default => sub {
		my($movie) = shift;
		
		$movie->movieoverview->look_down(
			_tag => 'li',
			class => 'title'
		)->as_trimmed_text;
		
	}
);


has 'description' => (
	is => 'ro',
	lazy => 1,
	default => sub {
		my($movie) = shift;
		
		# syn => synopsis
		my $syn = $movie->movieoverview->look_down(
			'_tag' => 'li',
			'class' => 'synopsis'
		);
		
		eval { # fandango might change this
			$syn->look_down(
				'_tag' => 'a',
				'id' => 'read_more'
			)->delete;
		};
		
		$syn->as_trimmed_text;

	}
);

has 'movieoverview' => (
	is => 'ro',
	lazy => 1,
	default => sub {
		my($movie) = shift;
		
		$movie->mech->get( $movie->url );
		
		my $e = $movie->p->parse( $movie->mech->get->content);
		
		$e;
	}
	
);

no Moose;
__PACKAGE__->meta->make_immutable;
