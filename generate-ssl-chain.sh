#!/bin/sh

# Generate the wildcard SSL certificate using the DNS method.

if [ "$#" -lt 1 ]; then
	echo "Usage: $0 <email>"
	exit 0
fi

DOMAIN="*.madlambda.io"
EMAIL="$1"
ACMESERVER="https://acme-v02.api.letsencrypt.org/directory"

if ! certbot certonly \
	--manual --preferred-challenges=dns --email $EMAIL \
	--server $ACMESERVER --agree-tos \
	-d $DOMAIN; then

	echo "failed to generate certificate chain"
	exit 1
fi

OUTDIR=/etc/letsencrypt/live/madlambda.io
cat $OUTDIR/privkey.pem $OUTDIR/fullchain.pem > $OUTDIR/unit-chain.pem

echo "Unit chain generated at: $OUTDIR/unit-chain.pem"
exit 0



