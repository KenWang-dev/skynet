#!/bin/bash
# 每月大度检查 - 全面深度
# 目标：系统级深度检查，完整报告，可能需要 5-10分钟

echo "📅 每月大度检查 - $(date '+%Y-%m-%d %H:%M:%S')"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 全面系统健康审计"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

REPORT_FILE="/root/.openclaw/workspace/monthly-report-$(date +%Y%m%d).txt"

# 重定向输出到报告文件
exec > >(tee -a "$REPORT_FILE")
exec 2>&1

ISSUES=0
WARNINGS=0

# ═══════════════════════════════════════════════
# 1. 硬件和内核状态
# ═══════════════════════════════════════════════
echo "🖥️ 1. 硬件和内核状态"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 系统信息
echo "系统信息:"
uname -a
echo ""

# 内核版本
echo "内核版本:"
uname -r
echo ""

# CPU 信息
echo "CPU 信息:"
lscpu | grep -E "Architecture|CPU\(s\)|Thread|Model name"
echo ""

# 内存详情
echo "内存详情:"
free -h
echo ""

# 内核错误
echo "最近内核错误:"
dmesg | grep -i "error\|fail" | tail -10
ERROR_COUNT=$(dmesg | grep -ci "error\|fail" | tail -1)
if [ $ERROR_COUNT -gt 0 ]; then
    echo "⚠️ 发现 $ERROR_COUNT 个内核错误"
    WARNINGS=$((WARNINGS + 1))
fi
echo ""

# ═══════════════════════════════════════════════
# 2. 存储系统详细检查
# ═══════════════════════════════════════════════
echo "💾 2. 存储系统详情"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 磁盘使用
echo "磁盘使用情况:"
df -h
echo ""

# Inode 使用
echo "Inode 使用情况:"
df -i
echo ""

# 磁盘 I/O 统计
if [ -f /proc/diskstats ]; then
    echo "磁盘 I/O:"
    iostat -x 2 2 2>/dev/null || echo "iostat 未安装"
    echo ""
fi

# 大文件检查
echo "超过 100MB 的文件:"
find / -type f -size +100M 2>/dev/null | head -10
echo ""

# ═══════════════════════════════════════════════
# 3. 网络详细分析
# ═══════════════════════════════════════════════
echo "🌐 3. 网络详细分析"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 网络接口
echo "网络接口:"
ip addr show 2>/dev/null || ifconfig 2>/dev/null
echo ""

# 路由表
echo "路由表:"
ip route show 2>/dev/null || route -n 2>/dev/null
echo ""

# 监听端口
echo "监听端口:"
netstat -tlnp 2>/dev/null | grep LISTEN | head -10
echo ""

# 网络连接统计
echo "网络连接统计:"
netstat -an 2>/dev/null | awk '{print $6}' | sort | uniq -c | sort -rn
echo ""

# ═══════════════════════════════════════════════
# 4. 进程和资源审计
# ═══════════════════════════════════════════════
echo "🔧 4. 进程和资源审计"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Top 进程
echo "资源占用 Top 10:"
ps aux --sort=-%mem | head -11
echo ""

# OpenClaw 进程详情
echo "OpenClaw 进程树:"
pstree -p $(pgrep -f openclaw | head -1) 2>/dev/null || ps aux | grep openclaw
echo ""

# 打开的文件描述符
echo "文件描述符使用:"
for pid in $(pgrep -f openclaw); do
    FD_COUNT=$(ls -la /proc/$pid/fd 2>/dev/null | wc -l)
    echo "PID $pid: $FD_COUNT 个文件描述符"
    if [ $FD_COUNT -gt 1000 ]; then
        echo "⚠️ 文件描述符过多"
        WARNINGS=$((WARNINGS + 1))
    fi
done
echo ""

# ═══════════════════════════════════════════════
# 5. 安全审计
# ═══════════════════════════════════════════════
echo "🔒 5. 安全审计"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 最近登录
echo "最近登录记录:"
last -n 10 2>/dev/null || echo "last 命令不可用"
echo ""

# 失败的登录尝试
echo "失败的登录:"
grep "Failed password" /var/log/auth.log 2>/dev/null | tail -5 || \
grep "Failed" /var/log/secure 2>/dev/null | tail -5 || echo "无法读取登录日志"
echo ""

# 开放端口分析
echo "可疑开放端口:"
netstat -tlnp 2>/dev/null | grep LISTEN | awk '{print $4}' | cut -d: -f2 | sort -n | uniq
echo ""

# ═══════════════════════════════════════════════
# 6. 应用状态深度检查
# ═══════════════════════════════════════════════
echo "📦 6. 应用状态深度检查"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# OpenClaw 日志分析
if [ -f /root/.openclaw/gateway.log ]; then
    echo "OpenClaw 日志分析（最近1000行）:"
    echo "错误数量: $(tail -1000 /root/.openclaw/gateway.log | grep -ci "error\|fail" || echo 0)"
    echo "警告数量: $(tail -1000 /root/.openclaw/gateway.log | grep -ci "warn" || echo 0)"
    echo "最后5个错误:"
    tail -1000 /root/.openclaw/gateway.log | grep -i "error\|fail" | tail -5
    echo ""
fi

# 定时任务状态
echo "定时任务状态:"
crontab -l 2>/dev/null | grep -v "^#" | grep -v "^$" || echo "无定时任务"
echo ""

# ═══════════════════════════════════════════════
# 7. 系统趋势分析
# ═══════════════════════════════════════════════
echo "📈 7. 系统趋势分析"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 负载趋势（从系统启动到现在）
echo "平均负载趋势:"
uptime
echo ""

# 系统运行时间
echo "系统运行时间:"
uptime -s 2>/dev/null || uptime
echo ""

# ═══════════════════════════════════════════════
# 8. 深度清理
# ═══════════════════════════════════════════════
echo "🧹 8. 深度清理"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 清理包管理器缓存
if command -v apt-get > /dev/null 2>&1; then
    echo "清理 APT 缓存:"
    apt-get clean > /dev/null 2>&1
    apt-get autoclean > /dev/null 2>&1
    echo "✅ APT 缓存已清理"
fi

if command -v yum > /dev/null 2>&1; then
    echo "清理 YUM 缓存:"
    yum clean all > /dev/null 2>&1
    echo "✅ YUM 缓存已清理"
fi

# 清理旧的日志文件
find /var/log -name "*.log.*" -mtime +30 -delete 2>/dev/null
find /var/log -name "*.gz" -mtime +30 -delete 2>/dev/null
echo "✅ 清理 30 天前的旧日志"

# 清理临时文件
find /tmp -type f -mtime +14 -delete 2>/dev/null
find /var/tmp -type f -mtime +14 -delete 2>/dev/null
echo "✅ 清理 14 天前的临时文件"
echo ""

# ═══════════════════════════════════════════════
# 总结
# ═══════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 每月大度检查总结"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "严重问题: $ISSUES"
echo "警告: $WARNINGS"
echo ""
echo "📄 完整报告已保存到: $REPORT_FILE"
echo ""

if [ $ISSUES -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✅ 每月检查通过，系统健康"
    exit 0
elif [ $ISSUES -eq 0 ]; then
    echo "⚠️ 系统基本正常，有 $WARNINGS 个警告"
    exit 0
else
    echo "⛔ 发现 $ISSUES 个严重问题，需要处理"
    exit 1
fi
