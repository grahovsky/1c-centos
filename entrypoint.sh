#!/bin/sh
set -e

AGENT_PORT=${AGENT_PORT:=1540}
MANAGER_PORT=${MANAGER_PORT:=1541}
RANGE_PORT_START=${RANGE_PORT_START:=1560}
RANGE_PORT_END=${RANGE_PORT_END:=1591}
RAS_PORT=${RAS_PORT:=1545}

DB_SERVER_NAME=${DB_SERVER_NAME:=postgrespro}
DB_SERVER_PORT=${DB_SERVER_PORT:=5432}
DB_NAME=${DB_NAME:=base-1c}
SERVER_NAME=${SERVER_NAME:=$HOSTNAME}
INFOBASE_NAME=${INFOBASE_NAME:=base-1c}

createbase() {

  ras cluster --port=$RAS_PORT --daemon localhost:$AGENT_PORT
  
  CLUSTER_ID=$(rac localhost:$RAS_PORT cluster list | awk 'NR==1{print $3}')
  
  rac localhost:$RAS_PORT cluster remove --cluster=$CLUSTER_ID
  rm -rf /home/usr1cv8/.1cv8/1C/1cv8
  
  rac localhost:$RAS_PORT cluster insert --name=1c --host=$HOSTNAME --port=$MANAGER_PORT
  CLUSTER_ID=$(rac localhost:$RAS_PORT cluster list | awk 'NR==1{print $3}')
  
  sleep 5
  
  rac localhost:$RAS_PORT infobase --cluster=$CLUSTER_ID create --create-database --name=$INFOBASE_NAME \
  --dbms=PostgreSQL --db-server=$DB_SERVER_NAME --db-name=$DB_NAME \
  --locale=ru --db-user=postgres --db-pwd=postgres --license-distribution=allow

}

if [ "$1" = 'ragent' ]; then
    
    echo "hostname: $HOSTNAME"
    #kill $(ps -ef | grep -E 'ragent|rmngr|rphost' | awk '{print $2}')
    rm -rf /home/usr1cv8/.1cv8/1C/1cv8
    ( sleep 30 ; createbase ) &
    ragent /port $AGENT_PORT /regport $MANAGER_PORT /range $RANGE_PORT_START:$RANGE_PORT_END

fi

exec "$@"



