#!/bin/sh
set -e

if [ -f /app/data-templates/siteconfig.cloud.json ] && [ ! -f /data/siteconfig.json ]; then
    cp /app/data-templates/siteconfig.cloud.json /data/siteconfig.json
fi

node /app/scripts/init-data.js

cd /app/website
exec node terminologue.js
