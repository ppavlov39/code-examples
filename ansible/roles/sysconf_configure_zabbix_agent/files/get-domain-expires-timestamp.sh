#!/bin/bash

if [ -z $1 ] || [ -z $2 ]; then
  echo "Enter mode and domain name"
  exit 1
fi

MODE=$1
DOMAIN=$2
NOW=`date +%s`

EXPIREDATE=$(whois $DOMAIN | egrep 'Expiration Date|paid-till' | head -1)
EXPIREDATE=${EXPIREDATE##* }
TIMESTAMP=$(date -d"$EXPIREDATE" +%s)

let "SECONDS_LEFT = TIMESTAMP - NOW"

if [ "$MODE" == "-l" ]; then
  echo $SECONDS_LEFT
elif [ "$MODE" == "-e" ]; then
  echo $TIMESTAMP
else
  echo $TIMESTAMP
fi

exit 0;
