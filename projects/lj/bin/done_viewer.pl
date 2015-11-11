use Mojolicious::Lite;
use lib '/Users/vpushtaev/Technosfera-perl/projects/lj/lib/';

use Local::Hackathon::Client;

get '/' => {template => 'index'};

websocket '/ws' => sub {
  my ($c) = @_; 

  $c->on(drain => sub {
    my ($c, $msg) = @_; 

    sleep(2);

    eval {
        my $client = Local::Hackathon::Client->new(
          #host => '192.168.0.39',
          host => '192.168.0.65',
          port => '3456',
        );  
        local $SIG{ALRM} = sub { die "TIMEOUT\n" };
        alarm(2);
        my $data = $client->take('done');
        alarm(0);
        $c->send({json => (
            $data ? {data => $data} : {skip => 1}
        )});
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
        'URL',
        'HTML',
        'comments',
        'comments_info',
        'title',
        'links',
        'images',
    ];

    if (skip) {
        div.append('...');
    }
    else if (error) {
        div.addClass('error');
        div.append(result);
    }
    else {
      div.append('[' + result.id + '] ' + result.task.URL + '<br>');
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
