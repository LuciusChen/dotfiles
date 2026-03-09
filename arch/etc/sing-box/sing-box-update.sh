#!/bin/bash
# sing-box subscription update script
# 解析订阅并回写到配置模板中（去除 emoji 版本）
set -e

# 配置路径
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_FILE="${SCRIPT_DIR}/config.template.json"
CONFIG_DIR="/etc/sing-box"
CONFIG_FILE="${CONFIG_DIR}/config.json"
BACKUP_DIR="${CONFIG_DIR}/backup"
RULESET_DIR="/var/lib/sing-box/ruleset"
LOG_FILE="/var/log/sing-box-update.log"

# Rule set 下载源（使用多个镜像作为备选）
RULESET_MIRRORS=(
    "https://mirror.ghproxy.com/https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set"
    "https://cdn.jsdelivr.net/gh/SagerNet/sing-geosite@rule-set"
    "https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set"
)
GEOIP_MIRRORS=(
    "https://mirror.ghproxy.com/https://raw.githubusercontent.com/SagerNet/sing-geoip/rule-set"
    "https://cdn.jsdelivr.net/gh/SagerNet/sing-geoip@rule-set"
    "https://raw.githubusercontent.com/SagerNet/sing-geoip/rule-set"
)

# 需要下载的 rule set 列表
GEOSITE_RULES=(
    "geosite-private"
    "geosite-cn"
    "geosite-geolocation-!cn"
    "geosite-category-ads-all"
    "geosite-google"
    "geosite-youtube"
    "geosite-telegram"
    "geosite-openai"
    "geosite-github"
    "geosite-bilibili"
)
GEOIP_RULES=(
    "geoip-cn"
)

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 下载单个 rule set 文件（尝试多个镜像）
download_ruleset() {
    local name="$1"
    local output="$2"
    local mirrors=("${@:3}")

    for mirror in "${mirrors[@]}"; do
        local url="${mirror}/${name}.srs"
        log "  Trying: $url"
        if curl -sL --connect-timeout 10 --max-time 30 -o "$output" "$url" && [[ -s "$output" ]]; then
            log "  Downloaded: $name"
            return 0
        fi
    done

    log "  FAILED: $name (all mirrors failed)"
    return 1
}

# 下载所有 rule set
download_all_rulesets() {
    local force="${1:-false}"
    local failed=0

    mkdir -p "$RULESET_DIR"

    log "Downloading geosite rule sets..."
    for rule in "${GEOSITE_RULES[@]}"; do
        local output="${RULESET_DIR}/${rule}.srs"
        if [[ "$force" == "true" ]] || [[ ! -f "$output" ]]; then
            if ! download_ruleset "$rule" "$output" "${RULESET_MIRRORS[@]}"; then
                ((failed++))
            fi
        else
            log "  Skipped (exists): $rule"
        fi
    done

    log "Downloading geoip rule sets..."
    for rule in "${GEOIP_RULES[@]}"; do
        local output="${RULESET_DIR}/${rule}.srs"
        if [[ "$force" == "true" ]] || [[ ! -f "$output" ]]; then
            if ! download_ruleset "$rule" "$output" "${GEOIP_MIRRORS[@]}"; then
                ((failed++))
            fi
        else
            log "  Skipped (exists): $rule"
        fi
    done

    if [[ $failed -gt 0 ]]; then
        log "WARNING: $failed rule set(s) failed to download"
        return 1
    fi

    log "All rule sets downloaded successfully"
    return 0
}

# 去除 emoji 的函数（使用 perl）
remove_emoji() {
    perl -CSD -pe '
        s/[\x{1F300}-\x{1F9FF}]//g;   # Misc Symbols and Pictographs, Emoticons
        s/[\x{1F1E0}-\x{1F1FF}]//g;   # Regional Indicator Symbols (flags)
        s/[\x{2600}-\x{27BF}]//g;     # Misc symbols
        s/[\x{FE00}-\x{FE0F}]//g;     # Variation Selectors
        s/\x{200D}//g;                 # Zero Width Joiner
        s/[\x{2300}-\x{23FF}]//g;     # Misc Technical
        s/[\x{2B50}-\x{2B55}]//g;     # Stars, circles
        s/[\x{E0020}-\x{E007F}]//g;   # Tags
        s/\x{200B}//g;                 # Zero Width Space
        s/[\x{2190}-\x{21FF}]//g;     # Arrows
        s/[\x{25A0}-\x{25FF}]//g;     # Geometric Shapes
        s/[\x{2700}-\x{27BF}]//g;     # Dingbats
        s/[\x{2900}-\x{297F}]//g;     # Supplemental Arrows
        s/[\x{2B00}-\x{2BFF}]//g;     # Misc Symbols and Arrows
        s/[\x{3000}-\x{303F}]//g;     # CJK Symbols (except keep punctuation)
        s/\x{FE0E}//g;                 # Variation Selector-15
        s/[\x{1F000}-\x{1F02F}]//g;   # Mahjong Tiles
        s/[\x{1F0A0}-\x{1F0FF}]//g;   # Playing Cards
        s/[\x{1FA00}-\x{1FAFF}]//g;   # Chess, Extended-A symbols
    '
}

