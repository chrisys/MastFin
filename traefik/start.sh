#!/bin/sh

traefik --docker --logLevel="INFO" --traefikLog.filePath="/dev/console" --accessLog.filePath="/dev/console"