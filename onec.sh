#!/bin/sh

DB_SERVER_NAME=${DB_SERVER_NAME:=postgrespro}
DB_SERVER_PORT=${DB_SERVER_PORT:=5432}
DB_NAME=${DB_NAME:=test1c}
INFOBASE_NAME=${INFOBASE_NAME:=test1c}

sleep 30
ras cluster --daemon

CLUSTER_ID=$(rac cluster list | awk 'NR==1{print $3}')

rac infobase --cluster=$CLUSTER_ID create --create-database --name=$INFOBASE_NAME \
--dbms=PostgreSQL --db-server=$DB_SERVER_NAME --db-name=$DB_NAME \
--locale=ru --db-user=postgres --db-pwd=postgres --license-distribution=allow