#!/bin/bash
# sing-box subscription update script
# Location: /usr/local/bin/sing-box-update
# Usage: sudo sing-box-update <subscription_url>

set -e

# Configuration paths
CONFIG_DIR="/etc/sing-box"
CONFIG_FILE="${CONFIG_DIR}/config.json"
BACKUP_DIR="${CONFIG_DIR}/backup"
CACHE_DIR="/var/lib/sing-box"
LOG_FILE="/var/log/sing-box-update.log"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Check argument
if [[ -z "$1" ]]; then
    echo "Usage: $0 <subscription_url>"
    echo "Example: $0 \"https://example.com/subscribe\""
    exit 1
fi

SUBSCRIBE_URL="$1"

# Create directories if not exist
mkdir -p "$BACKUP_DIR" "$CACHE_DIR"

log "Starting sing-box subscription update..."

# Backup current config
if [[ -f "$CONFIG_FILE" ]]; then
    cp "$CONFIG_FILE" "${BACKUP_DIR}/config.json.$(date +%Y%m%d_%H%M%S)"
    log "Backed up current config"
fi

# Download subscription
TEMP_FILE=$(mktemp)

log "Downloading subscription..."
if ! curl -sL --connect-timeout 30 --max-time 60 -o "$TEMP_FILE" "$SUBSCRIBE_URL"; then
    log "ERROR: Failed to download subscription"
    rm -f "$TEMP_FILE"
    exit 1
fi

# Validate JSON
if ! jq empty "$TEMP_FILE" 2>/dev/null; then
    log "ERROR: Invalid JSON received"
    rm -f "$TEMP_FILE"
    exit 1
fi

# Extract outbounds (proxy nodes only, exclude special types)
log "Extracting proxy nodes..."
NODES=$(jq '[.outbounds[] | select(.type == "trojan" or .type == "vmess" or .type == "vless" or .type == "shadowsocks" or .type == "hysteria" or .type == "hysteria2" or .type == "tuic")]' "$TEMP_FILE")
NODE_COUNT=$(echo "$NODES" | jq 'length')
log "Found ${NODE_COUNT} proxy nodes"

if [[ "$NODE_COUNT" -eq 0 ]]; then
    log "ERROR: No proxy nodes found"
    rm -f "$TEMP_FILE"
    exit 1
fi

# Get node tags for selector/urltest
NODE_TAGS=$(echo "$NODES" | jq '[.[].tag]')

# Get Japan node tags for OpenRouter routing
JAPAN_TAGS=$(echo "$NODES" | jq '[.[] | select(.tag | test("日本")) | .tag]')
log "Found $(echo "$JAPAN_TAGS" | jq 'length') Japan nodes"

