#!/bin/sh
envsubst < /etc/pfclient-config.json.tpl> /etc/pfclient-config.json
/usr/bin/pfclient --config_path=/etc/pfclient-config.json --log_path=/dev/console
