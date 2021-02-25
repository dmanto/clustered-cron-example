#!/usr/bin/env perl
use Mojolicious::Lite -signatures;
use Mojo::Util qw/b64_decode b64_encode/;
use Mojo::JSON qw/decode_json encode_json true/;
use Sys::Hostname;

my $etc_server_api = 'http://localhost:2379/v3alpha';
my $cron_key       = 'Mojo::Cron clustered example';

my $host = hostname;

# every 10 seconds schedule
plugin Cron => (
  '*/10 * * * * *' => sub {
    my $dtime = shift // 'undef';
    app->ua->post_p(
      "$etc_server_api/kv/put" => json => {
        key     => b64_encode($cron_key, ''),
        value   => b64_encode($dtime,    ''),
        prev_kv => true
      }
    )->then(sub ($tx) {
      my $swapped = b64_decode($tx->result->json('/prev_kv/value') || 'MA==');
      if ($dtime != $swapped) {
        app->log->warn(
          "*** Cron at $dtime (previous $swapped) from host $host, process $$");
      }
    });
  }
);

get '/' => sub ($c) {
  $c->render(text => 'Hello World!');
};

app->start;
