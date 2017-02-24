use XML::LibXML;

my $document = XML::LibXML->load_xml(
    string => '...'
);

my $list = $document->findnodes('...');
# XML::LibXML::NodeList
