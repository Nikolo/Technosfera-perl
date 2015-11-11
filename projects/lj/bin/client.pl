#!/usr/bin/env perl

use strict;
use lib::abs '../lib';
use Local::Hackathon::Client;
use Local::Hackathon::Const;
use DDP;

my $c = Local::Hackathon::Client->new;

my $res = $c->request(PKT_PUT, [ 'fetch', { URL => 'https://mail.ru' } ]);
p $res;