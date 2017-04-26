package Local::Metric::Test::Config;

use Test::Class::Moose extends => 'Local::Test';

use File::Temp ();

use Local::Metric::Config;

sub test_default {
    my ($self) = @_;

    isa_ok(
        Local::Metric::Config->default(),
        'Local::Metric::Config'
    );

    return;
}

sub test__build_fh {
    my ($self) = @_;

    my $fh = File::Temp->new();
    print {$fh} 'TEST';
    close($fh);

    my $config = Local::Metric::Config->new(
        filename => $fh->filename,
    );
    my $config_fh = $config->fh;

    is(<$config_fh>, 'TEST');

    return;
}

sub test__build_str {
    my ($self) = @_;

    my $fh = File::Temp->new();
    print {$fh} "a\nb\nc";
    close($fh);

    my $config = Local::Metric::Config->new(
        filename => $fh->filename,
    );

    is($config->str, "a\nb\nc");

    return;
}

sub test__build__data {
    my ($self) = @_;

    my $config = Local::Metric::Config->new(
        str => <<END
a:
 - 1
 - 2
 - 3
END
    );

    cmp_deeply(
        $config->_data,
        {
            a => [qw(1 2 3)],
        }
    );

    return;
}

sub test_get {
    my ($self) = @_;

    my $config = Local::Metric::Config->new(
        _data => {
            a => 1,
            b => 2,
        },
    );

    is($config->get('b'), 2);
    ok(!defined($config->get('c')));

    return;
}

1;
