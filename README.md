#Pushjet Docker
[![Build Status](https://drone.darkzone.tech/api/badges/adminfromhell/pushjet-docker/status.svg)](https://drone.darkzone.tech/adminfromhell/pushjet-docker)<br/>
Dockerized image of [PushJet](http://pushjet.io) server

example: docker run --rm -it --name pushjet -p 8000:8000 -e MYSQL_PASS=password -e MYSQL_HOST=mysql --link mysql:mysql adminfromhell/pushjet

Environment Variables:
MYSQL_USER="root"
MYSQL_PASS="password"
MYSQL_HOST="mysql"
MYSQL_PORT="3306"
GOOGLE_API_KEY="123"
GOOGLE_SENDER_ID="123"
ZEROMQ_RELAY="ipc:///tmp/pushjet-relay.ipc"

Dockerfile is here: [Github - PushJet Docker](https://github.com/adminfromhell/pushjet-docker)
