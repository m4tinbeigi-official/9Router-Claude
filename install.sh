#!/usr/bin/env bash

# ==============================================================================
# 9Router & Claude Code - 1-Click Installer (macOS / Linux)
# ==============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${CYAN}${BOLD}"
echo "  ╔══════════════════════════════════════════════════════════╗"
echo "  ║        🚀 9Router & Claude Code 1-Click Installer       ║"
echo "  ╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# 1. Check Node.js and npm
echo -e "${BLUE}🔍 [1/5] بررسی پیش‌نیازها (Node.js & npm)...${NC}"
if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️ Node.js یافت نشد. در حال نصب...${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew >/dev/null 2>&1; then
            brew install node
        else
            echo -e "${RED}❌ لطفاً ابتدا Node.js را نصب کنید: https://nodejs.org${NC}"
            exit 1
        fi
    elif [[ -f /etc/debian_version ]]; then
        sudo apt-get update && sudo apt-get install -y nodejs npm
    else
        echo -e "${RED}❌ لطفاً Node.js نسخه 20 به بالا را نصب نمایید.${NC}"
        exit 1
    fi
fi

NODE_VERSION=$(node -v)
echo -e "${GREEN}✅ Node.js شناسایی شد: ${NODE_VERSION}${NC}"

# 2. Configure npm global directory without permission issues
echo -e "${BLUE}⚙️ [2/5] تنظیم مسیر Global پکیج‌های npm...${NC}"
mkdir -p "$HOME/.npm-global"
npm config set prefix "$HOME/.npm-global"
export PATH="$HOME/.npm-global/bin:$PATH"

# 3. Install 9Router & Claude Code
echo -e "${BLUE}📦 [3/5] در حال نصب 9Router و Claude Code...${NC}"
npm install -g 9router @anthropic-ai/claude-code

echo -e "${GREEN}✅ پکیج‌ها با موفقیت نصب شدند.${NC}"

# 4. Patch Fonts for Persian & Clean Typography
echo -e "${BLUE}🎨 [4/5] بهبود فونت‌ها و رابط کاربری فارسی (Vazirmatn & Typography)...${NC}"
ROUTER_APP_DIR="$HOME/.npm-global/lib/node_modules/9router/app/.next-cli-build/static/css"
if [ -d "$ROUTER_APP_DIR" ]; then
    for css_file in "$ROUTER_APP_DIR"/*.css; do
        if grep -q "Material Symbols Outlined" "$css_file" 2>/dev/null; then
            if ! grep -q "Vazirmatn" "$css_file" 2>/dev/null; then
                cat << 'CSS_EOF' >> "$css_file"

/* 9Router Font & UI Enhancement */
@import url('https://fonts.googleapis.com/css2?family=Vazirmatn:wght@300;400;500;600;700;800;900&family=Plus+Jakarta+Sans:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap');
html, body, button, input, select, textarea, [class*="className"] {
  font-family: 'Vazirmatn', 'Plus Jakarta Sans', 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif !important;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-rendering: optimizeLegibility;
}
code, kbd, samp, pre {
  font-family: 'JetBrains Mono', ui-monospace, Menlo, Monaco, Consolas, monospace !important;
}
CSS_EOF
                echo -e "${GREEN}✅ فونت‌های وزیرمتن و استایل مدرن اعمال شدند.${NC}"
            fi
        fi
    done
fi

# 5. Configure Shell environment variables (~/.zshrc & ~/.bashrc)
echo -e "${BLUE}🔧 [5/5] تنظیم متغیرهای محیطی در شل سیستم...${NC}"

SHELL_RC="$HOME/.zshrc"
if [[ "$SHELL" == *"bash"* ]] || [ ! -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

touch "$SHELL_RC"

# Clean previous 9Router configs if any
sed -i.bak '/# 9Router & Claude Code Integration/,+5d' "$SHELL_RC" 2>/dev/null || true

# Append fresh config
cat << 'SHELL_EOF' >> "$SHELL_RC"

# 9Router & Claude Code Integration
export PATH="$HOME/.npm-global/bin:$PATH"
export ANTHROPIC_BASE_URL="http://localhost:20128/v1"
export ANTHROPIC_AUTH_TOKEN="sk-a5be1fc2a203d8a3-q7rbod-9d98d295"
export ANTHROPIC_API_KEY="sk-a5be1fc2a203d8a3-q7rbod-9d98d295"
export NO_PROXY="localhost,127.0.0.1"
SHELL_EOF

echo -e "${GREEN}✅ متغیرها در ${SHELL_RC} ثبت شدند.${NC}"

echo -e "\n${PURPLE}${BOLD}======================================================${NC}"
echo -e "${GREEN}${BOLD}🎉 نصب و راه‌اندازی با موفقیت به پایان رسید!${NC}"
echo -e "${PURPLE}${BOLD}======================================================${NC}\n"

echo -e "🔹 ${BOLD}برای باز کردن داشبورد مدیریت:${NC} http://localhost:20128"
echo -e "🔹 ${BOLD}برای اجرای 9Router:${NC} 9router"
echo -e "🔹 ${BOLD}برای اجرای Claude Code در ترمینال:${NC} claude\n"

# Check if 9router is already running
if curl -s http://127.0.0.1:20128/api/status >/dev/null 2>&1 || lsof -i :20128 >/dev/null 2>&1; then
    echo -e "${GREEN}🟢 سرویس 9Router در پس‌زمینه در حال اجرا است.${NC}"
else
    echo -e "${CYAN}در حال راه‌اندازی سرویس 9Router در پس‌زمینه...${NC}"
    nohup "$HOME/.npm-global/bin/9router" --tray --no-browser --skip-update >/dev/null 2>&1 &
    sleep 2
    echo -e "${GREEN}🟢 سرویس 9Router با موفقیت راه‌اندازی شد.${NC}"
fi

echo -e "\n${BOLD}لذت ببرید! ✨${NC}\n"
