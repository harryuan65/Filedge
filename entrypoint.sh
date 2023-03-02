#!/bin/bash
rm -rf tmp
set -e

if [[ $1 == "start_service" ]]; then
  if [[ $PORT ]]; then
    bundle exec rails s -b 0.0.0.0 -p $PORT
  else
    bundle exec rails s -b 0.0.0.0 -p 3000
  fi
else
  exec "$@"
fi
