use ExtUtils::MakeMaker;

WriteMakefile(
    NAME            => 'Local::Iterator',
    EXE_FILES       => ['bin/music_library.pl'],
    VERSION_FROM    => 'lib/Local/MusicLibrary.pm'
);
