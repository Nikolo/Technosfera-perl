#!/usr/bin/env perl

use warnings;
use strict;

use Mojolicious::Lite;


get '/:name' => sub {
  my $c   = shift;
  my $name = $c->param('name');
  $c->render(text => "Hello from $name.\n");
};

app->start;