# 解析参数
SUBSCRIBE_URL=""
UPDATE_RULESET=false
FORCE_RULESET=false

show_usage() {
    echo "Usage: $0 [options] <subscription_url>"
    echo ""
    echo "Options:"
    echo "  --update-ruleset    Download/update rule set files"
    echo "  --force-ruleset     Force re-download all rule sets"
    echo "  -h, --help          Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 \"https://example.com/subscribe\"           # Update subscription only"
    echo "  $0 --update-ruleset \"https://example.com/subscribe\"  # Update both"
    echo "  $0 --force-ruleset \"https://example.com/subscribe\"   # Force update rule sets"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --update-ruleset)
            UPDATE_RULESET=true
            shift
            ;;
        --force-ruleset)
            UPDATE_RULESET=true
            FORCE_RULESET=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        -*)
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
        *)
            SUBSCRIBE_URL="$1"
            shift
            ;;
    esac
done

if [[ -z "$SUBSCRIBE_URL" ]]; then
    echo "Error: subscription_url is required"
    show_usage
    exit 1
fi

# 检查模板文件
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    log "ERROR: Template file not found: $TEMPLATE_FILE"
    exit 1
fi

# 检查依赖
for cmd in jq curl perl; do
    if ! command -v "$cmd" &>/dev/null; then
        log "ERROR: Required command not found: $cmd"
        exit 1
    fi
done

# 创建目录
mkdir -p "$BACKUP_DIR"
mkdir -p "$RULESET_DIR"

log "Starting subscription update..."

# 下载 rule set（如果需要）
if [[ "$UPDATE_RULESET" == "true" ]]; then
    log "Updating rule sets..."
    if ! download_all_rulesets "$FORCE_RULESET"; then
        log "WARNING: Some rule sets failed to download, continuing anyway..."
    fi
else
    # 检查是否有缺失的 rule set，如果有则自动下载
    missing=false
    for rule in "${GEOSITE_RULES[@]}" "${GEOIP_RULES[@]}"; do
        if [[ ! -f "${RULESET_DIR}/${rule}.srs" ]]; then
            missing=true
            break
        fi
    done

    if [[ "$missing" == "true" ]]; then
        log "Missing rule sets detected, downloading..."
        download_all_rulesets false || log "WARNING: Some rule sets failed to download"
    fi
fi

# 备份当前配置
if [[ -f "$CONFIG_FILE" ]]; then
    cp "$CONFIG_FILE" "${BACKUP_DIR}/config.json.$(date +%Y%m%d_%H%M%S)"
    log "Backed up current config"
fi

# 临时文件
TEMP_SUB=$(mktemp)
TEMP_CLEAN=$(mktemp)
TEMP_OUT=$(mktemp)

cleanup() {
    rm -f "$TEMP_SUB" "$TEMP_CLEAN" "$TEMP_OUT"
}
trap cleanup EXIT

# 下载订阅
log "Downloading subscription..."
if ! curl -sL --connect-timeout 30 --max-time 60 -o "$TEMP_SUB" "$SUBSCRIBE_URL"; then
    log "ERROR: Failed to download subscription"
    exit 1
fi

# 验证 JSON
if ! jq empty "$TEMP_SUB" 2>/dev/null; then
    log "ERROR: Invalid JSON received"
    exit 1
fi

# 统计原始节点数量
NODE_COUNT=$(jq '[.outbounds[] | select(.type == "trojan" or .type == "vmess" or .type == "vless" or .type == "shadowsocks" or .type == "hysteria" or .type == "hysteria2" or .type == "tuic")] | length' "$TEMP_SUB")
log "Found ${NODE_COUNT} proxy nodes"

if [[ "$NODE_COUNT" -eq 0 ]]; then
    log "ERROR: No proxy nodes found"
    exit 1
fi

