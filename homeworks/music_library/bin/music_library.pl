#!/usr/bin/env perl
use lib qw(/home/Vyacheslav/Modules);
use strict;
use warnings;
use Local::Filter;
use Local::Options;
use Local::Sort;
use Local::Tableprint;
use Data::Dumper;
use Getopt::Long;
#Here come default values
my $sort;
my @columns;
my $errcheck;
my %parameters = (
	'band' => '',
	'year' => '',
	'album' => '',
	'track' => '',
	'format' => '',
	'sort' => '',
	'columns' => \@columns);
my @database; 					#arrays of arrays such as band:year:album:track:format
$errcheck = Options(\%parameters);
if (defined $errcheck) {die ($errcheck)};
Filter(\@database, \%parameters);
$sort = $parameters{'sort'};
Sort(\@database, $sort);
Tableprint(\@database, \@columns);

