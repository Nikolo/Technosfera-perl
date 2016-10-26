#!/usr/bin/env perl

use 5.010;
use strict;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Local::Chat::Server;

Local::Chat::Server->new()->listen;
