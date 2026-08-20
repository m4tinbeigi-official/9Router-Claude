# ==============================================================================
# 9Router & Claude Code - 1-Click Installer for Windows (PowerShell)
# ==============================================================================

Write-Host "╔══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║        🚀 9Router & Claude Code 1-Click Installer        ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

# 1. Check Node.js
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "⚠️ Node.js یافت نشد. لطفاً ابتدا Node.js را نصب کنید: https://nodejs.org" -ForegroundColor Yellow
    exit 1
}

# 2. Install Packages
Write-Host "📦 در حال نصب 9Router و Claude Code..." -ForegroundColor Blue
npm install -g 9router @anthropic-ai/claude-code

# 3. Set Environment Variables
Write-Host "🔧 تنظیم متغیرهای محیطی سیستم..." -ForegroundColor Blue
[Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", "http://localhost:20128/v1", "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", "sk-a5be1fc2a203d8a3-q7rbod-9d98d295", "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "sk-a5be1fc2a203d8a3-q7rbod-9d98d295", "User")
[Environment]::SetEnvironmentVariable("NO_PROXY", "localhost,127.0.0.1", "User")

Write-Host "🎉 نصب با موفقیت انجام شد!" -ForegroundColor Green
Write-Host "🔹 داشبورد: http://localhost:20128"
Write-Host "🔹 اجرای کلاد: claude"
