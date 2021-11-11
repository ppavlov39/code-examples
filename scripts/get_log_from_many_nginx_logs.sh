#!/bin/bash

if [[ -z $1 ]]; then
    echo "Enter domain name!"
    exit 1;
else
    DOMAIN=$1
fi

echo "" > /tmp/${DOMAIN}.log

SERVERS="LIST OF SERVERS"
UNCOMPRESS_LOG_FILES="access.log access.log.1"

for SERVER in $SERVERS; do
    LOG_PATH="/logs/$SERVER/logs/nginx/"
    for UNCOMPRESS_LOG_FILE in $UNCOMPRESS_LOG_FILES; do
        if [[ -f ${LOG_PATH}${UNCOMPRESS_LOG_FILE} ]]; then
            echo "Processing file ${LOG_PATH}${UNCOMPRESS_LOG_FILE}"
            cat ${LOG_PATH}${UNCOMPRESS_LOG_FILE} | grep "${DOMAIN}" | grep "something_interesting" >> /tmp/${DOMAIN}.log
        fi
    done
    COMPRESSED_LOG_FILES="$(ls ${LOG_PATH} | grep -e '^access.log.*.gz$\|^access_some.log.*.gz$')"
    for COMPRESSED_LOG_FILE in $COMPRESSED_LOG_FILES; do
        if [[ -f ${LOG_PATH}${COMPRESSED_LOG_FILE} ]]; then
            echo "Processing file ${LOG_PATH}${COMPRESSED_LOG_FILE}"
            zcat ${LOG_PATH}${COMPRESSED_LOG_FILE} | grep "${DOMAIN}"  | grep "something_interesting" >> /tmp/${DOMAIN}.log
        fi
    done
done

echo "" > ./${DOMAIN}.log
cat /tmp/${DOMAIN}.log | uniq | sort > ./${DOMAIN}.log
rm -f /tmp/${DOMAIN}.log
