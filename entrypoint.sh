#!/bin/bash
rm -rf tmp
set -e

if [[ $1 == "start_service" ]]; then
  bin/rails tailwindcss:watch &
  bundle exec rails s -b 0.0.0.0 -p 3000
else
  exec "$@"
fi
