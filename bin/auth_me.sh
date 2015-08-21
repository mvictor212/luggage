#!/bin/bash

findfile() {
  for f in $*; do
    if [ -f "$f" ]; then
      echo $f
      return 0
    fi
  done
  echo "Unable to find ssh public key in $*" 1>&2
  exit 1
}

if [ -z "$1" ]; then
  echo "Usage: $0 user@host [path/to/key-to-auth-with.pub]" 1>&2
  exit 1
fi
if [ -z "$2" ]; then
  PUB_KEYFILE=$(findfile ~/.ssh/id_{d,r}sa.pub)
else
  PUB_KEYFILE="$2"
fi

if [ -z "$3" ]; then
  AUTH_KEYFILE=$(dirname "$PUB_KEYFILE")/$(basename "$PUB_KEYFILE" .pub)
else
  AUTH_KEYFILE="$3"
fi

ssh $1 -i "$AUTH_KEYFILE" "mkdir -p .ssh; echo '$(cat $PUB_KEYFILE)' >> .ssh/authorized_keys; chmod 600 .ssh/authorized_keys; chmod 700 .ssh"
