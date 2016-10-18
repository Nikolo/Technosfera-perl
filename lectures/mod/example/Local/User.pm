package Local::User 1.3;

use strict;
use warnings;
use Digest::MD5 'md5_hex';
use List::Util qw/first/;
use Exporter 'import';
our @EXPORT = qw/get_by_email name welcome_string is_password_valid/;


my @USERS = (
    {
        first_name => 'Василий',
        last_name  => 'Пупкин',
        gender => 'f',
        email => 'vasily@pupkin.ru',
        passwd => '$1$f^34d*$24cc1e0d198dbf6bbfd812a30f1b4460',
    },
    {
        first_name => 'Николай',
        middle_name => 'Петрович',
        last_name  => 'Табуреткин',
        gender => 'm',
        email => 'taburet.98@mail.ru',
        passwd => 'd19f77fefeae0fabdfc75f17abc47c96',
    },
# .........
);


sub get_by_email {
    my $email = shift;
    my ($user) = first { $_->{email} eq $email } @USERS;
    return $user;
}

sub name {
    my $user = shift;
    return join ' ',
        grep { length $_ }
        map { $user->{$_} }
            qw/first_name middle_name last_name/;
}

sub welcome_string {
    my $user = shift;
    return
      ($user->{gender} eq 'm' ?
        "Уважаемый " : "Уважаемая ") .
      name($user) . "!";
}


my $SALT = "perl rulez!";

# (password_hashed_data, password_to_check)
my %CHECKERS = (
  0 => sub { $_[0] eq md5_hex($_[1] . $SALT) },
  1 => sub {
    my ($rand, $hash) = split '$', $_[0];
    return
      $hash eq md5_hex($_[1] . $SALT . $rand);
  },
);

sub is_password_valid {
  my ($user, $passwd) = @_;
  my ($version, $data) = (0, $user->{passwd});
  if ($user->{passwd} =~ /^\$(\d+)\$(.+)$/) {
    # new scheme
    ($version, $data) = ($1, $2);
    die "Don't know passwd version $version"
      unless $CHECKERS{$version};
  }
  return $CHECKERS{$version}->($data, $passwd);
}

1;
