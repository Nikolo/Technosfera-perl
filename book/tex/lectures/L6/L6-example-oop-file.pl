use File::Spec;

print File::Spec->catfile('a', 'b', 'c');
# Unix-like OS: a/b/c
# Windows:      a\b\c
