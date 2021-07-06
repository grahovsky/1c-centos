FROM alpine:latest as prepare

ARG ONEC_USERNAME
ARG ONEC_PASSWORD
ARG ONEC_VERSION
ENV installer_type=server

WORKDIR /tmp

RUN apk --no-cache add bash curl grep

COPY ./download.sh /download.sh
RUN chmod +x /download.sh \
  && sync; /download.sh

RUN for file in *.tar.gz; do tar -zxf "$file"; done \
  && rm -rf *-nls-* *-ws-* \
  && rm -rf *.tar.gz

COPY distr/fonts.tar.gz fonts.tar.gz

RUN tar xzf fonts.tar.gz

FROM centos:centos7 as base
#MAINTAINER "grahovsky" <grahovsky@gmail.com>

# locale
ENV LANG ru_RU.utf8
RUN localedef -f UTF-8 -i ru_RU ru_RU.UTF-8

# install epel
RUN yum -y update; yum -y install epel-release; yum clean all

# install dependences
RUN yum -y update ; \
    yum -y install fontconfig \
    ImageMagick \
    xorg-x11-font-utils \
    cabextract \
    ;yum clean all
    
    # curl \
    # sudo \ only for /etc/hostname
 
# create user with specific id for okd
ARG OKD_USER_ID=1001080000
ENV OKD_USER_ID=$OKD_USER_ID
RUN groupadd -f --gid $OKD_USER_ID grp1cv8 && \
    useradd --uid $OKD_USER_ID --gid $OKD_USER_ID --comment '1C Enterprise 8 server launcher' --no-log-init --home-dir /home/usr1cv8 usr1cv8

# add rpm
COPY --from=prepare /tmp/*.rpm /tmp/
# install 1c
RUN yum localinstall -y /tmp/*.rpm && yum clean all

# install fonts
#RUN rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
COPY --from=prepare /tmp/fonts/* /home/usr1cv8/.fonts/

# Add config 1c
COPY config/logcfg.xml /opt/1C/v8.3/x86_64/conf/
COPY config/srv1cv83 /etc/sysconfig/
RUN echo "DisableUnsafeActionProtection=.*" >> /opt/1C/v8.3/x86_64/conf/conf.cfg

# Add path 1cv8
ENV PATH="/opt/1C/v8.3/x86_64:${PATH}"

# Add directory and premission
RUN mkdir -p /opt/1C/v8.3/x86_64/conf/ && \
    mkdir -p /var/log/1c/dumps/ && chown -R usr1cv8:grp1cv8 /var/log/1c/ && chmod 755 /var/log/1c && \
    chown -R usr1cv8:grp1cv8 /home/usr1cv8/.fonts && fc-cache -fv

# set rootpass for debug
#RUN echo 'root' | passwd root --stdin

# add sudo permissions for change hostname
#RUN echo "usr1cv8 ALL=(root) NOPASSWD: /usr/bin/chmod" >> /etc/sudoers

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

# expose ports
EXPOSE $AGENT_PORT $MANAGER_PORT $RASPORT $RANGE_PORT_START-$RANGE_PORT_END

#VOLUME /home/usr1cv8
VOLUME /var/log/1C

COPY entrypoint.sh /tmp/

USER usr1cv8

ENTRYPOINT ["/bin/sh", "-x", "/tmp/entrypoint.sh"]
CMD ["ragent"]
