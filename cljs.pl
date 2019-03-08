#! /usr/bin/perl

=pod

=head1 AUTHOR

Nicholas Sardo - L<https://www.linkedin.com/in/nicksardo/>

=head1 DESCRIPTION

Super Simple Craigslist Minimal Job Search
EXAMPLE CODE
WORK IN PROGRESS

Usage:
To search the craigslist job board of interest in your city for a specific keyword, go to craigslist for your city and click on the board of interest. Example: web/info design. Copy that url.
Replace the url on line 23 with your own. Then to search for titles that include the word "perl" (not case sensitive)...

$ perl cljs.pl perl

=cut

use WWW::Mechanize();
use Mojo::DOM58;
use 5.26.3;

use warnings;
use strict;

###
# TODO:
# Print in color
###

my $mech = WWW::Mechanize->new();

#$mech->get( "https://portland.craigslist.org/d/skilled-trades-artisan/search/trd" );
$mech->get("https://portland.craigslist.org/d/web-html-info-design/search/web");

my $search = $ARGV[0];

print "\n";
say "Search for: $search\n\n";

my @links = $mech->find_all_links();

for my $mylinks ( @links ) {
    if ( defined($mylinks->text) && $mylinks->text =~ /$search/i ) {
        print "\n";
        say "-" x 80;
        say $mylinks->[0];

        $mech->follow_link( url_regex => qr/$search/i );

        say $mech->title();

        my $dom = Mojo::DOM58->new( $mech->content() );

        if ( defined( $dom->at('#postingbody') ) ) {
            say $dom->at('#postingbody')->text . "\n";
        }

        # COMPENSATION
        if ( defined( $dom->at('p.attrgroup > span') ) ) {
            print $dom->at('p.attrgroup > span')->text . " ";
        }
        if ( defined( $dom->at('p.attrgroup > span > b') ) ) {
            print $dom->at('p.attrgroup > span > b')->text . "\n";
        }

        # EMPLOYMENT TYPE
        if ( defined( $dom->at('p.attrgroup > span ~ span') ) ) {
            print $dom->at('p.attrgroup > span ~ span')->text . " ";
        }
        if ( defined( $dom->at('p.attrgroup >span ~ span > b') ) ) {
            print $dom->at('p.attrgroup > span ~ span > b')->text . "\n";
        }

        # FINAL
        if ( defined( $dom->at('p.attrgroup > span ~ span ~ span') ) ) {
            print $dom->at('p.attrgroup > span ~ span ~ span')->text . "\n";
        }
        
        say "-" x 80;
        print "\n\n";
    }
}