#!/bin/sh

DB_SERVER_NAME=${DB_SERVER_NAME:=postgrespro}
DB_SERVER_PORT=${DB_SERVER_PORT:=5432}
DB_NAME=${DB_NAME:=test1c}
INFOBASE_NAME=${INFOBASE_NAME:=test1c}

sleep 30
ras cluster --port=31545 --daemon localhost:31540

CLUSTER_ID=$(rac localhost:31545 cluster list | awk 'NR==1{print $3}')

rac localhost:31545 cluster remove --cluster=$CLUSTER_ID
rm -rf /home/usr1cv8/.1cv8/1C/1cv8

rac localhost:31545 cluster insert --name=1c --host=$HOSTNAME --port=31541
CLUSTER_ID=$(rac localhost:31545 cluster list | awk 'NR==1{print $3}')

sleep 5

rac localhost:31545 infobase --cluster=$CLUSTER_ID create --create-database --name=$INFOBASE_NAME \
--dbms=PostgreSQL --db-server=$DB_SERVER_NAME --db-name=$DB_NAME \
--locale=ru --db-user=postgres --db-pwd=postgres --license-distribution=allow