# 第一步：用 perl 去除 emoji
log "Removing emojis from node tags..."
remove_emoji < "$TEMP_SUB" > "$TEMP_CLEAN"

# 第二步：用 jq 清理空格并生成配置
log "Generating config from template..."

jq -s '
    .[0] as $sub | .[1] as $tpl |

    # 提取代理节点并清理 tag 的多余空格
    ($sub.outbounds | map(
        select(.type == "trojan" or .type == "vmess" or .type == "vless" or
               .type == "shadowsocks" or .type == "hysteria" or .type == "hysteria2" or .type == "tuic")
        | .tag = (.tag | gsub("^\\s+"; "") | gsub("\\s+$"; "") | gsub("\\s+"; " "))
    )) as $nodes |

    # 提取所有节点标签
    ($nodes | map(.tag)) as $all_tags |

    # 提取日本节点标签
    ($nodes | map(select(.tag | test("日本|JP|Japan"; "i")) | .tag)) as $japan_tags |
    (if ($japan_tags | length) == 0 then $all_tags else $japan_tags end) as $japan_tags_final |

    # 提取新加坡节点标签
    ($nodes | map(select(.tag | test("新加坡|SG|Singapore"; "i")) | .tag)) as $sg_tags |
    (if ($sg_tags | length) == 0 then $all_tags else $sg_tags end) as $sg_tags_final |

    # 生成最终配置
    $tpl | .outbounds = (
        $nodes +
        (.outbounds | map(
            if .tag == "Auto" then
                .outbounds = $all_tags
            elif .tag == "Auto-JP" then
                .outbounds = $japan_tags_final
            elif .tag == "Auto-SG" then
                .outbounds = $sg_tags_final
            elif .tag == "Proxy" then
                .outbounds = (["Auto"] + $all_tags + ["DIRECT"])
            else
                .
            end
        ))
    )
' "$TEMP_CLEAN" "$TEMPLATE_FILE" > "$TEMP_OUT"

# 验证输出
if ! jq empty "$TEMP_OUT" 2>/dev/null; then
    log "ERROR: Generated config is invalid JSON"
    exit 1
fi

# 统计地区节点
JAPAN_COUNT=$(jq '[.outbounds[] | select(.type == "trojan" or .type == "vmess" or .type == "vless" or .type == "shadowsocks" or .type == "hysteria" or .type == "hysteria2" or .type == "tuic") | select(.tag | test("日本|JP|Japan"; "i"))] | length' "$TEMP_OUT")
SG_COUNT=$(jq '[.outbounds[] | select(.type == "trojan" or .type == "vmess" or .type == "vless" or .type == "shadowsocks" or .type == "hysteria" or .type == "hysteria2" or .type == "tuic") | select(.tag | test("新加坡|SG|Singapore"; "i"))] | length' "$TEMP_OUT")
log "Found ${JAPAN_COUNT} Japan nodes, ${SG_COUNT} Singapore nodes"

# 写入最终配置
cp "$TEMP_OUT" "$CONFIG_FILE"

# 验证配置
log "Validating config..."
if command -v sing-box &>/dev/null; then
    if ! sing-box check -c "$CONFIG_FILE" 2>/dev/null; then
        log "ERROR: Config validation failed"
        LATEST_BACKUP=$(ls -t "${BACKUP_DIR}"/config.json.* 2>/dev/null | head -1)
        if [[ -n "$LATEST_BACKUP" ]]; then
            cp "$LATEST_BACKUP" "$CONFIG_FILE"
            log "Restored from backup: $LATEST_BACKUP"
        fi
        exit 1
    fi
else
    log "WARNING: sing-box not found, skipping validation"
fi

# 重启 sing-box
log "Restarting sing-box..."
if command -v systemctl &>/dev/null; then
    if systemctl is-active --quiet sing-box; then
        systemctl restart sing-box
        log "sing-box restarted"
    else
        systemctl start sing-box
        log "sing-box started"
    fi
else
    log "WARNING: systemctl not found, please restart sing-box manually"
fi

# 清理旧备份（保留最近 5 个）
ls -t "${BACKUP_DIR}"/config.json.* 2>/dev/null | tail -n +6 | xargs -r rm -f

log "Update completed! Nodes: ${NODE_COUNT}, JP: ${JAPAN_COUNT}, SG: ${SG_COUNT}"

# 显示部分节点名称
log "Sample node tags:"
jq -r '.outbounds[0:5] | .[].tag' "$CONFIG_FILE" 2>/dev/null | while read -r tag; do
    log "  - $tag"
done
