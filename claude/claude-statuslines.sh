#!/bin/bash

# Claude Code Status Line - Shows current context usage
# Reads transcript JSONL to find accurate token count
# Uses Nerd Font icons for a prettier display

INPUT=$(cat)

# ═══════════════════════════════════════════════════════════
# Nerd Font Icons (requires a Nerd Font installed)
# Common alternatives if icons don't render:
#   Model:    (nf-cod-hubot)  (nf-md-robot)  (nf-fa-microchip)
#   Context:  (nf-md-memory)  (nf-fa-database)  (nf-oct-stack)
# ═══════════════════════════════════════════════════════════
ICON_MODEL="󰧑"      # nf-cod-hubot (robot face)
ICON_CONTEXT="󱔗"     # nf-md-memory (memory chip)
ICON_SEP=""        # Powerline right arrow
ICON_SEP_THIN="│"    # Box drawing vertical line

# ═══════════════════════════════════════════════════════════
# Colors (ANSI)
# ═══════════════════════════════════════════════════════════
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
MAGENTA="\033[35m"
DIM="\033[2m"
BOLD="\033[1m"
RESET="\033[0m"

# ═══════════════════════════════════════════════════════════
# Extract data from JSON input
# ═══════════════════════════════════════════════════════════
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty')
MODEL=$(echo "$INPUT" | jq -r '.model.id // .model // "unknown"')

# ═══════════════════════════════════════════════════════════
# Early exit if no transcript
# ═══════════════════════════════════════════════════════════
if [[ -z "$TRANSCRIPT" || ! -f "$TRANSCRIPT" ]]; then
  echo -e "${CYAN}${ICON_MODEL} ${MODEL}${RESET} ${DIM}${ICON_SEP_THIN}${RESET} ${MAGENTA}${ICON_CONTEXT} No data${RESET}"
  exit 0
fi

# ═══════════════════════════════════════════════════════════
# Find most recent main-chain entry with usage data
# ═══════════════════════════════════════════════════════════
USAGE=""
while read -r line; do
  [[ -z "$line" ]] && continue

  is_sidechain=$(echo "$line" | jq -r '.isSidechain // false' 2>/dev/null)
  is_error=$(echo "$line" | jq -r '.isApiErrorMessage // false' 2>/dev/null)
  has_usage=$(echo "$line" | jq -r '.message.usage // empty' 2>/dev/null)

  if [[ "$is_sidechain" != "true" && "$is_error" != "true" && -n "$has_usage" ]]; then
    USAGE="$line"
    break
  fi
done < <(tac "$TRANSCRIPT" 2>/dev/null)

if [[ -z "$USAGE" ]]; then
  echo -e "${CYAN}${ICON_MODEL} ${MODEL}${RESET} ${DIM}${ICON_SEP_THIN}${RESET} ${GREEN}${ICON_CONTEXT} 0k/200k${RESET}"
  exit 0
fi

# ═══════════════════════════════════════════════════════════
# Calculate token usage
# ═══════════════════════════════════════════════════════════
INPUT_TOKENS=$(echo "$USAGE" | jq '.message.usage.input_tokens // 0')
CACHE_READ=$(echo "$USAGE" | jq '.message.usage.cache_read_input_tokens // 0')
CACHE_CREATE=$(echo "$USAGE" | jq '.message.usage.cache_creation_input_tokens // 0')

TOTAL=$((INPUT_TOKENS + CACHE_READ + CACHE_CREATE))
CONTEXT_MAX=200000
PERCENT=$((TOTAL * 100 / CONTEXT_MAX))
TOTAL_K=$((TOTAL / 1000))

# Color based on usage percentage
if [[ $PERCENT -lt 50 ]]; then
  CTX_COLOR="$GREEN"
elif [[ $PERCENT -lt 75 ]]; then
  CTX_COLOR="$YELLOW"
else
  CTX_COLOR="$RED"
fi

# ═══════════════════════════════════════════════════════════
# Build progress bar
# ═══════════════════════════════════════════════════════════
BAR_WIDTH=10
FILLED=$((PERCENT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))

BAR=""
for ((i=0; i<FILLED; i++)); do BAR+="█"; done
for ((i=0; i<EMPTY; i++)); do BAR+="░"; done

# ═══════════════════════════════════════════════════════════
# Output
# ═══════════════════════════════════════════════════════════
echo -e "${CYAN}${ICON_MODEL} ${MODEL}${RESET} ${DIM}${ICON_SEP_THIN}${RESET} ${CTX_COLOR}${ICON_CONTEXT} ${TOTAL_K}k/200k ${DIM}${BAR}${RESET} ${CTX_COLOR}${PERCENT}%${RESET}"
