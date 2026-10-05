FROM varnish:9.1.0

COPY custom.vcl /etc/varnish/default.vcl

CMD ["varnishd", "-F", "-a", ":6081", "-f", "/etc/varnish/default.vcl", "-s", "malloc,256m"]