package fastpaste;
use utf8;
use Dancer2;
use Dancer2::Plugin::Database;
use Digest::CRC qw/crc64/;
use HTML::Entities;

our $VERSION = '0.1';

my $upload_dir = 'paste';

sub get_upload_dir {
    return config->{appdir} . '/' . $upload_dir . '/';
}

sub delete_entry {
    my $id = shift;
    database->do('DELETE FROM paste WHERE id = cast(? as signed)', {}, $id);
    unlink get_upload_dir . $id;
}

get qr{^/([a-f0-9]{16})$} => sub {
    my ($id) = splat;
    $id = unpack 'Q', pack 'H*', $id;
    my $sth = database->prepare('SELECT cast(id as unsigned), create_time, unix_timestamp(expire_time), title FROM paste where id = cast(? as signed)');
    unless ($sth->execute($id)) {
        response->status(404);
        return template 'index' => {err => ['Fast paste not found']};
    }
    my $db_res = $sth->fetchrow_hashref();
    if ($db_res->{expire_time} and $db_res->{expire_time} < time()) {
        delete_entry($id);
        response->status(404);
        return template 'index' => {err => ['Fast paste expired']};
    }
    my $fh;
    unless (open($fh, '<:utf8', get_upload_dir . $id)) {
        delete_entry($id);
        response->status(404);
        return template 'index' => {err => ['Fast paste not found']};
    }
    my @text = <$fh>;
    close($fh);
    for (@text) {
        $_ = encode_entities($_, '<>&"');
        s/\t/&nbsp;&nbsp;&nbsp;&nbsp;/g;
        s/^ /&nbsp;/g;
    }
    $db_res->{title} = encode_entities($db_res->{title}, '<>&"');
    return template 'paste_show.tt' => {id => $id, text => \@text, raw => join('', @text), create_time => $db_res->{create_time}, expire_time => $db_res->{expire_time}, title => $db_res->{title}};
};

get '/' => sub {
    template 'index';
};

post '/' => sub {
    my $text = params->{textpaste};
    my $title = params->{title}||'';
    my $expire = params->{expire};

    my @err = ();
    if (!$text) {
        push @err, 'Empty text';
    }
    if (length($text) > 10240) {
        push @err, 'Text to large';
    }
    if ($expire =~ /\D/ or $expire < 0 or $expire > 3600 * 24 * 365) {
        push @err, 'Expire more than 365 days or bad format';
    }
    if (@err) {
        $text = encode_entities($text, '<>&"');
        $title = encode_entities($title, '<>&"');
        return template 'index' => {text => $text, title => $title, expire => $expire, err => \@err};
    }

    my $create_time = time();
    my $expire_time = $expire ? $create_time + $expire : undef;
    my $sth = database->prepare('INSERT INTO paste (id, create_time, expire_time, title) VALUES (cast(? as signed),from_unixtime(?),from_unixtime(?),?)');

    my $id = '';
    my $try_count = 10;
    while (!$id or -f get_upload_dir . $id) {
        database->do("DELETE FROM paste where id = cast(? as signed);", {}, [$id]) if $id;
        unless (--$try_count) {
            $id = undef;
            last;
        }
        $id = crc64($text.$create_time.$id);
        $id = undef unless $sth->execute($id, $create_time, $expire_time, $title)
    }
    unless ($id) {
        die "Try latter";
    }
    
    my $fh;
    unless (open($fh, '>', get_upload_dir . $id)) {
        die "Internal error ", $!;
    }
    print $fh $text;
    close($fh);
    redirect '/' . unpack 'H*', pack 'Q', $id;
};

hook before_template_render => sub {
    my $tokens = shift;
    my $last_paste = database->selectall_arrayref('SELECT cast(id as unsigned) as id, create_time, title from paste where expire_time is null or expire_time > current_timestamp order by create_time desc limit 10', {Slice => {}});
    for (@$last_paste) {
        $_->{title} = encode_entities($_->{title}, '<>&"');
        $_->{id} = unpack 'H*', pack 'Q', $_->{id};
    }
    $tokens->{last_paste} = $last_paste;
};

true;
