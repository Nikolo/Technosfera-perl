package MyPrivateTest;

use strict;
use warnings;

sub xx1  { "MyPrivateTest::xx1"   }
sub _xx2 { "MyPrivateTest::_xx2"  }

use myprivate;

sub xx3  { "MyPrivateTest::xx3"  }
sub _xx4 { "MyPrivateTest::_xx4" }

no myprivate;

sub xx5  { "MyPrivateTest::xx5"  }
sub _xx6 { "MyPrivateTest::_xx6" }

1;