# Build final config with our template settings
log "Building final config..."
jq -n --argjson nodes "$NODES" --argjson tags "$NODE_TAGS" --argjson japan_tags "$JAPAN_TAGS" '
{
  "log": {
    "level": "info",
    "timestamp": true
  },
  "dns": {
    "servers": [
      { "tag": "dns_proxy", "type": "udp", "server": "8.8.8.8" },
      { "tag": "dns_direct", "type": "udp", "server": "223.5.5.5" }
    ],
    "rules": [
      { "rule_set": ["geosite-cn", "geosite-private"], "action": "route", "server": "dns_direct" },
      { "rule_set": ["geosite-geolocation-!cn"], "action": "route", "server": "dns_proxy" }
    ],
    "final": "dns_proxy",
    "strategy": "prefer_ipv4"
  },
  "inbounds": [
    {
      "type": "tun",
      "tag": "tun-in",
      "interface_name": "tun0",
      "address": ["172.19.0.1/30"],
      "auto_route": true,
      "strict_route": true,
      "sniff": true,
      "sniff_override_destination": true
    },
    {
      "type": "mixed",
      "tag": "mixed-in",
      "listen": "127.0.0.1",
      "listen_port": 7890,
      "sniff": true,
      "sniff_override_destination": true
    }
  ],
  "outbounds": (
    $nodes + [
      {
        "type": "urltest",
        "tag": "♻️ Auto",
        "outbounds": $tags,
        "url": "https://www.gstatic.com/generate_204",
        "interval": "5m",
        "tolerance": 50
      },
      {
        "type": "urltest",
        "tag": "🇯🇵 日本自动",
        "outbounds": $japan_tags,
        "url": "https://www.gstatic.com/generate_204",
        "interval": "5m",
        "tolerance": 50
      },
      {
        "type": "selector",
        "tag": "🚀 Proxy",
        "outbounds": (["♻️ Auto"] + $tags + ["DIRECT"]),
        "default": "♻️ Auto"
      },
      { "type": "direct", "tag": "DIRECT" },
      { "type": "block", "tag": "REJECT" }
    ]
  ),
  "route": {
    "default_domain_resolver": "dns_direct",
    "rule_set": [
      { "tag": "geosite-private", "type": "remote", "format": "binary", "url": "https://mirror.ghproxy.com/https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-private.srs", "download_detour": "DIRECT" },
      { "tag": "geosite-cn", "type": "remote", "format": "binary", "url": "https://mirror.ghproxy.com/https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-cn.srs", "download_detour": "DIRECT" },
      { "tag": "geoip-cn", "type": "remote", "format": "binary", "url": "https://mirror.ghproxy.com/https://raw.githubusercontent.com/SagerNet/sing-geoip/rule-set/geoip-cn.srs", "download_detour": "DIRECT" },
      { "tag": "geosite-geolocation-!cn", "type": "remote", "format": "binary", "url": "https://mirror.ghproxy.com/https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-geolocation-!cn.srs", "download_detour": "DIRECT" },
      { "tag": "geosite-category-ads-all", "type": "remote", "format": "binary", "url": "https://mirror.ghproxy.com/https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-category-ads-all.srs", "download_detour": "DIRECT" },
      { "tag": "geosite-google", "type": "remote", "format": "binary", "url": "https://mirror.ghproxy.com/https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-google.srs", "download_detour": "DIRECT" },
      { "tag": "geosite-youtube", "type": "remote", "format": "binary", "url": "https://mirror.ghproxy.com/https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-youtube.srs", "download_detour": "DIRECT" },
      { "tag": "geosite-telegram", "type": "remote", "format": "binary", "url": "https://mirror.ghproxy.com/https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-telegram.srs", "download_detour": "DIRECT" },
      { "tag": "geosite-openai", "type": "remote", "format": "binary", "url": "https://mirror.ghproxy.com/https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-openai.srs", "download_detour": "DIRECT" },
      { "tag": "geosite-github", "type": "remote", "format": "binary", "url": "https://mirror.ghproxy.com/https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-github.srs", "download_detour": "DIRECT" },
      { "tag": "geosite-bilibili", "type": "remote", "format": "binary", "url": "https://mirror.ghproxy.com/https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-bilibili.srs", "download_detour": "DIRECT" }
    ],
    "rules": [
      { "protocol": "dns", "action": "hijack-dns" },
      { "ip_is_private": true, "action": "route", "outbound": "DIRECT" },
      { "rule_set": "geosite-category-ads-all", "action": "reject" },
      { "rule_set": "geosite-private", "action": "route", "outbound": "DIRECT" },
      { "rule_set": "geosite-bilibili", "action": "route", "outbound": "DIRECT" },
      { "rule_set": "geosite-cn", "action": "route", "outbound": "DIRECT" },
      { "rule_set": "geoip-cn", "action": "route", "outbound": "DIRECT" },
      { "rule_set": "geosite-youtube", "action": "route", "outbound": "🚀 Proxy" },
      { "rule_set": "geosite-google", "action": "route", "outbound": "🚀 Proxy" },
      { "rule_set": "geosite-telegram", "action": "route", "outbound": "🚀 Proxy" },
      { "domain_suffix": ["openrouter.ai"], "action": "route", "outbound": "🇯🇵 日本自动" },
      { "domain_suffix": ["anthropic.com", "claude.ai", "perplexity.ai", "groq.com", "mistral.ai", "cohere.ai", "huggingface.co"], "action": "route", "outbound": "🚀 Proxy" },
      { "rule_set": "geosite-openai", "action": "route", "outbound": "🚀 Proxy" },
      { "rule_set": "geosite-github", "action": "route", "outbound": "🚀 Proxy" },
      { "rule_set": "geosite-geolocation-!cn", "action": "route", "outbound": "🚀 Proxy" },
      { "process_name": ["qbittorrent", "aria2c", "transmission", "Motrix"], "action": "route", "outbound": "DIRECT" }
    ],
    "final": "🚀 Proxy",
    "auto_detect_interface": true
  },
  "experimental": {
    "clash_api": {
      "external_controller": "127.0.0.1:9090",
      "external_ui": "ui",
      "external_ui_download_url": "https://github.com/MetaCubeX/metacubexd/archive/refs/heads/gh-pages.zip",
      "external_ui_download_detour": "DIRECT",
      "secret": "",
      "default_mode": "rule"
    },
    "cache_file": {
      "enabled": true,
      "path": "/var/lib/sing-box/cache.db",
      "store_fakeip": true,
      "store_rdrc": true
    }
  }
}' > "$CONFIG_FILE"

rm -f "$TEMP_FILE"

# Validate final config
log "Validating config..."
if ! sing-box check -c "$CONFIG_FILE" 2>/dev/null; then
    log "WARNING: Config validation failed, but continuing..."
fi

# Restart sing-box service
log "Restarting sing-box service..."
if systemctl is-active --quiet sing-box; then
    systemctl restart sing-box
    log "sing-box restarted successfully"
else
    systemctl start sing-box
    log "sing-box started"
fi

# Cleanup old backups (keep last 5)
ls -t "${BACKUP_DIR}"/config.json.* 2>/dev/null | tail -n +6 | xargs -r rm -f

log "Update completed! Node count: ${NODE_COUNT}"
