#!/usr/bin/env bash
set -Eeuo pipefail

readonly PROFILE_URL_FILE="${PROFILE_URL_FILE:-/etc/sing-box/profile-url}"
readonly CONFIG_DIR="/etc/sing-box"
readonly CONFIG_FILE="${CONFIG_DIR}/config.json"
readonly BACKUP_FILE="${CONFIG_DIR}/config.json.previous"
readonly LOCK_FILE="/run/lock/sing-box-profile-update.lock"

log() {
  printf '%s\n' "$*"
}

for command in curl flock jq sing-box systemctl; do
  if ! command -v "$command" >/dev/null 2>&1; then
    log "missing required command: ${command}"
    exit 1
  fi
done

if [[ ! -s "$PROFILE_URL_FILE" ]]; then
  log "profile URL file is missing or empty: ${PROFILE_URL_FILE}"
  exit 1
fi

profile_url=$(tr -d '\r\n' < "$PROFILE_URL_FILE")
if [[ "$profile_url" != https://* ]]; then
  log "profile URL must use HTTPS"
  exit 1
fi

exec 9>"$LOCK_FILE"
if ! flock -n 9; then
  log "another profile update is already running"
  exit 0
fi

umask 077
temp_config=$(mktemp "${CONFIG_DIR}/.config.json.XXXXXX")
cleanup() {
  rm -f "$temp_config"
}
trap cleanup EXIT

log "downloading Linux profile"
curl \
  --fail \
  --silent \
  --show-error \
  --location \
  --proto '=https' \
  --tlsv1.2 \
  --connect-timeout 15 \
  --max-time 120 \
  --retry 3 \
  --retry-all-errors \
  --retry-delay 2 \
  --output "$temp_config" \
  "$profile_url"

if ! jq -e '
  type == "object" and
  (.inbounds | type == "array" and length > 0) and
  (.outbounds | type == "array" and length > 0) and
  (.route | type == "object")
' "$temp_config" >/dev/null; then
  log "downloaded profile is not a complete sing-box configuration"
  exit 1
fi

log "validating downloaded profile"
sing-box check -c "$temp_config"

if [[ -f "$CONFIG_FILE" ]] && cmp -s "$temp_config" "$CONFIG_FILE"; then
  log "profile is already current"
  exit 0
fi

if [[ -f "$CONFIG_FILE" ]]; then
  cp --preserve=mode,ownership,timestamps "$CONFIG_FILE" "$BACKUP_FILE"
fi

chmod 0644 "$temp_config"
chown root:root "$temp_config"
mv -f "$temp_config" "$CONFIG_FILE"
trap - EXIT

log "profile changed; restarting sing-box"
if ! systemctl restart sing-box.service || ! systemctl is-active --quiet sing-box.service; then
  log "new profile failed to start; restoring previous profile"
  if [[ -f "$BACKUP_FILE" ]]; then
    cp --preserve=mode,ownership,timestamps "$BACKUP_FILE" "$CONFIG_FILE"
    systemctl restart sing-box.service
  fi
  exit 1
fi

node_count=$(jq '[.outbounds[] | select(.type != "selector" and .type != "urltest" and .type != "direct")] | length' "$CONFIG_FILE")
log "profile update completed (${node_count} proxy nodes)"
