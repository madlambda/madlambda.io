#!/bin/sh

UNITDIR=/usr/local/unit
export PATH=$UNITDIR/sbin:$PATH

if [ ! -x "$UNITDIR/sbin/unitd" ]; then
	echo "Unit is not installed at $UNITDIR"
	exit 1
fi

if ! mkdir -p /etc/default; then
	echo "failed to create /etc/default"
	exit 1
fi

if ! cp etc/unit.default /etc/default/unit; then
	echo "failed to copy unit defaults"
	exit 1
fi

if ! cp systemd/unit.service /etc/systemd/system/unit.service; then
	echo "failed to copy unit.service to /etc/systemd/system"
	exit 1
fi

chmod 664 /etc/systemd/system/unit.service

if ! systemctl enable unit.service; then
	echo "failed to enable systemd service"
	exit 1
fi

systemctl daemon-reload

if ! mkdir -p /var/www; then
	echo "failed to create /var/www"
	exit 1
fi

if ! cp -r www/* /var/www; then
	echo "failed to copy www files"
	exit 1
fi

if ! chown -R nobody:nogroup /var/www; then 
	echo "failed to change user and group of /var/www"
	exit 1
fi

echo "services installed"
exit 0


