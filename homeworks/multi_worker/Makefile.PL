use 5.008008;
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME          => 'Local::App::ProcessCalc',
	VERSION_FROM  => 'lib/Local/App/ProcessCalc.pm', # finds $VERSION
	($] >= 5.005 ?	 ## Add these new keywords supported since 5.005
	  (ABSTRACT_FROM => 'lib/Local/App/ProcessCalc.pm', # retrieve abstract from module
	   AUTHOR        => 'Nikolas Shulyakovskiy <shulyakovskiy@mail.ru>') : ()),
);
