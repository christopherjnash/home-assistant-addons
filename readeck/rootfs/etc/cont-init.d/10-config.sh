#!/command/with-contenv bashio
set -e

CONFIG_FILE="/data/config.toml"
SECRET_FILE="/data/secret_key"

# Generate or reuse secret_key
if [ -f "$SECRET_FILE" ]; then
  SECRET_KEY=$(cat "$SECRET_FILE")
else
  SECRET_KEY=$(head -c 48 /dev/urandom | base64)
  echo "$SECRET_KEY" > "$SECRET_FILE"
fi

# Read config values from options.json, robustly
ALLOWED_HOSTS=$(bashio::config 'allowed_hosts')
if [ -z "$ALLOWED_HOSTS" ] || [ "$ALLOWED_HOSTS" = "null" ]; then
  ALLOWED_HOSTS="[]"
fi

USE_X_FORWARDED_FOR=$(bashio::config 'use_x_forwarded_for' || echo "false")
USE_X_FORWARDED_HOST=$(bashio::config 'use_x_forwarded_host' || echo "false")
USE_X_FORWARDED_PROTO=$(bashio::config 'use_x_forwarded_proto' || echo "false")

# DEBUG
echo "ALLOWED_HOSTS='$ALLOWED_HOSTS'" >&2
echo "USE_X_FORWARDED_FOR='$USE_X_FORWARDED_FOR'" >&2
echo "USE_X_FORWARDED_HOST='$USE_X_FORWARDED_HOST'" >&2
echo "USE_X_FORWARDED_PROTO='$USE_X_FORWARDED_PROTO'" >&2

# Validate that ALLOWED_HOSTS is valid JSON array before passing to jq
echo "$ALLOWED_HOSTS" | jq empty || ALLOWED_HOSTS="[]"

# Format allowed_hosts for TOML array (empty array -> allowed_hosts = [])
ALLOWED_HOSTS_TOML=$(echo "$ALLOWED_HOSTS" | jq -r 'if type=="array" and length>0 then . | @csv else "" end' | sed 's/","/", "/g')

# Write config.toml
cat > "$CONFIG_FILE" <<EOF
[main]
log_level = "INFO"
secret_key = "$SECRET_KEY"
data_directory = "/data"

[server]
host = "0.0.0.0"
port = 8001
allowed_hosts = [${ALLOWED_HOSTS_TOML}]
use_x_forwarded_for = $USE_X_FORWARDED_FOR
use_x_forwarded_host = $USE_X_FORWARDED_HOST
use_x_forwarded_proto = $USE_X_FORWARDED_PROTO

[database]
source = "sqlite3:/data/db.sqlite3"
EOF
