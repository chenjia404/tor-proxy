#!/bin/sh
set -eu

/usr/bin/tor -f /etc/tor/torrc &
tor_pid=$!

privoxy --no-daemon --pidfile /run/privoxy/privoxy.pid /etc/privoxy/config &
privoxy_pid=$!

term_handler() {
  kill -TERM "$tor_pid" "$privoxy_pid" 2>/dev/null || true
  wait "$tor_pid" "$privoxy_pid" 2>/dev/null || true
}

trap term_handler INT TERM

wait -n "$tor_pid" "$privoxy_pid"
exit_code=$?
term_handler
exit "$exit_code"
