#!/bin/bash
# 荒野求生：全面危险源扫描与防护
# 目标：找出所有可能导致 Context Overflow 的风险

echo "🏕️ 荒野求生模式：危险源扫描"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 工作区路径
WORKSPACE="/root/.openclaw/workspace"
SCAN_LOG="$WORKSPACE/danger-scan-log.txt"

# 清空日志
> "$SCAN_LOG"

echo "📋 扫描报告生成中..."
echo ""

# 统计变量
TOTAL_FILES=0
SAFE_FILES=0
WARNING_FILES=0
DANGER_FILES=0

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 第一阶段：工作区文件扫描"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 扫描工作区所有文件
find "$WORKSPACE" -type f -not -path "*/.git/*" -not -path "*/node_modules/*" 2>/dev/null | while read file; do
    TOTAL_FILES=$((TOTAL_FILES + 1))

    # 获取文件大小（KB）
    SIZE_BYTES=$(wc -c < "$file" 2>/dev/null)
    SIZE_KB=$((SIZE_BYTES / 1024))

    # 预估 token
    ESTIMATED_TOKENS=$((SIZE_BYTES / 3))

    # 判断风险级别
    if [ $SIZE_KB -ge 100 ]; then
        echo "⛔ 危险: $file ($SIZE_KB KB, ~$ESTIMATED_TOKENS tokens)"
        echo "[DANGER] $file - ${SIZE_KB}KB - ${ESTIMATED_TOKENS}tokens" >> "$SCAN_LOG"
        DANGER_FILES=$((DANGER_FILES + 1))
    elif [ $SIZE_KB -ge 50 ]; then
        echo "⚠️  警告: $file ($SIZE_KB KB, ~$ESTIMATED_TOKENS tokens)"
        echo "[WARNING] $file - ${SIZE_KB}KB - ${ESTIMATED_TOKENS}tokens" >> "$SCAN_LOG"
        WARNING_FILES=$((WARNING_FILES + 1))
    elif [ $SIZE_KB -ge 10 ]; then
        echo "📊 注意: $file ($SIZE_KB KB, ~$ESTIMATED_TOKENS tokens)"
        echo "[NOTICE] $file - ${SIZE_KB}KB - ${ESTIMATED_TOKENS}tokens" >> "$SCAN_LOG"
        SAFE_FILES=$((SAFE_FILES + 1))
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 扫描统计"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⛔ 危险文件 (≥100KB): $DANGER_FILES"
echo "⚠️  警告文件 (50-100KB): $WARNING_FILES"
echo "✅ 安全文件 (<50KB): $SAFE_FILES"
echo ""
echo "📄 详细报告已保存到: $SCAN_LOG"
echo ""

# 列出前10个最大文件
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔝 TOP 10 最大文件"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
find "$WORKSPACE" -type f -not -path "*/.git/*" -not -path "*/node_modules/*" -exec du -h {} + 2>/dev/null | sort -rh | head -10
echo ""

# 第二阶段：检查是否有超大日志文件
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 第二阶段：日志文件检查"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
find /var/log -name "*.log" -size +10M 2>/dev/null | while read log; do
    SIZE=$(du -h "$log" | cut -f1)
    echo "⚠️  超大日志: $log ($SIZE)"
done
echo ""

# 第三阶段：检查配置文件
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 第三阶段：配置安全检查"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 检查是否有历史消息限制配置
if [ -f /root/.openclaw/config.json ]; then
    echo "✅ 找到配置文件: /root/.openclaw/config.json"
    grep -i "maxHistory\|contextLimit\|messageLimit" /root/.openclaw/config.json || echo "⚠️  未找到历史消息限制配置"
else
    echo "⚠️  未找到配置文件"
fi
echo ""

# 第四阶段：自我防护机制建立
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🛡️ 第四阶段：建立防护机制"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 创建强制安检脚本（wrap read操作）
cat > "$WORKSPACE/read-safe.sh" << 'EOF'
#!/bin/bash
# 安全读取包装器 - 强制安检
# 用法: read-safe.sh /path/to/file [offset] [limit]

FILE="$1"
OFFSET="${2:-1}"
LIMIT="${3:-1000}"

# 强制安检
CHECK_OUTPUT=$(bash /root/.openclaw/workspace/file-check.sh "$FILE" 2>&1)
RISK_LEVEL=$(echo "$CHECK_OUTPUT" | grep "危险级别" | grep -o "安全\|警告\|危险")

case "$RISK_LEVEL" in
    "危险")
        echo "⛔ 文件过大，强制使用分段读取"
        echo "📄 文件: $FILE"
        echo "🔧 策略: offset=$OFFSET, limit=$LIMIT"
        # 这里应该调用 read 工具，但我们是在 bash 中
        exit 2
        ;;
    "警告")
        echo "⚠️  文件较大，建议分段读取"
        echo "📄 文件: $FILE"
        # 可以继续，但要小心
        exit 1
        ;;
    *)
        # 安全，直接读取
        exit 0
        ;;
esac
EOF

chmod +x "$WORKSPACE/read-safe.sh"
echo "✅ 创建安全读取包装器: $WORKSPACE/read-safe.sh"

# 创建会话健康检查脚本
cat > "$WORKSPACE/health-check.sh" << 'EOF'
#!/bin/bash
# 会话健康检查 - 检测上下文使用情况

# 估算当前对话长度（粗略）
# 通过检查最近的消息数量来估算

# 这个脚本主要用于提醒，实际值需要从系统获取
echo "🏥 会话健康检查"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 建议:"
echo "• 如果对话超过 50 轮 → 考虑重启会话"
echo "• 如果读取多个大文件 → 立即重启会话"
echo "• 如果响应变慢 → 重启会话"
echo ""
echo "🔄 重启方法: 在飞书发送 '重启'"
EOF

chmod +x "$WORKSPACE/health-check.sh"
echo "✅ 创建健康检查脚本: $WORKSPACE/health-check.sh"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 荒野求生防护部署完成"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 后续行动计划:"
echo "1. 📖 定期查看扫描日志: $SCAN_LOG"
echo "2. 🛡️ 读取文件前强制安检"
echo "3. 🔄 每 30-50 轮对话主动建议重启"
echo "4. 📊 大文件必须用 offset/limit 或子会话"
echo ""
echo "🪭 我会保护好自己的。"
