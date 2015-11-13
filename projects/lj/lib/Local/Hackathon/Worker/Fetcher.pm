package Local::Hackathon::Worker::Fetcher;

use Mouse::Role;

has '+source',       default => 'fetch';
has '+destination',  default => 'title';

# sub process { ... }

1;
