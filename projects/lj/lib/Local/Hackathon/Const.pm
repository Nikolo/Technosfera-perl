package Local::Hackathon::Const;

=for rem

1. Queue                         #####
    + iproto + json
    + perfork
    + networking
    + storage
2. Queue storage                 #####
    + put(channel, task) -> id
    + take(channel) -> id, task
    + ack(id)
    + release(id)
    + requeue(id, channel, task) -> id
3. Urls generator
    + LJ atom feed               #####
    + RSS feed - ? (XML::RSS)    ####
4. Task processor (client) # HTML::Parser, Web::Query, Mojo::DOM, 
    + Client class, take, ( process, requeue ) | release
    requeuers:
    + URL -> content (fetcher)   ##
    + content -> title           #
    + 
    + content -> images          ##
    + content -> links           ##
    + content -> comments        ###
    + 
    + content -> words           ####
    + content -> opengraph       ####
    + content -> favicon         ####
    + content -> TOC             ####
    + content -> forms           ####
    
    single worker:
    + queue stats                ###

=cut

use strict;
use warnings;

our %CONST;
our %PACKETS;
BEGIN {
	%CONST = (
		PKT_PUT     => 1,
		PKT_TAKE    => 2,
		PKT_ACK     => 3,
		PKT_RELEASE => 4,
		PKT_REQUEUE => 5,

		MAXBUF      => 20*1024*1024,
	);
	for (grep /^PKT_/, keys %CONST) {
		$PACKETS{ $CONST{$_} } = $_;
	}
}

use constant \%CONST;
use Exporter 'import';
use DDP;

our @EXPORT = our @EXPORT_OK = (keys %CONST, '%PACKETS');

1;