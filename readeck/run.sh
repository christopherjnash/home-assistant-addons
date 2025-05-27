#!/bin/sh
set -e

# Load options from Home Assistant
OPTIONS_FILE="/data/options.json"

# Parse options with jq (ensure jq is available in your container)
ALLOWED_HOSTS=$(jq -r '.allowed_hosts | join(",")' "$OPTIONS_FILE")
USE_X_FORWARDED_FOR=$(jq -r '.use_x_forwarded_for' "$OPTIONS_FILE")
USE_X_FORWARDED_HOST=$(jq -r '.use_x_forwarded_host' "$OPTIONS_FILE")
USE_X_FORWARDED_PROTO=$(jq -r '.use_x_forwarded_proto' "$OPTIONS_FILE")

# Export as env vars (or use them to update your config.toml)
export ALLOWED_HOSTS
export USE_X_FORWARDED_FOR
export USE_X_FORWARDED_HOST
export USE_X_FORWARDED_PROTO

# If you want to modify /config/config.toml, do so here
# (example sed commands, depending on config.toml structure)
# sed -i "s/^allowed_hosts.*/allowed_hosts = [${ALLOWED_HOSTS}]/" /config/config.toml

cd /config
/bin/readeck serve
