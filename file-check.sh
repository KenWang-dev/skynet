#!/bin/bash
# 文件安检脚本 - 检查文件大小和预估 token

FILE="$1"

if [ ! -f "$FILE" ]; then
    echo "❌ 文件不存在: $FILE"
    exit 1
fi

# 获取文件大小（字节）
SIZE_BYTES=$(wc -c < "$FILE")
SIZE_KB=$((SIZE_BYTES / 1024))

# 粗略预估 token（中文约 1.5 字符/token，英文约 4 字符/token）
# 这里用保守估计：1 token ≈ 3 字符
ESTIMATED_TOKENS=$((SIZE_BYTES / 3))

# 阈值设置
WARN_SIZE_KB=50        # 50KB 警告
DANGER_SIZE_KB=100     # 100KB 危险

echo "📄 文件安检报告"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📂 文件: $FILE"
echo "📊 大小: ${SIZE_KB} KB (${SIZE_BYTES} 字节)"
echo "🔢 预估 token: ~$ESTIMATED_TOKENS"
echo ""

if [ $SIZE_KB -ge $DANGER_SIZE_KB ]; then
    echo "⛔ 危险级别: 危险"
    echo "💡 建议: 使用 offset/limit 分段读取，或启动子会话处理"
    exit 2
elif [ $SIZE_KB -ge $WARN_SIZE_KB ]; then
    echo "⚠️  危险级别: 警告"
    echo "💡 建议: 可读取，但注意剩余上下文空间"
    exit 1
else
    echo "✅ 危险级别: 安全"
    echo "💡 可以直接读取"
    exit 0
fi
