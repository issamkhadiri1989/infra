vcl 4.1;

probe basic {
  .request =
    "GET /varnish-health HTTP/1.1"
    "Host: localhost"
    "Connection: close";

  .interval = 10s;
  .timeout = 2s;
  .window = 8;
  .threshold = 6;
  .initial = 5;
}

backend default {
  .host = "nginx";
  .port = "80";
  .max_connections = 100;
  .connect_timeout = 60s;
  .first_byte_timeout = 60s;
  .between_bytes_timeout = 60s;
  .probe = basic;
}

sub vcl_recv {
  if (req.method == "PURGE" || req.method == "BAN") {
    return (synth(405, "Not allowed"));
  }
}

sub vcl_hash {
  if (req.http.X-Forwarded-Proto) {
    hash_data(req.http.X-Forwarded-Proto);
  }
}

sub vcl_deliver {
  if (obj.hits > 0) {
    set resp.http.X-Varnish-Cache = "HIT";
  } else {
    set resp.http.X-Varnish-Cache = "MISS";
  }
}