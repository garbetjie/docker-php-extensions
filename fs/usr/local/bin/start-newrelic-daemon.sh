#!/usr/bin/env dash

# If New Relic is disabled, then don't do anything.
if [ "$NEWRELIC_ENABLED" != true ] || [ ! -x /opt/newrelic/daemon.x64 ]; then
  exit 0
fi

# If there is a ":" in the daemon's address, then it means we're connecting to a remote daemon, and we shouldn't start it
# locally. If this is the case, then we can assume that we don't require the daemon to be "primed" with an initial PHP
# call.
if echo "$NEWRELIC_DAEMON_PORT" | grep ":"; then
  exit 0
fi

# Start the daemon, and wait 3s (the default) for it to be started and listening on the local socket.
/opt/newrelic/daemon.x64 -c /opt/newrelic/newrelic.cfg --wait-for-port 3s

# Now that the daemon is running, we need to execute a PHP script to start the connection process for the daemon.
# We'll wait a specific amount of time for this to finish (until there's a better way to know whether an app is connected,
# sleeping is the best way).
# Ideally, $NEWRELIC_DAEMON_WAIT should be set to a duration in which your app will be able to connect to New Relic's
# servers. The faster your connection, the less this duration can be.
if [ "$NEWRELIC_DAEMON_WAIT" = "" ]; then
  NEWRELIC_DAEMON_WAIT=5
fi

# Start the throwaway process used to connect the daemon to collector.newrelic.com
php -i 1>/dev/null 2>&1

# Wait for it to connect.
sleep $NEWRELIC_DAEMON_WAIT
