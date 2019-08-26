#!/bin/sh
set -e

if [ "$1" = 'ragent' ]; then

    #kill $(ps -ef | grep -E 'ragent|rmngr|rphost' | awk '{print $2}')
    rm -rf /home/usr1cv8/.1cv8/1C/1cv8
    sh /tmp/onec.sh &
    ragent /port 31540 /regport 31541 /range 31560:31591

fi

exec "$@"


