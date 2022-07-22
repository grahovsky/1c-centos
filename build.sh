#!/bin/bash

docker build --tag grahovsky/server-1c:8.3.18.1698 \
    --build-arg AGENT_PORT=1540 \
    --build-arg MANAGER_PORT=1541 \
    --build-arg RAS_PORT=1545 \
    --build-arg RAGENT_PORT=1560 \
    --build-arg ONEC_VERSION='8.3.18.1698' \
    $1 -- .
