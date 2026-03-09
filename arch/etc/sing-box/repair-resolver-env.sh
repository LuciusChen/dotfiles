#!/bin/bash
set -euo pipefail

NM_CONF_DIR="/etc/NetworkManager/conf.d"
NM_CONF_FILE="${NM_CONF_DIR}/10-dns.conf"
RESOLV_STUB="/run/systemd/resolve/stub-resolv.conf"
RESOLV_LINK="/etc/resolv.conf"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

require_root() {
    if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
        echo "Run as root: sudo $0" >&2
        exit 1
    fi
}

check_command() {
    local cmd="$1"
    if ! command -v "$cmd" &>/dev/null; then
        echo "Required command not found: $cmd" >&2
        exit 1
    fi
}

backup_resolv_conf() {
    if [[ -e "$RESOLV_LINK" && ! -L "$RESOLV_LINK" ]]; then
        local backup="${RESOLV_LINK}.bak.$(date +%Y%m%d_%H%M%S)"
        cp "$RESOLV_LINK" "$backup"
        log "Backed up ${RESOLV_LINK} to ${backup}"
    fi
}

configure_networkmanager() {
    mkdir -p "$NM_CONF_DIR"
    cat > "$NM_CONF_FILE" <<'EOF'
[main]
dns=systemd-resolved
EOF
    log "Wrote ${NM_CONF_FILE}"
}

configure_resolved_stub() {
    if [[ ! -e "$RESOLV_STUB" ]]; then
        echo "systemd-resolved stub not found: $RESOLV_STUB" >&2
        exit 1
    fi
    ln -sf "$RESOLV_STUB" "$RESOLV_LINK"
    log "Linked ${RESOLV_LINK} -> ${RESOLV_STUB}"
}

restart_services() {
    systemctl enable --now systemd-resolved
    systemctl restart systemd-resolved

    if systemctl list-unit-files NetworkManager.service >/dev/null 2>&1; then
        systemctl restart NetworkManager
    fi

    if systemctl list-unit-files sing-box.service >/dev/null 2>&1; then
        systemctl restart sing-box
    fi
}

show_status() {
    log "$(ls -l "$RESOLV_LINK")"
    log "Contents of ${RESOLV_LINK}:"
    cat "$RESOLV_LINK"
    if command -v resolvectl &>/dev/null; then
        log "resolvectl status:"
        resolvectl status
    fi
}

require_root
check_command systemctl

backup_resolv_conf
configure_networkmanager
restart_services
configure_resolved_stub
systemctl restart systemd-resolved
show_status
