#!/bin/bash
# sing-box subscription update script
# 只负责解析订阅并回写到配置模板中

set -e

# 配置路径
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_FILE="${SCRIPT_DIR}/config.template.json"
CONFIG_DIR="/etc/sing-box"
CONFIG_FILE="${CONFIG_DIR}/config.json"
BACKUP_DIR="${CONFIG_DIR}/backup"
LOG_FILE="/var/log/sing-box-update.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 检查参数
if [[ -z "$1" ]]; then
    echo "Usage: $0 <subscription_url>"
    echo "Example: $0 \"https://example.com/subscribe\""
    exit 1
fi

SUBSCRIBE_URL="$1"

# 检查模板文件
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    log "ERROR: Template file not found: $TEMPLATE_FILE"
    exit 1
fi

# 创建目录
mkdir -p "$BACKUP_DIR"

log "Starting subscription update..."

# 备份当前配置
if [[ -f "$CONFIG_FILE" ]]; then
    cp "$CONFIG_FILE" "${BACKUP_DIR}/config.json.$(date +%Y%m%d_%H%M%S)"
    log "Backed up current config"
fi

# 下载订阅
TEMP_FILE=$(mktemp)
log "Downloading subscription..."
if ! curl -sL --connect-timeout 30 --max-time 60 -o "$TEMP_FILE" "$SUBSCRIBE_URL"; then
    log "ERROR: Failed to download subscription"
    rm -f "$TEMP_FILE"
    exit 1
fi

# 验证 JSON
if ! jq empty "$TEMP_FILE" 2>/dev/null; then
    log "ERROR: Invalid JSON received"
    rm -f "$TEMP_FILE"
    exit 1
fi

# 提取代理节点
log "Extracting proxy nodes..."
NODES=$(jq -c '[.outbounds[] | select(.type == "trojan" or .type == "vmess" or .type == "vless" or .type == "shadowsocks" or .type == "hysteria" or .type == "hysteria2" or .type == "tuic")]' "$TEMP_FILE")
NODE_COUNT=$(echo "$NODES" | jq 'length')
log "Found ${NODE_COUNT} proxy nodes"

if [[ "$NODE_COUNT" -eq 0 ]]; then
    log "ERROR: No proxy nodes found"
    rm -f "$TEMP_FILE"
    exit 1
fi

# 提取节点标签
ALL_TAGS=$(echo "$NODES" | jq -c '[.[].tag]')
JAPAN_TAGS=$(echo "$NODES" | jq -c '[.[] | select(.tag | test("日本")) | .tag]')
JAPAN_COUNT=$(echo "$JAPAN_TAGS" | jq 'length')
log "Found ${JAPAN_COUNT} Japan nodes"

# 如果没有日本节点，使用所有节点
if [[ "$JAPAN_COUNT" -eq 0 ]]; then
    log "WARNING: No Japan nodes found, using all nodes for Japan auto"
    JAPAN_TAGS="$ALL_TAGS"
fi

rm -f "$TEMP_FILE"

# 生成最终配置
log "Generating config from template..."

# 读取模板，插入节点，更新 outbound 引用
jq --argjson nodes "$NODES" \
   --argjson all_tags "$ALL_TAGS" \
   --argjson japan_tags "$JAPAN_TAGS" '
# 在 outbounds 开头插入代理节点，更新 urltest 和 selector 的引用
.outbounds = (
  $nodes +
  (.outbounds | map(
    if .tag == "♻️ Auto" then .outbounds = $all_tags
    elif .tag == "🇯🇵 日本自动" then .outbounds = $japan_tags
    elif .tag == "🚀 Proxy" then .outbounds = (["♻️ Auto"] + $all_tags + ["DIRECT"])
    else .
    end
  ))
)
' "$TEMPLATE_FILE" > "$CONFIG_FILE"

# 验证配置
log "Validating config..."
if ! sing-box check -c "$CONFIG_FILE" 2>/dev/null; then
    log "ERROR: Config validation failed"
    # 恢复备份
    LATEST_BACKUP=$(ls -t "${BACKUP_DIR}"/config.json.* 2>/dev/null | head -1)
    if [[ -n "$LATEST_BACKUP" ]]; then
        cp "$LATEST_BACKUP" "$CONFIG_FILE"
        log "Restored from backup: $LATEST_BACKUP"
    fi
    exit 1
fi

# 重启 sing-box
log "Restarting sing-box..."
if systemctl is-active --quiet sing-box; then
    systemctl restart sing-box
    log "sing-box restarted"
else
    systemctl start sing-box
    log "sing-box started"
fi

# 清理旧备份（保留最近 5 个）
ls -t "${BACKUP_DIR}"/config.json.* 2>/dev/null | tail -n +6 | xargs -r rm -f

log "Update completed! Nodes: ${NODE_COUNT}, Japan nodes: ${JAPAN_COUNT}"
