#!/bin/bash
set -euo pipefail

# Setup script for opencode-omo-sota configuration
# Usage: ./setup.sh [opencode-go|zen|copilot|...]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRESET="${1:-opencode-go}"
CONFIG_SRC="${SCRIPT_DIR}/${PRESET}/oh-my-openagent.json"
CONFIG_DST="${HOME}/.config/opencode/oh-my-openagent.json"
AUTH_FILE="${HOME}/.local/share/opencode/auth.json"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if preset exists
if [ ! -f "${CONFIG_SRC}" ]; then
    log_error "Preset '${PRESET}' not found at ${CONFIG_SRC}"
    log_info "Available presets:"
    for dir in "${SCRIPT_DIR}"/*/; do
        if [ -f "${dir}oh-my-openagent.json" ]; then
            echo "  - $(basename "${dir}")"
        fi
    done
    exit 1
fi

log_info "Setting up Oh My OpenAgent with preset: ${PRESET}"

# Step 1: Backup existing config
if [ -f "${CONFIG_DST}" ]; then
    BACKUP="${CONFIG_DST}.backup-$(date +%Y%m%d-%H%M%S)"
    cp "${CONFIG_DST}" "${BACKUP}"
    log_info "Existing config backed up to: ${BACKUP}"
else
    log_warn "No existing config found at ${CONFIG_DST}"
fi

# Step 2: Validate JSON
if ! python3 -m json.tool "${CONFIG_SRC}" > /dev/null 2>&1; then
    log_error "Invalid JSON in ${CONFIG_SRC}"
    exit 1
fi
log_info "JSON validation passed"

# Step 3: Check for Zen if using opencode-go preset
if [ "${PRESET}" == "opencode-go" ] && [ -f "${AUTH_FILE}" ]; then
    if grep -q '"opencode"' "${AUTH_FILE}" 2>/dev/null; then
        log_warn "OpenCode Zen is connected in auth.json"
        log_warn "This config assumes Zen is disconnected by default"
        echo ""
        echo "Options:"
        echo "  1. Continue anyway (Zen will be available but not used in fallbacks)"
        echo "  2. Disconnect Zen now (edit ${AUTH_FILE})"
        echo "  3. Abort"
        echo ""
        read -p "Choose [1/2/3]: " choice
        case $choice in
            2)
                log_info "Disconnecting Zen..."
                python3 -c "
import json
with open('${AUTH_FILE}') as f:
    auth = json.load(f)
auth.pop('opencode', None)
with open('${AUTH_FILE}', 'w') as f:
    json.dump(auth, f, indent=2)
"
                log_info "Zen disconnected"
                ;;
            3)
                log_info "Aborted by user"
                exit 0
                ;;
            *)
                log_warn "Continuing with Zen connected"
                ;;
        esac
    fi
fi

# Step 4: Copy config
mkdir -p "$(dirname "${CONFIG_DST}")"
cp "${CONFIG_SRC}" "${CONFIG_DST}"
log_info "Config copied to: ${CONFIG_DST}"

# Step 5: Verify models exist (if opencode CLI is available)
if command -v opencode &> /dev/null; then
    log_info "Checking available models..."
    MODELS=$(opencode models opencode-go 2>/dev/null || true)
    
    if [ -n "${MODELS}" ]; then
        MISSING=0
        for model in $(grep -oE 'opencode-go/[a-z0-9.-]+' "${CONFIG_DST}" | sort -u); do
            model_id=$(echo "${model}" | sed 's|opencode-go/||')
            if ! echo "${MODELS}" | grep -q "${model}"; then
                log_warn "Model not found: ${model}"
                MISSING=$((MISSING + 1))
            fi
        done
        
        if [ $MISSING -eq 0 ]; then
            log_info "All configured models are available"
        else
            log_warn "${MISSING} model(s) not found. Check 'opencode models opencode-go'"
        fi
    else
        log_warn "Could not verify models (opencode CLI may need auth)"
    fi
else
    log_warn "opencode CLI not found. Skipping model verification."
fi

# Step 6: Summary
echo ""
log_info "Setup complete!"
echo ""
echo "Summary:"
echo "  Preset:     ${PRESET}"
echo "  Config:     ${CONFIG_DST}"
echo "  Backup:     ${BACKUP:-none}"
echo ""
echo "Next steps:"
echo "  1. Verify auth:  opencode auth list"
echo "  2. Restart:      pkill -f 'opencode serve' && opencode serve &"
echo "  3. Verify logs:  ls -lt ~/.local/share/opencode/log/ | head -3"
echo ""
echo "For more info, see: ${SCRIPT_DIR}/${PRESET}/README.md"
