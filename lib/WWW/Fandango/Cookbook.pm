=head1 NAME

WWW::Fandango::Cookbook - Recipes for Net::Fandango

=head1 RECIPES

=head2 Obtain the showtimes for an specific movie

We are assuming we already know the Fandango ID for the movie.
If you don't know what this ID is, please a look at L<WWW::Fandango::Movie>.

 my $m = WWW::Fandango::Movie->new(
 	id => 'transformers:revengeofthefallen_111307'
 );
 
 $m->location(
	WWW::Fandango::Location->new(zip => 10013),
 );
 
 $m->date(
 	DateTime->now;
 );

 print Dumper $m->showtimes;

=head2 Getting name and URL for searched movies

 my $s = WWW::Fandango::Search->new(
 	query => 'batman'
 );

 for my $mov ($s->movies) {
	say "Name: ".$mov->name;
	say "URL: ".$mov->url;
 }

=head1 AUTHOR

David Moreno E<lt>david@axiombox.comE<gt>.

=head1 LICENSE

Same as C<WWW::Fandango>.

