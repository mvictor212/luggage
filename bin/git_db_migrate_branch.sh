#!/bin/bash

if [ "$1" == "" ]; then
  echo "Usage: $0 <TO_BRANCH>"
  exit 1
fi

if [ "`sed --help | grep regexp-extended`" == "" ]; then
  # DARWIN style
  SED_REGEX_FLAG="-E"
else
  SED_REGEX_FLAG="-r"
fi

all_migrations() {
  ls -w1 db/migrate
}

all_versions () {
  all_migrations | sed $SED_REGEX_FLAG 's/([0-9]+)_.+/\1/'
}

get_last_version () {
  git diff HEAD..$1 db/migrate | egrep '^diff' | cut -f 3 -d " " | sed $SED_REGEX_FLAG 's/a\/db\/migrate\/([0-9]+)_.+/\1/' | sort | head -n 1
}

get_versions () {
  target="$!"
  operator=${2:--gt}

  if [ "$1" == "" ]; then
    echo "Oops - nil passed in to get_versions" 1>&2
    exit 1
  fi

  all_versions | while read version; do [ "$version" $operator "$1" ] && echo $version; done
}

migration_name () {
  ls -w1 db/migrate | egrep "^${1}_"
}

BRANCH="$1"
last_version=`get_last_version "$BRANCH"`

if [ "$last_version" == "" ]; then
  echo "No migrations have changed from HEAD to $BRANCH"
  exit
fi

version_before_last=`get_versions "$last_version" -lt | tail -n 1` 
cmd="rake db:migrate VERSION=$version_before_last"

echo -n "Earliest changed migration on $BRANCH: $last_version
Lastest version before that on current branch: $version_before_last (`migration_name "$version_before_last"`)

This will undo the following migrations (assuming you've migrated to the latest version):
"

get_versions "$version_before_last" -gt | while read version; do migration_name $version; done | sort -r

echo -n "
Run the following command?

  ${cmd}

??? (y/n) "

read response
if [ "$response" == "y" ]; then
  eval "$cmd" 
else
  echo "Aborted"
fi
