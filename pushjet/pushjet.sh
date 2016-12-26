#!/bin/sh

# Need a lockfile so we dont try to initilize the database if we restart
LOCKFILE="/root/db_init_done"
PUSHJET_DIR="/srv/http/api.pushjet.io"

echo "Database settings are:"
echo "MYSQL_USER: ${MYSQL_USER}"
echo "MYSQL_PASS: ${MYSQL_PASS}"
echo "MYSQL_HOST: ${MYSQL_HOST}"
echo "MYSQL_PORT: ${MYSQL_PORT}"

echo "Setting config.py settings"
# Setup all the ENV variables
## MySQL
sed -i -e "s/MYSQL_USER/${MYSQL_USER}/" $PUSHJET_DIR/config.py
sed -i -e "s/MYSQL_PASS/${MYSQL_PASS}/" $PUSHJET_DIR/config.py
sed -i -e "s/MYSQL_HOST/${MYSQL_HOST}/" $PUSHJET_DIR/config.py
sed -i -e "s/MYSQL_PORT/${MYSQL_PORT}/" $PUSHJET_DIR/config.py

## Google API key
sed -i -e "s/GOOGLE_API_KEY/${GOOGLE_API_KEY}/" $PUSHJET_DIR/config.py
sed -i -e "s/GOOGLE_SENDER_ID/${GOOGLE_SENDER_ID}/" $PUSHJET_DIR/config.py

## ZeroMQ
sed -i -e "s@ZEROMQ_RELAY@${ZEROMQ_RELAY}@" $PUSHJET_DIR/config.py

# Create the MySQL database if we havent already
if [ ! -f $LOCKFILE ]; then
  dbinfo=`grep -i database_uri ${PUSHJET_DIR}/config.py`
  echo "Creating database on: ${dbinfo}"
  mysql -h ${MYSQL_HOST} -u${MYSQL_USER} -p${MYSQL_PASS} -e "create database pushjet_api;"
  cat $PUSHJET_DIR/database.sql | mysql -h ${MYSQL_HOST} -u${MYSQL_USER} -p${MYSQL_PASS} -D pushjet_api
fi

cd $PUSHJET_DIR && /usr/bin/gunicorn -b 0.0.0.0:8000 -w 4 --timeout=30 application:app
