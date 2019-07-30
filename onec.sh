#!/bin/sh

DB_SERVER_NAME=${DB_SERVER_NAME:=postgrespro}
DB_SERVER_PORT=${DB_SERVER_PORT:=5432}
DB_NAME=${DB_NAME:=test1c}
INFOBASE_NAME=${INFOBASE_NAME:=test1c}

export PATH="/opt/1C/v8.3/x86_64:${PATH}"

ragent -daemon
sleep 30

ras cluster --daemon
sleep 10

CLUSTER_ID=$(rac cluster list | awk 'NR==1{print $3}')

INFOBASES=$(rac infobase --cluster=$CLUSTER_ID summary list)
CREATED=$(echo "$INFOBASES" | grep "$INFOBASE_NAME")

if [ -z "$INFOBASES" ] || [ -z "$CREATED" ]; then
    
    rac cluster remove --cluster=$CLUSTER_ID
    rm -rf /home/usr1cv8/.1cv8/1C/1cv8

    rac cluster insert --name=1c --host=onec --port=1541 1> /dev/null
    CLUSTER_ID=$(rac cluster list | awk 'NR==1{print $3}')

    echo "cluster id : $CLUSTER_ID"
    sleep 5

    rac infobase --cluster=$CLUSTER_ID create --create-database --name=$INFOBASE_NAME \
    --dbms=PostgreSQL --db-server=$DB_SERVER_NAME --db-name=$DB_NAME \
    --locale=ru --db-user=postgres --db-pwd=postgres --license-distribution=allow
    echo "base created"
    
    echo "server name : $DB_SERVER_NAME"
    echo "database name : $DB_NAME"
    echo "infobase name : $INFOBASE_NAME" 
    
else
    echo "base existed"
    echo "$INFOBASES"
fi

/bin/bash



