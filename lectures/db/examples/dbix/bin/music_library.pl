#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long;
use Local::MusicLibrary qw/run/;
use Local::MusicLibrary::Const;

my $CONFIG = {
    store   => undef,
    band    => undef,
    year    => undef,
    album   => undef,
    track   => undef,
    format  => undef,
    sort    => undef,
    columns => undef
};

GetOptions($CONFIG, qw/
    store!
    band=s
    year=i
    album=s
    track=s
    format=s
    sort=s
    columns=s
/);

run($CONFIG);

__END__
CREATE TABLE `library` (
  `band` varchar(255) NOT NULL,
  `year` year(4) NOT NULL,
  `album` varchar(255) NOT NULL,
  `track` varchar(255) NOT NULL,
  `format` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `bands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `comment` text,
  `year` year(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `albums` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `comment` text,
  `year` year(4) NOT NULL,
  `band_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tracks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `comment` text,
  `album_id` int(11) NOT NULL,
  `band_id` int(11) NOT NULL,
  `format` varchar(10) NOT NULL DEFAULT 'mp3',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

