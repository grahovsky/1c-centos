FROM centos:centos7
#MAINTAINER "grahovsky" <grahovsky@gmail.com>

#Environment Variables
ARG AGENT_PORT=1540
ENV AGENT_PORT=$AGENT_PORT

ARG MANAGER_PORT=1541
ENV MANAGER_PORT=$MANAGER_PORT

ARG RAS_PORT=1541
ENV RAS_PORT=$RAS_PORT

ARG RANGE_PORT_START=1560
ENV RANGE_PORT_START=$RANGE_PORT_START

ARG RANGE_PORT_END=1591
ENV RANGE_PORT_END=$RANGE_PORT_END

#OKD
ENV OKD_USER_ID 1001080000

RUN groupadd -f --gid $OKD_USER_ID grp1cv8 && \
    useradd --uid $OKD_USER_ID --gid $OKD_USER_ID --comment '1C Enterprise 8 server launcher' --no-log-init --home-dir /home/usr1cv8 usr1cv8

# Perform updates

RUN yum -y update; yum clean all

# Install EPEL
RUN yum -y install epel-release; yum clean all

# Install Microsoft's Core Fonts
RUN yum -y install curl cabextract xorg-x11-font-utils fontconfig; yum clean all
#RUN rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

#ADD msttcore-fonts-installer-2.6-1.noarch.rpm /tmp/
#RUN rpm -Uvh /tmp/*.rpm

# Install ImageMagick
RUN yum -y install ImageMagick; yum clean all

ADD rpm/*.rpm /tmp/
RUN rpm -Uvh /tmp/*.rpm

RUN mkdir -p /opt/1C/v8.3/x86_64/conf/
COPY config/logcfg.xml /opt/1C/v8.3/x86_64/conf/
RUN chown -R usr1cv8:grp1cv8 /opt/1C

RUN mkdir -p /var/log/1c/dumps/
RUN chown -R usr1cv8:grp1cv8 /var/log/1c/
RUN chmod 755 /var/log/1c

COPY config/srv1cv83 /etc/sysconfig/

ENV PATH="/opt/1C/v8.3/x86_64:${PATH}"

RUN echo 'root' | passwd root --stdin

#COPY docker-entrypoint.sh /

#VOLUME /home/usr1cv8
VOLUME /var/log/1C

#ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE $AGENT_PORT $MANAGER_PORT $RASPORT $RANGE_PORT_START-$RANGE_PORT_END

#ENTRYPOINT /opt/1C/v8.3/x86_64/ragent -daemon -port 2540 -regport 2541 -range 2560:2591
#ENTRYPOINT ["/opt/1C/v8.3/x86_64/ragent /daemon /port 2540 /regport 2541 /range 2560:2591"]

RUN echo "DisableUnsafeActionProtection=.*" >> /opt/1C/v8.3/x86_64/conf/conf.cfg
RUN chown -R usr1cv8:grp1cv8 /opt/1C
RUN chmod -R 777 /opt/1C

#fonts msttcore-fonts-installer-2.6-1.noarch.rpm - error
ADD fonts/* /home/usr1cv8/.fonts/
RUN chown -R usr1cv8:grp1cv8 /home/usr1cv8/.fonts
RUN fc-cache -fv

USER usr1cv8

#CMD /opt/1C/v8.3/x86_64/ragent
#ENTRYPOINT ["/opt/1C/v8.3/x86_64/ragent"]

#ADD onec.sh /tmp/
#ENTRYPOINT ["/bin/sh", "/tmp/onec.sh"]
Add entrypoint.sh /tmp/
Add onec.sh /tmp/

ENTRYPOINT ["/bin/sh", "-x", "/tmp/entrypoint.sh"]
CMD ["ragent"]
