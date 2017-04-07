#!/usr/bin/env perl

use warnings;
use strict;

use Dancer2;


get '/:name' => sub {
    return "Hello from ".params->{name};
};

dance;

