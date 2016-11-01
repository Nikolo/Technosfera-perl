package Local::Subref::Schema::ResultSet::User;

use base 'DBIx::Class::ResultSet';

use List::Util qw(all);

sub search_with_comment {
    my ($self) = @_;

    return $self->search({
        -and => [
            {comment => {'!=' => undef}},
            {comment => {'!=' => ''}},
        ]
    });
}

sub are_all_comments_palindrome {
    my ($self) = @_;

    return all {$_->comment eq reverse $_->comment} $self->all();
}

1;
