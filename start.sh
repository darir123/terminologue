#!/bin/sh
# Initialize data directory with templates if needed

# Copy cloud siteconfig if it exists and siteconfig.json doesn't
if [ -f /app/data-templates/siteconfig.cloud.json ] && [ ! -f /data/siteconfig.json ]; then
    cp /app/data-templates/siteconfig.cloud.json /data/siteconfig.json
fi

# Initialize other data files (databases, etc.)
node /app/scripts/init-data.js

# Start Terminologue
cd /app/website
exec node terminologue.js
