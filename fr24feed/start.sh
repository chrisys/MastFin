#!/usr/bin/env bash
set -e

# Check if service has been disabled through the DISABLED_SERVICES environment variable.

if [[ ",$(echo -e "${DISABLED_SERVICES}" | tr -d '[:space:]')," = *",$BALENA_SERVICE_NAME,"* ]]; then
        echo "$BALENA_SERVICE_NAME is manually disabled."
        sleep infinity
fi

# Verify that all the required varibles are set before starting up the application.

echo "Verifying settings..."
echo " "
sleep 2

missing_variables=false

# Begin defining all the required configuration variables.

[ -z "$FR24_KEY" ] && echo "Flightradar24 key is missing, will abort startup." && missing_variables=true || echo "Flightradar24 key is set: $FR24_KEY"
[ -z "$LAT" ] && echo "Receiver latitude is missing, will abort startup." && missing_variables=true || echo "Receiver latitude is set: $LAT"
[ -z "$LON" ] && echo "Receiver longitude is missing, will abort startup." && missing_variables=true || echo "Receiver longitude is set: $LON"
[ -z "$RECEIVER_HOST" ] && echo "Receiver host is missing, will abort startup." && missing_variables=true || echo "Receiver host is set: $RECEIVER_HOST"
[ -z "$RECEIVER_PORT" ] && echo "Receiver port is missing, will abort startup." && missing_variables=true || echo "Receiver port is set: $RECEIVER_PORT"

# End defining all the required configuration variables.

echo " "

if [ "$missing_variables" = true ]
then
        echo "Settings missing, aborting..."
        echo " "
        sleep infinity
fi

echo "Settings verified, proceeding with startup."
echo " "

# Variables are verified – continue with startup procedure.

# Write settings to config file and set permissions.
envsubst < /etc/fr24feed.ini.tpl > /etc/fr24feed.ini
chmod a+rw /etc/fr24feed.ini

# Start fr24feed and put it in the background.
/usr/bin/fr24feed &

# Wait for any services to exit.
wait -n