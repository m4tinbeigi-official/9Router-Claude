#!/usr/bin/env bash
export PATH="$HOME/.npm-global/bin:/usr/local/bin:/opt/homebrew/bin:$PATH"
echo "در حال اجرای 9Router (پورت 20129 - Gemini/Antigravity) و OmniRoute (پورت 20128 - کمبوی خودکار)..."
nohup 9router --port 20129 --no-browser --tray --skip-update -H 127.0.0.1 > "$HOME/.hermes/launcher-logs/9router.log" 2>&1 &
omniroute serve --daemon --no-open
