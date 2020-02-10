#!/bin/sh

if ! which jq >/dev/null; then
	echo "jq is required. Aborting..."
	exit 1
fi

. /etc/default/unit

UNITPID=/var/run/unit.pid
UNITSOCK=$UNITDIR/control.unit.sock
CERTFILE=/etc/letsencrypt/live/madlambda.io/unit-chain.pem

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
OUT=$($CURL -XPUT 127.0/config --data-binary @./unit/config.json)
if ! echo "$OUT" | jq -e ".success" >/dev/null; then
	echo "failed to set basic config: $OUT"
	echo "Logs at /var/log/unit.log"
	exit 1
fi

# add TLS/SSL certificates
if ! $CURL -XGET 127.0/certificates/madlambda.io | jq -e ".chain" >/dev/null; then
	OUT=$($CURL -XPUT 127.0/certificates/madlambda.io --data-binary "@$CERTFILE")
	if ! echo "$OUT" | jq -e ".success" >/dev/null; then
		echo "failed to apply TLS/SSL certificates: $OUT"
		echo "Is Unit compiled with SSL support?"
		exit 1
	fi
fi

cat > tls.json << EOF
{
	"certificate": "madlambda.io",
	"protocols": ["SSLv2", "SSLv3", "TLSv1.2", "TLSv1.3"],
	"ciphers": "HIGH:!aNULL:!MD5"
}
EOF

if ! $CURL -XPUT '127.0/config/listeners/*:443/tls' \
		--data-binary @tls.json | jq -e ".success"; then

	echo "failed to apply certificate to listener *:443"
	exit 1
fi

rm -f tls.json

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
