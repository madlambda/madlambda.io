#!/bin/sh

if ! which jq >/dev/null; then
	echo "jq is required. Aborting..."
	exit 1
fi

. /etc/default/unit

UNITPID=/var/run/unit.pid
UNITSOCK=$UNITDIR/control.unit.sock

if [ ! -f $UNITPID ]; then
	echo "Unit is not running (File not found $UNITPID)"
	exit 1
fi

if [ ! -S $UNITSOCK ]; then
	echo "Socket file is not at $UNITSOCK"
	exit 1
fi

CURL="curl --silent --unix-socket $UNITSOCK"

# test control socket connectivity
if ! $CURL 127.0/ | jq -e ".config" >/dev/null; then
	echo "failed to get Unit config"
	exit 1
fi

# apply basic config structure
if ! $CURL -XPUT 127.0/config --data-binary @./unit/config.json | \
	jq -e ".success" >/dev/null; then

	echo "failed to set basic config"
	exit 1
fi

cd unit/apps

for name in $(ls); do
        echo "Applying app config: $name"

        if ! $CURL -XPUT "127.0/config/applications/$name" --data-binary \
                "@./$name/config.json" | jq -e ".success" >/dev/null; then

                echo "failed to apply application $name"
                exit 1
        fi
done

cd ../routes.d

for file in $(ls *.json); do
	if ! $CURL -XPOST 127.0/config/routes --data-binary "@$file" | \
		jq -e ".success" >/dev/null; then

		echo "failed to apply route: unit/routes.d/$file"
		exit 1
	fi
done

$CURL 127.0/
echo "Unit configured"
