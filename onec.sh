
#!/bin/sh

DATABASE_NAME=${DATABASE_NAME:=test1c}
SERVER_NAME=${SERVER_NAME:=postgrespro}

echo $DATABASE_NAME
echo $SERVER_NAME

export PATH="/opt/1C/v8.3/x86_64:${PATH}"

ragent -daemon
sleep 5

ras cluster --daemon
sleep 2

SERVER_ID=$(rac cluster list | awk 'NR==1{print $3}')
echo $SERVER_ID

rac infobase --cluster=$SERVER_ID create --create-database --name=$DATABASE_NAME \
--dbms=PostgreSQL --db-server=$SERVER_NAME --db-name=$DATABASE_NAME \
--locale=ru --db-user=postgres --db-pwd=postgres --license-distribution=allow

