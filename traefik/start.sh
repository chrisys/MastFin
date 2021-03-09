#!/usr/bin/env bash
set -e

# Check if service has been disabled through the DISABLED_SERVICES environment variable.

if [[ ",$(echo -e "${DISABLED_SERVICES}" | tr -d '[:space:]')," = *",$BALENA_SERVICE_NAME,"* ]]; then
        echo "$BALENA_SERVICE_NAME is manually disabled."
        sleep infinity
fi

# Start traefik and put it in the background.
traefik --providers.docker="true" --providers.docker.exposedbydefault="false" --entrypoints.web.address=:"80" --log.level="ERROR" --log.filepath="/dev/console" --accesslog.filepath="/dev/console" --global.sendAnonymousUsage="false" &

# Wait for any services to exit.
wait -n