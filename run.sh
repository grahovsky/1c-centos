#!/bin/sh
docker run --name onec-centos7 \
  --detach \
  --net my_app_net \
  -p 1540-1541:1540-1541 \
  -p 1560-1591:1560-1591 \
  -p 1545:1545 \
  --privileged \
  --volume c:/docker/data/1c-server-home:/home/usr1cv8 \
  --volume c:/docker/data/1c-server-logs:/var/log/1C \
  grahovsky/onec-centos7

#--net host \
#--net my_app_net \
#--volume /etc/localtime:/etc/localtime:ro \
#--user usr1cv8 \
#-p 2540-2541:2540-2541 \
#-p 2560-2591:2560-2591 \
#-p 1545:1545 \
