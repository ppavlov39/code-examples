#!/bin/bash
EXPIRES=`/usr/lib/zabbix/externalscripts/get-ssl-expires-timestamp.sh $1`
NOW=`date +%s`
let "SECONDS_LEFT = EXPIRES - NOW"
echo $SECONDS_LEFT
exit 0;
