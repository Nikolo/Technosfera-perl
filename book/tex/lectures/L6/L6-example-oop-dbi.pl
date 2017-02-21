$dbh = DBI->connect(
    $data_source,
    $username,
    $auth,
    \%attr
);

$rv = $dbh->do('DELETE FROM table');
