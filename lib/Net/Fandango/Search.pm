package Net::Fandango::Search;

use Moose;
use Modern::Perl;
use Data::Dumper;

extends 'Net::Fandango';

has 'url' => (
	is => 'ro',
	lazy => 1,
	default => sub {
		my($movie) = shift;
		$movie->fandango_uri . '/GlobalSearch.aspx?';
	}
);

has 'query' => (
	is => 'rw',
	isa => 'Str',
	required => 1,
);

has 'movies' => (
	is => 'ro',
	lazy => 1,
	default => sub {
		my($search) = shift;
				
		my $movies = $search->search_on('Movies');
	}
	
);

sub search_on {
	my($search) 	= shift;
	my($on) 		= shift;
	
	my $search_url = $search->url . 'q=' . $search->query .'&repos='.$on;
	
	$search->mech->get($search_url);
	
	my $t = $search->p->parse( $search->mech->content );
	
	my $results = [];
	my(@featured) = ();
	my(@others) = ();
	
	eval {
		@featured = $t->look_down('_tag', 'ul', 'class', 'callout')->look_down('_tag' => 'h4');
	};
	@others = $t->look_down('_tag', 'ul', 'class', 'results')->look_down('_tag'=>'h5');
	
	push @$results, [$_->look_down('_tag'=>'a')->attr('href'), $_->as_text] for @featured, @others;
	
	my $real = [];
	for my $res (@$results) {
		push @$real, $res unless grep { $_->[1] eq $res->[1] } @$real;
	}
		
	die Dumper $real;

	die 'moo';
#	print Dumper @_;
}

no Moose;
__PACKAGE__->meta->make_immutable;