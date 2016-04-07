use ExtUtils::MakeMaker;

WriteMakefile(
    NAME            => 'Local::Habr',
    EXE_FILES       => ['bin/habr.pl'],
    VERSION_FROM    => 'lib/Local/Habr.pm'
);
