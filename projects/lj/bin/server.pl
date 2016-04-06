#!/usr/bin/env perl

use strict;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Local::Hackathon::Server;

Local::Hackathon::Server->new->run();
