use Mojolicious::Lite;

use Local::Hackathon::Client;
my $STATUS = 'view';
my $DONE_STATUS = 'view';
my $FAKE_SERVER = '100.100.159.176';
my $REAL_SERVER = '100.100.148.90';

get '/' => {template => 'index'};

websocket '/ws' => sub {
  my ($c) = @_;

  $c->on(drain => sub {
    my ($c, $msg) = @_;

    eval {
        my $client = Local::Hackathon::Client->new(
          #host => $FAKE_SERVER,
          host => $REAL_SERVER,
          port => '3456',
        );
        local $SIG{ALRM} = sub { die "TIMEOUT\n" };
        alarm(5);
        my $data = $client->take($STATUS);
	#$client->requeue($data->{id}, 'og', $data->{task}) if defined $data->{id};
	$client->release($data->{id}) if defined $data->{id} && $STATUS ne $DONE_STATUS;
	$client->ack($data->{id}) if defined $data->{id} && $STATUS eq $DONE_STATUS;
        alarm(0);
	if (exists $data->{task}){
		delete $data->{task}->{$_} for grep {!$data->{task}->{$_}} keys %{$data->{task}};
	}
        $c->send({json => (
            $data ? {data => $data} : {skip => 1}
        )}) if $data->{task};
#	sleep(1);
	1;
    } or do {
        $c->send({json => {error => $@}});
    };
  });
};

app->start;

__DATA__

@@ index.html.ep
% my $url = url_for 'ws';

<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/themes/smoothness/jquery-ui.css">
<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>

<style>
div {
  margin: 10px;
  padding: 5px;
  float: left;
  width: 90%;
  display: none;
}

div.error {
  font-size: 4em;
  color: red;
}

span.green {
  margin: 10px;
  font-size: 2em;
  color: green;
}

span.red {
  margin: 10px;
  font-size: 3em;
  color: red;
}
</style>

<script>
$(document).ready(function() {
  var ws = new WebSocket('<%= $url->to_abs %>');
  ws.onmessage = function (event) {
    var data = JSON.parse(event.data);
    console.log(data);
    var result;
    var error;
    var skip;

    if (data['skip']) {
        skip = true;
    }
    else if (data['error']) {
      result = data['error'];
      error = true;
    }
    else {
      result = data['data'];
      error = false;
    }

    var div = $('<div class="ui-corner-all ui-widget-content"></div>');
    var fields = [
        'url',
        'HTML',
        'title',
        'description',
        'author',
	'links',
	'image_links',
	'collage',
	'tags',
	'words',
	'og',
    ];

    if (skip) {
        div.append('...');
    }
    else if (error) {
        div.addClass('error');
        div.append(result);
    }
    else {
      div.append('[' + result.id + '] ' + result.task.url + '<br>');
      $.each(fields, function(index, field) {
        var status = $('<span>' + field + '</span>');
        if (field in result.task && result[field] !== '') {
          status.addClass('green');
        }
        else {
          status.addClass('red');
        }
        div.append(status);
      });
    }

    $(document.body).prepend(div);
    $(document.body).find('div').show('slide', '', 800);
  };
});
</script>

<body></body>
