#! /usr/bin/env bash

set -e -x

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 2 ] || die "provide username and password"

npm install
npm run build

cat config.default.js \
    | sed "s/  var dbLabel = 'mongodb-2.4';/  var dbLabel = 'mlab';/" \
    | sed "s/    connectionString: mongo.connectionString || '',/    connectionString: mongo.uri || '',/" \
    > config.js

cf push --no-start
cf set-env 'mongo-express' 'ME_CONFIG_BASICAUTH_USERNAME' "$1"
cf set-env 'mongo-express' 'ME_CONFIG_BASICAUTH_PASSWORD' "$2"
cf start 'mongo-express'
