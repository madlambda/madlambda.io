#!/bin/sh

trap "echo TRAPed signal" HUP INT QUIT TERM

# start service in background here
/work/Linux/386/bin/emu -g $WINRES /usr/inferno/setup-auth.sh $DOMAIN $WINRES $TZ

echo "Closing container..."

