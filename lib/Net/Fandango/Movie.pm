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
		$movie->fandango_uri . '/' . $movie->id . '/'. $movie->type_url;
	}
);

has 'type_url' => (
	is => 'rw',
	lazy => 1,
	default => 'movieoverview',
);

has 'title' => (
	is => 'rw',
	lazy => 1,
	default => sub {
		my($movie) = shift;
		
		if($movie->type_url eq 'summary') {
			$movie->movieoverview->find('title')->as_text =~ m!(.+?) Synopsis$!;
			return $1;
		} else {
			$movie->movieoverview->look_down(
				_tag => 'li',
				class => 'title'
			)->as_trimmed_text;
		};
		
		# croak "Issues getting title on ".$movie->url if $@;
	}
);


has 'description' => (
	is => 'rw',
	lazy => 1,
	default => sub {
		my($movie) = shift;
				
		if($movie->type_url eq 'summary') {
			my $syn = $movie->movieoverview->look_down(
				_tag => 'div',
				class => 'tab-content',
			)->find('p');
			
			defined $syn ? $syn->as_text : qq\\;
		} else {
		
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
			
			if (defined $syn) {
				$syn->as_trimmed_text;
			} else {
				qq//;
			}
		}

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
