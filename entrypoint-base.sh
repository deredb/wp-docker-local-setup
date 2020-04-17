#!/bin/bash

sed -i -e 's/^exec "$@"/#exec "$@"/g' /usr/local/bin/docker-entrypoint.sh
source /usr/local/bin/docker-entrypoint.sh


USER_ID=${LOCAL_USER_ID:-9001}
echo "Starting with UID : $USER_ID"

if id -u user >/dev/null 2>&1; then
    echo "User alreay exist"
    chown --recursive "$USER_ID" /var/www/html/

    exec "$@"
else 
    echo "User does not exist"
    useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
    export HOME=/home/user
    
    chown --recursive "$USER_ID" /var/www/html/
    exec /usr/local/bin/gosu user "$@"
fi




