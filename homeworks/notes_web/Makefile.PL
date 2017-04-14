use ExtUtils::MakeMaker;

WriteMakefile(
    NAME            => 'Local::SocialNetwork',
    EXE_FILES       => ['bin/social_network.pl'],
    VERSION_FROM    => 'lib/Local/SocialNetwork.pm'
);
