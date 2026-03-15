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
