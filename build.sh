#!/bin/bash

docker build --tag grahovsky/server-onec:latest --build-arg AGENT_PORT=1540 --build-arg MANAGER_PORT=1541 --build-arg RAS_PORT=1545 --build-arg RANGE_PORT_START=1560 --build-arg RANGE_PORT_END=1591 $1 -- .
