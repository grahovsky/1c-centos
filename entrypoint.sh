#!/bin/sh
set -e

AGENT_PORT=${AGENT_PORT:=1540}
MANAGER_PORT=${MANAGER_PORT:=1541}
RANGE_PORT_START=${RANGE_PORT_START:=1560}
RANGE_PORT_END=${RANGE_PORT_END:=1591}

if [ "$1" = 'ragent' ]; then
    
    echo "hostname: $HOSTNAME"
    #kill $(ps -ef | grep -E 'ragent|rmngr|rphost' | awk '{print $2}')
    rm -rf /home/usr1cv8/.1cv8/1C/1cv8
    sh /tmp/onec.sh &
    ragent /port $AGENT_PORT /regport $MANAGER_PORT /range $RANGE_PORT_START:$RANGE_PORT_END

fi

exec "$@"


