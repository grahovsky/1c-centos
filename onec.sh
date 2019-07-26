#!/bin/sh

DATABASE_NAME=${DATABASE_NAME:=test1c}
SERVER_NAME=${SERVER_NAME:=postgrespro}

export PATH="/opt/1C/v8.3/x86_64:${PATH}"

ragent -daemon
sleep 5

ras cluster --daemon
sleep 2

SERVER_ID=$(rac cluster list | awk 'NR==1{print $3}')

INFOBASES=$(rac infobase --cluster=$SERVER_ID summary list)
CREATED=$(echo "$INFOBASES" | grep "$DATABASE_NAME")

if [ -z "$INFOBASES" ] || [ -z "$CREATED" ]; then
    echo "server id : $SERVER_ID"
    
    rac infobase --cluster=$SERVER_ID create --create-database --name=$DATABASE_NAME \
    --dbms=PostgreSQL --db-server=$SERVER_NAME --db-name=$DATABASE_NAME \
    --locale=ru --db-user=postgres --db-pwd=postgres --license-distribution=allow
    echo "base created"
    
    echo "server name : $SERVER_NAME"
    echo "database name : $DATABASE_NAME"
    
else
    echo "base existed"
    echo "$INFOBASES"
fi

/bin/bash



