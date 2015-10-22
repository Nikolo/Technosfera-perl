use 5.008008;
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME          => 'Sfera::TCP::Calc',
	VERSION_FROM  => 'lib/Sfera/TCP/Calc.pm', # finds $VERSION
	($] >= 5.005 ?	 ## Add these new keywords supported since 5.005
	  (ABSTRACT_FROM => 'lib/Sfera/TCP/CAlc.pm', # retrieve abstract from module
	   AUTHOR        => 'Nikolas Shulyakovskiy <shulyakovskiy@mail.ru>') : ()),
);
