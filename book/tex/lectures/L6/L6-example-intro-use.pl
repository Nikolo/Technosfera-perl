# Some::Package->import(qw(a b c));
use Some::Package qw(a b c);

# Some::Package->unimport;
no Some::Package;

# Some::Package->VERSION(10.01);
use Some::Package 10.01;
