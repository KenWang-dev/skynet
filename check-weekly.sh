#!/bin/bash
# 每周中度检查 - 中等强度（增强自动修复）
# 目标：全面检查 + 自动修复，< 2分钟完成

echo "📅 每周中度检查 - $(date '+%Y-%m-%d %H:%M:%S')"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

ISSUES=0
WARNINGS=0
FIXES=0
AUTO_REPAIR_LOG=""

# 辅助函数：记录修复
log_fix() {
    FIXES=$((FIXES + 1))
    AUTO_REPAIR_LOG="$AUTO_REPAIR_LOG\n✅ $1"
}

# 辅助函数：记录问题
log_issue() {
    AUTO_REPAIR_LOG="$AUTO_REPAIR_LOG\n⚠️  $1"
}

# ═══════════════════════════════════════════════
# 1. 系统资源详细检查 + 自动修复
# ═══════════════════════════════════════════════
echo "📊 1. 系统资源详情"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

MEM_PERCENT=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}')
DISK_PERCENT=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

echo "内存: ${MEM_PERCENT}% | 磁盘: ${DISK_PERCENT}%"

# 内存自动修复
if [ $MEM_PERCENT -gt 85 ]; then
    echo "⚠️ 内存使用超过 85%"
    ISSUES=$((ISSUES + 1))
    echo "🔧 自动修复：清理内存缓存..."
    echo 3 > /proc/sys/vm/drop_caches 2>/dev/null
    log_fix "清理内存缓存"
fi

# 磁盘自动修复
if [ $DISK_PERCENT -gt 85 ]; then
    echo "⚠️ 磁盘使用超过 85%"
    ISSUES=$((ISSUES + 1))
    echo "🔧 自动修复：深度清理..."
    # 清理各种缓存
    apt-get clean > /dev/null 2>&1
    apt-get autoclean > /dev/null 2>&1
    journalctl --vacuum-time=14d > /dev/null 2>&1
    find /tmp /var/tmp -type f -mtime +14 -delete 2>/dev/null
    # 清理 npm 缓存
    npm cache clean --force > /dev/null 2>&1
    log_fix "深度清理磁盘空间（apt, journal, tmp, npm）"
fi
echo ""

# ═══════════════════════════════════════════════
# 2. 进程和服务检查 + 自动修复
# ═══════════════════════════════════════════════
echo "🔧 2. 进程和服务状态"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 僵尸进程检查
ZOMBIE_COUNT=$(ps aux | awk '{print $8}' | grep -c Z)
if [ $ZOMBIE_COUNT -gt 0 ]; then
    echo "⚠️ 僵尸进程: $ZOMBIE_COUNT"
    WARNINGS=$((WARNINGS + 1))
    # 尝试清理僵尸进程的父进程
    ps aux | awk '{print $2, $8}' | grep Z | awk '{print $1}' | while read pid; do
        ppid=$(ps -o ppid= -p $pid 2>/dev/null | tr -d ' ')
        if [ -n "$ppid" ]; then
            kill -9 $ppid 2>/dev/null
            log_fix "清理僵尸进程 $pid (父进程: $ppid)"
        fi
    done
else
    echo "✅ 无僵尸进程"
fi

# OpenClaw 进程检查
OPENCLAW_PROCS=$(ps aux | grep -v grep | grep -c openclaw)
echo "OpenClaw 进程: $OPENCLAW_PROCS"
if [ $OPENCLAW_PROCS -eq 0 ]; then
    echo "⚠️ OpenClaw 未运行"
    ISSUES=$((ISSUES + 1))
    echo "🔧 自动修复：重启 OpenClaw..."
    cd /root/.openclaw && npm start > /tmp/openclaw-restart.log 2>&1 &
    sleep 5
    if ps aux | grep -v grep | grep -q openclaw; then
        log_fix "OpenClaw 已重启"
    else
        log_issue "OpenClaw 重启失败，需要人工检查"
    fi
fi

# 失败的服务检查
FAILED_SERVICES=$(systemctl list-units --failed 2>/dev/null | grep "loaded failed" | awk '{print $1}')
if [ -n "$FAILED_SERVICES" ]; then
    echo "⚠️ 失败的服务:"
    systemctl list-units --failed --no-pager 2>/dev/null | head -5
    WARNINGS=$((WARNINGS + 1))

    # 尝试重启失败的服务
    echo "$FAILED_SERVICES" | while read service; do
        if [ -n "$service" ]; then
            echo "🔧 尝试重启服务: $service"
            systemctl restart "$service" 2>/dev/null
            sleep 2
            if systemctl is-active --quiet "$service"; then
                log_fix "服务 $service 已重启"
            else
                # 如果重启失败，尝试禁用不需要的服务
                if [[ "$service" =~ (ipmi|kdump|mcelog) ]]; then
                    systemctl disable "$service" 2>/dev/null
                    systemctl stop "$service" 2>/dev/null
                    log_fix "禁用不需要的服务: $service"
                else
                    log_issue "服务 $service 重启失败（可能是配置问题）"
                fi
            fi
        fi
    done
else
    echo "✅ 所有服务正常"
