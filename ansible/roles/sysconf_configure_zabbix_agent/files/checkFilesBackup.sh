#!/bin/bash
set -e -o pipefail

if test $(find /tmp/backup_file_transfer.log -mmin -1440); then
  TRANSFERED_BYTES=$(tail -n 16 /tmp/backup_file_transfer.log | grep 'Total bytes received' | cut -d' ' -f 4 | tr -d ',')
  if [[ ! "$TRANSFERED_BYTES" == "" ]]; then
    echo "$TRANSFERED_BYTES" > /tmp/rsync_transfered_bytes.txt
  fi

  if [[ ! -f "/tmp/rsync_transfered_bytes.txt" ]]; then
    touch /tmp/rsync_transfered_bytes.txt
  fi

  STORED_TRANSFERED_BYTES=$(cat /tmp/rsync_transfered_bytes.txt)
  if [[ "$STORED_TRANSFERED_BYTES" == "" ]]; then
    echo "0"
  else
    echo "$STORED_TRANSFERED_BYTES"
  fi
else
  echo "1"
fi

