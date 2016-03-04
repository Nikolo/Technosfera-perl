cc -o templater main.c `perl -MExtUtils::Embed -e ccopts -e ldopts`
./templater Plugin test.tmpl ./
rm -r templater*

