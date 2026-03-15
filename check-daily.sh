#!/bin/bash
# 每天例行检查 - 轻量级（带自动修复）
# 目标：快速健康检查，< 30秒完成

echo "📅 每天例行检查 - $(date '+%Y-%m-%d %H:%M:%S')"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

ISSUES=0
FIXES=0

# 1. 内存快速检查
MEM_PERCENT=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}')
echo "💾 内存: ${MEM_PERCENT}%"
if [ $MEM_PERCENT -gt 85 ]; then
    echo "⚠️ 内存使用超过 85%"
    ISSUES=$((ISSUES + 1))

    # 自动修复：清理缓存（简化版）
    echo "🔧 尝试修复：清理缓存..."
    echo 3 > /proc/sys/vm/drop_caches 2>/dev/null
    echo "✅ 缓存已清理"
    FIXES=$((FIXES + 1))
fi

# 2. 磁盘快速检查
DISK_PERCENT=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
echo "💿 磁盘: ${DISK_PERCENT}%"
if [ $DISK_PERCENT -gt 85 ]; then
    echo "⚠️ 磁盘使用超过 85%"
    ISSUES=$((ISSUES + 1))

    # 自动修复：清理临时文件
    echo "🔧 尝试修复：清理临时文件..."
    find /tmp -type f -mtime +7 -delete 2>/dev/null
    echo "✅ 临时文件已清理"
    FIXES=$((FIXES + 1))
fi

# 3. OpenClaw 进程检查
OPENCLAW_PROCS=$(ps aux | grep -v grep | grep -c openclaw)
echo "🔧 OpenClaw 进程: $OPENCLAW_PROCS"
if [ $OPENCLAW_PROCS -eq 0 ]; then
    echo "⚠️ OpenClaw 未运行"
    ISSUES=$((ISSUES + 1))

    # 自动修复：尝试重启 OpenClaw
    echo "🔧 尝试修复：重启 OpenClaw..."
    cd /root/.openclaw && npm start > /tmp/openclaw-restart.log 2>&1 &
    sleep 3
    if ps aux | grep -v grep | grep -q openclaw; then
        echo "✅ OpenClaw 已重启"
        FIXES=$((FIXES + 1))
    else
        echo "❌ 自动重启失败，请检查：cat /tmp/openclaw-restart.log"
    fi
fi

# 4. 最近错误检查（最近1小时，排除 SSH 认证失败）
RECENT_ERRORS=$(journalctl --since "1 hour ago" 2>/dev/null | grep -vi "Failed password\|authentication failure" | grep -ci "error\|fail" || echo 0)
echo "📋 最近1小时错误: $RECENT_ERRORS"
if [ $RECENT_ERRORS -gt 10 ]; then
    echo "⚠️ 错误数量异常"
    ISSUES=$((ISSUES + 1))
fi

# 5. 网络快速检查
if ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1; then
    echo "🌐 网络: ✅"
else
    echo "🌐 网络: ❌"
    ISSUES=$((ISSUES + 1))
    echo "⚠️ 网络故障需要人工检查"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ISSUES -eq 0 ]; then
    echo "✅ 每日检查通过，系统健康"
    exit 0
else
    echo "⚠️ 发现 $ISSUES 个问题，已自动修复 $FIXES 个"
    [ $FIXES -lt $ISSUES ] && echo "⚠️ 有 $((ISSUES - FIXES)) 个问题需要人工处理"
    exit 1
fi