fi
echo ""

# ═══════════════════════════════════════════════
# 3. 日志检查 + 清理
# ═══════════════════════════════════════════════
echo "📝 3. 日志文件状态"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 大日志文件
LARGE_LOGS=$(find /var/log -name "*.log" -size +10M 2>/dev/null | wc -l)
if [ $LARGE_LOGS -gt 0 ]; then
    echo "⚠️ 发现 $LARGE_LOGS 个超过 10MB 的日志文件"
    WARNINGS=$((WARNINGS + 1))
    find /var/log -name "*.log" -size +10M -exec ls -lh {} \; 2>/dev/null
    echo "🔧 自动修复：压缩大日志文件..."
    find /var/log -name "*.log" -size +10M -exec gzip {} \; 2>/dev/null
    log_fix "压缩大日志文件"
else
    echo "✅ 日志文件大小正常"
fi

# OpenClaw 日志
if [ -f /root/.openclaw/gateway.log ]; then
    LOG_SIZE=$(du -h /root/.openclaw/gateway.log | cut -f1)
    LOG_LINES=$(wc -l < /root/.openclaw/gateway.log)
    echo "OpenClaw 日志: $LOG_SIZE ($LOG_LINES 行)"

    # 如果日志太大，清理
    LOG_SIZE_BYTES=$(wc -c < /root/.openclaw/gateway.log)
    if [ $LOG_SIZE_BYTES -gt 52428800 ]; then  # 50MB
        echo "🔧 自动修复：清理 OpenClaw 日志..."
        tail -n 10000 /root/.openclaw/gateway.log > /root/.openclaw/gateway.log.tmp
        mv /root/.openclaw/gateway.log.tmp /root/.openclaw/gateway.log
        log_fix "清理 OpenClaw 日志（保留10000行）"
    fi
fi
echo ""

# ═══════════════════════════════════════════════
# 4. 网络检查 + 自动修复
# ═══════════════════════════════════════════════
echo "🌐 4. 网络状态"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 连接统计
ESTABLISHED=$(netstat -an 2>/dev/null | grep ESTABLISHED | wc -l)
echo "活动连接: $ESTABLISHED"

# DNS 测试
if ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1; then
    echo "✅ 外网连通"
else
    echo "⚠️ 外网不通"
    ISSUES=$((ISSUES + 1))

    # 尝试自动修复网络
    echo "🔧 自动修复：尝试恢复网络..."
    # 尝试重启网络服务
    systemctl restart network > /dev/null 2>&1 || \
    systemctl restart NetworkManager > /dev/null 2>&1 || \
    systemctl restart systemd-networkd > /dev/null 2>&1

    sleep 3

    # 尝试刷新 DNS
    echo "nameserver 8.8.8.8" > /etc/resolv.conf
    echo "nameserver 114.114.114.114" >> /etc/resolv.conf

    # 再次测试
    if ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1; then
        log_fix "网络已恢复"
    else
        log_issue "网络自动修复失败（可能需要重启或人工检查）"
    fi
fi
echo ""

# ═══════════════════════════════════════════════
# 5. 工作区健康检查
# ═══════════════════════════════════════════════
echo "📁 5. 工作区状态"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 运行文件安检扫描
bash /root/.openclaw/workspace/wilderness-survival-scan.sh 2>&1 | head -30
echo ""

# ═══════════════════════════════════════════════
# 6. 清理临时文件
# ═══════════════════════════════════════════════
echo "🧹 6. 清理临时文件"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

TMP_SIZE_BEFORE=$(du -sh /tmp 2>/dev/null | cut -f1)
find /tmp -type f -mtime +7 -delete 2>/dev/null
find /var/tmp -type f -mtime +7 -delete 2>/dev/null
TMP_SIZE_AFTER=$(du -sh /tmp 2>/dev/null | cut -f1)
echo "清理 /tmp: $TMP_SIZE_BEFORE → $TMP_SIZE_AFTER"

# 清理系统日志
journalctl --vacuum-time=7d > /dev/null 2>&1
echo "✅ 清理系统日志（保留7天）"

# 清理 OpenClaw 临时文件
find /root/.openclaw -name "*.tmp" -mtime +3 -delete 2>/dev/null
echo "✅ 清理 OpenClaw 临时文件"
echo ""

# ═══════════════════════════════════════════════
# 总结
# ═══════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 每周检查总结"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "严重问题: $ISSUES"
echo "警告: $WARNINGS"
echo "自动修复: $FIXES 项"

if [ -n "$AUTO_REPAIR_LOG" ]; then
    echo ""
    echo "🔧 自动修复详情:"
    echo -e "$AUTO_REPAIR_LOG"
fi

echo ""

if [ $ISSUES -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✅ 每周检查通过，系统健康"
    exit 0
elif [ $ISSUES -eq 0 ]; then
    echo "⚠️ 系统基本正常，有 $WARNINGS 个警告"
    exit 0
else
    echo "⚠️ 发现 $ISSUES 个严重问题"
    echo "🔧 已自动修复 $FIXES 项，剩余问题需要处理"
    exit 1
fi
