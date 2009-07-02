package Net::Fandango::Showtime;

use Moose;
use Modern::Perl;

has 'theater' => (
	is => 'rw',
	isa => 'Net::Fandango::Theater',
);

has 'movie' => (
	is => 'rw',
	isa => 'Net::Fandango::Movie',
);

has 'url' => (
	is => 'rw',
	isa => 'Str',
	reader => { 'url' => sub { URI->new(shift) } },
);	

has 'datetime' => (
	is => 'rw',
	isa => 'DateTime'
);

no Moose;
__PACKAGE__->meta->make_immutable;