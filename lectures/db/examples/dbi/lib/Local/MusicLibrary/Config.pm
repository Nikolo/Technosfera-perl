package Local::MusicLibrary::Config;

use strict;
use warnings;

use List::Util qw/first/;

use Exporter 'import';
use Local::MusicLibrary::Const;

our @EXPORT_OK = qw/check_config/;

sub check_config {
    my ($cfg) = @_;
    
    my ($filters, $sort, $columns);

    if($cfg->{sort}) {
        $sort = first {$cfg->{sort} eq $_} COLUMNS();
    }

    if(defined $cfg->{columns}) {
        my @columns = split /,/, $cfg->{columns};

        for my $c (@columns) {
            @columns = grep {$c eq $_} COLUMNS();
        }
        $columns = \@columns;
    } else {
        $columns = [ COLUMNS() ];
    }

    for my $c (COLUMNS()) {
        $filters->{$c} = $cfg->{$c} if defined $cfg->{$c};    
    }

    return ($cfg->{store}, $filters, $sort, $columns);
}

1;
