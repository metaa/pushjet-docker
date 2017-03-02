FROM alpine:latest
MAINTAINER Buck Brady <bbrady@mythic.tech>
ARG VCS_REF

LABEL Description="PushJet Server" \
      Vendor="Mythic Tech" Version="0.1" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/adminfromhell/pushjet-docker"


# install git so we can get src code & install mysql-client so we can create the database
# install python
# install gunicorn
# Create the directory structures that we need
# get the source code fr PushJet
RUN apk add mariadb-client mariadb-client-libs --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/main/ --allow-untrusted \
    && apk add --no-cache git python zeromq \
    && apk add --no-cache --virtual .build-deps gcc g++ python-dev mariadb-dev zeromq-dev \
    && python -m ensurepip \
    && rm -r /usr/lib/python*/ensurepip \
    && pip install --upgrade pip setuptools \
    && rm -r /root/.cache \
    && pip install gunicorn \
    && mkdir -p /srv/http && mkdir -p /etc/gunicorn.d \
    && git clone https://github.com/Pushjet/Pushjet-Server-Api/ /srv/http/api.pushjet.io \
    && pip install -r /srv/http/api.pushjet.io/requirements.txt \
    && apk del --no-cache .build-deps \
    && rm -rf /var/cache/apk/*

# Set the ENV variables that we need for the entrypoint
ENV MYSQL_USER="root" MYSQL_PASS="password" MYSQL_HOST="mysql" \
    MYSQL_PORT="3306" GOOGLE_API_KEY="123" GOOGLE_SENDER_ID="123" \
    PUSHJET_DIR="/srv/http/api.pushjet.io" ZEROMQ_RELAY="ipc:///tmp/pushjet-relay.ipc"

# Copy pushjet config to correct location
COPY pushjet/pushjet.config /srv/http/api.pushjet.io/config.py

# Copy gunicorn config for pushjet
COPY pushjet/gunicorn-config /etc/gunicorn.d/pushjet-api

# Copy the entrypoint into the build
COPY pushjet/pushjet.sh /root/pushjet.sh
# Make sure it is executable
RUN chmod +x /root/pushjet.sh

ENTRYPOINT ["/bin/sh", "/root/pushjet.sh"]
