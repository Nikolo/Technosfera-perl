use 5.008008;
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME          => 'PerlIO::via::Numerator',
	VERSION_FROM  => 'lib/PerlIO/via/Numerator.pm', # finds $VERSION
	($] >= 5.005 ?	 ## Add these new keywords supported since 5.005
	  (ABSTRACT_FROM => 'lib/PerlIO/via/Numerator.pm', # retrieve abstract from module
	   AUTHOR        => 'Nikolas Shulyakovskiy <shulyakovskiy@mail.ru>') : ()),
);
