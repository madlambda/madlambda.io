#!/dis/sh.dis

domain=$1
winres=$2
tz=$3

echo 'Configuring signer.'

bind /locale/$tz /locale/timezone

echo '!!! You are about to reset the auth keys file.'
echo 'Press ENTER to continue or CTRL-C to abort'
read

cp /dev/null /keydb/keys
chmod 600 /keydb/keys
echo 'Generating certificates for ' $domain '...'
auth/createsignerkey $domain

svc/auth

echo 'services running:'

ps

# Sleep
echo 'Press any key to get shell'
read

sh

echo 'exiting'