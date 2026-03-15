#!/bin/bash
# 全面系统健康检查
# 监控所有可能导致"挂掉"的风险因素

echo "🏥 全面系统健康检查"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 当前时间
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "🕐 检查时间: $DATE"
echo ""

# 结果统计
ISSUES=0
WARNINGS=0

# ═══════════════════════════════════════════════
# 1. 内存使用检查
# ═══════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 1. 内存使用情况"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

MEM_INFO=$(free -m | grep Mem)
MEM_TOTAL=$(echo $MEM_INFO | awk '{print $2}')
MEM_USED=$(echo $MEM_INFO | awk '{print $3}')
MEM_PERCENT=$((MEM_USED * 100 / MEM_TOTAL))

echo "总内存: ${MEM_TOTAL}MB"
echo "已使用: ${MEM_USED}MB (${MEM_PERCENT}%)"

if [ $MEM_PERCENT -gt 90 ]; then
    echo "⛔ 严重: 内存使用超过 90%"
    ISSUES=$((ISSUES + 1))
elif [ $MEM_PERCENT -gt 75 ]; then
    echo "⚠️  警告: 内存使用超过 75%"
    WARNINGS=$((WARNINGS + 1))
else
    echo "✅ 正常"
fi
echo ""

# ═══════════════════════════════════════════════
# 2. 磁盘使用检查
# ═══════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💾 2. 磁盘使用情况"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

df -h | grep -E '(Filesystem|/$|/home|/var|/tmp)' | while read line; do
    echo "$line"
done

DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt 90 ]; then
    echo "⛔ 严重: 磁盘使用超过 90%"
    ISSUES=$((ISSUES + 1))
elif [ $DISK_USAGE -gt 75 ]; then
    echo "⚠️  警告: 磁盘使用超过 75%"
    WARNINGS=$((WARNINGS + 1))
else
    echo "✅ 正常"
fi
echo ""

# ═══════════════════════════════════════════════
# 3. CPU 负载检查
# ═══════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚡ 3. CPU 负载"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}')
echo "平均负载: $LOAD_AVG"

# 获取 CPU 核心数
CPU_CORES=$(nproc)
LOAD_1MIN=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')

# 简单判断（浮点数比较用 bc）
if [ $(echo "$LOAD_1MIN > $CPU_CORES" | bc) -eq 1 ]; then
    echo "⛔ 严重: 负载超过 CPU 核心数"
    ISSUES=$((ISSUES + 1))
elif [ $(echo "$LOAD_1MIN > $((CPU_CORES * 0.7))" | bc) -eq 1 ]; then
    echo "⚠️  警告: 负载较高"
    WARNINGS=$((WARNINGS + 1))
else
    echo "✅ 正常"
fi
echo ""

# ═══════════════════════════════════════════════
# 4. 进程检查
# ═══════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 4. 进程状态"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 检查僵尸进程
ZOMBIE_COUNT=$(ps aux | awk '{print $8}' | grep -c Z)
if [ $ZOMBIE_COUNT -gt 0 ]; then
    echo "⚠️  发现 $ZOMBIE_COUNT 个僵尸进程"
    WARNINGS=$((WARNINGS + 1))
else
    echo "✅ 无僵尸进程"
fi

# 检查 openclaw 相关进程
OPENCLAW_PROCS=$(ps aux | grep -v grep | grep -c openclaw)
echo "OpenClaw 进程数: $OPENCLAW_PROCS"

# 检查是否有被杀死的进程
KILLED_RECENTLY=$(journalctl --since "5 minutes ago" 2>/dev/null | grep -c "killed\|SIGKILL" || echo 0)
if [ $KILLED_RECENTLY -gt 0 ]; then
    echo "⚠️  最近 5 分钟内有 $KILLED_RECENTLY 个进程被杀死"
    WARNINGS=$((WARNINGS + 1))
fi
echo ""

# ═══════════════════════════════════════════════
# 5. 日志文件检查
# ═══════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 5. 日志文件状态"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 检查大日志文件
LARGE_LOGS=$(find /var/log -name "*.log" -size +10M 2>/dev/null | wc -l)
if [ $LARGE_LOGS -gt 0 ]; then
    echo "⚠️  发现 $LARGE_LOGS 个超过 10MB 的日志文件"
    find /var/log -name "*.log" -size +10M -exec ls -lh {} \; 2>/dev/null
    WARNINGS=$((WARNINGS + 1))
else
    echo "✅ 日志文件大小正常"
fi

# 检查 openclaw 日志
if [ -f /root/.openclaw/gateway.log ]; then
    LOG_SIZE=$(du -h /root/.openclaw/gateway.log | cut -f1)
    echo "OpenClaw 日志大小: $LOG_SIZE"
fi
echo ""

# ═══════════════════════════════════════════════
# 6. 网络连接检查
# ═══════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 6. 网络连接"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 检查网络连接数
CONNECTIONS=$(netstat -an 2>/dev/null | grep ESTABLISHED | wc -l)
echo "活动连接数: $CONNECTIONS"

# 测试网络连通性（简单 ping）
if ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1; then
    echo "✅ 外网连通正常"
else
    echo "⛔ 严重: 外网不通"
    ISSUES=$((ISSUES + 1))
fi
echo ""

# ═══════════════════════════════════════════════
# 7. 系统错误检查
# ═══════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚠️  7. 系统错误"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 检查最近的内核错误
KERNEL_ERRORS=$(dmesg | grep -i "error\|fail" | tail -5 | wc -l)
if [ $KERNEL_ERRORS -gt 0 ]; then
    echo "⚠️  内核日志中有 $KERNEL_ERRORS 个错误"
    WARNINGS=$((WARNINGS + 1))
else
    echo "✅ 无内核错误"
fi

# 检查 systemd 失败的服务
FAILED_SERVICES=$(systemctl list-units --failed 2>/dev/null | grep -c "loaded failed")
if [ $FAILED_SERVICES -gt 0 ]; then
    echo "⚠️  有 $FAILED_SERVICES 个服务失败"
    systemctl list-units --failed --no-pager 2>/dev/null | head -5
    WARNINGS=$((WARNINGS + 1))
else
    echo "✅ 所有服务正常"
fi
echo ""

# ═══════════════════════════════════════════════
# 8. 文件系统检查
# ═══════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📁 8. 文件系统状态"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 检查 inode 使用
INODE_USAGE=$(df -i / | tail -1 | awk '{print $5}' | sed 's/%//')
echo "Inode 使用率: ${INODE_USAGE}%"

if [ $INODE_USAGE -gt 90 ]; then
    echo "⛔ 严重: Inode 使用超过 90%"
    ISSUES=$((ISSUES + 1))
elif [ $INODE_USAGE -gt 75 ]; then
    echo "⚠️  警告: Inode 使用超过 75%"
    WARNINGS=$((WARNINGS + 1))
else
    echo "✅ 正常"
fi
echo ""

# ═══════════════════════════════════════════════
# 总结报告
# ═══════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 健康检查总结"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "严重问题: $ISSUES"
echo "警告: $WARNINGS"
echo ""

if [ $ISSUES -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✅ 系统健康状态良好"
    exit 0
elif [ $ISSUES -eq 0 ]; then
    echo "⚠️  系统基本正常，有 $WARNINGS 个警告需要注意"
    exit 0
else
    echo "⛔ 系统有 $ISSUES 个严重问题，需要立即处理"
    exit 1
fi
