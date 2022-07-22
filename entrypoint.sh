#!/bin/sh
set -e

AGENT_PORT=${AGENT_PORT:=1540}
MANAGER_PORT=${MANAGER_PORT:=1541}
RAS_PORT=${RAS_PORT:=1545}
RAGENT_PORT=${RAGENT_PORT:=1560}

DB_SERVER_NAME=${DB_SERVER_NAME:=postgresql}
DB_SERVER_PORT=${DB_SERVER_PORT:=5432}
DB_NAME=${DB_NAME:=base-1c}
DB_USER_NAME=${DB_USER_NAME:=postgres}
DB_USER_PASSWORD=${DB_USER_PASSWORD:=postgres}

SERVER_NAME=${SERVER_NAME:=server-1c}
INFOBASE_NAME=${INFOBASE_NAME:=base-1c}

startRas() {
  ras cluster --port=$RAS_PORT --daemon localhost:$AGENT_PORT
}

initServer() { 
  CLUSTER_ID=$(rac localhost:$RAS_PORT cluster list | awk 'NR==1{print $3}')

  rac localhost:$RAS_PORT cluster remove --cluster=$CLUSTER_ID
  rm -rf /home/usr1cv8/.1cv8/1C/1cv8
  
  rac localhost:$RAS_PORT cluster insert --name=$SERVER_NAME --host=$HOSTNAME --port=$MANAGER_PORT
}

initBase() {
  CLUSTER_ID=$(rac localhost:$RAS_PORT cluster list | awk 'NR==1{print $3}')

  rac localhost:$RAS_PORT infobase --cluster=$CLUSTER_ID create --create-database --name=$INFOBASE_NAME \
  --dbms=PostgreSQL --db-server=$DB_SERVER_NAME --db-name=$DB_NAME \
  --locale=ru --db-user=$DB_USER_NAME --db-pwd=$DB_USER_PASSWORD --license-distribution=allow
}

if [ -n "$HOSTNAME_STATIC" ]; then
  echo "hostname static: $HOSTNAME_STATIC"
  sudo /usr/bin/chmod 777 /etc/hostname
  echo $HOSTNAME_STATIC > /etc/hostname
  HOSTNAME=$HOSTNAME_STATIC
fi

if [ -n "$RAS_PORT" ]; then
  ( sleep 15; startRas ) &
fi

if [ -n "$INIT_SEVER" ]; then
  ( sleep 20 ; initServer ) &
fi

if [ -n "$INIT_BASE" ]; then
  ( sleep 25 ; startRas ) &
fi

if [ "$1" = 'ragent' ]; then
  echo "hostname: $HOSTNAME"
  ragent /port $AGENT_PORT /regport $MANAGER_PORT /range $RAGENT_PORT
fi

exec "$@"



