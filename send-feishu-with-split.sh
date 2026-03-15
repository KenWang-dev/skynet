#!/bin/bash
# 飞书智能分批发送包装器
# 通用规则：
# - total_length <= 4096 → 直接输出
# - total_length > 4096 → 分批发送，在 3800~3900 字符主动断开

CONTENT="$1"
TARGET="${2:-ou_a7195bd3e0508f0e0d09f19ff12a8811}"
MAX_LENGTH="${3:-4096}"

if [ -z "$CONTENT" ]; then
  echo "❌ 错误：内容为空"
  exit 1
fi

# 计算内容长度
CONTENT_LENGTH=${#CONTENT}

echo "📊 消息长度: $CONTENT_LENGTH 字符"

# 情况 1：total_length <= 4096 → 直接输出
if [ $CONTENT_LENGTH -le $MAX_LENGTH ]; then
  echo "✅ 长度在限制内，直接发送（1 条消息）"
  /root/.nvm/versions/node/v22.22.0/bin/node /root/.nvm/versions/node/v22.22.0/lib/node_modules/openclaw/dist/index.js \
    message send \
    --channel feishu \
    --target "$TARGET" \
    --message "$CONTENT"
  exit $?
fi

# 情况 2：total_length > 4096 → 分批发送
echo "⚠️ 长度超过限制，需要分批发送"

# 使用 Python 脚本进行智能分割
python3 /root/.openclaw/workspace/ai-daily-digest/split-feishu-message.py \
  <(echo "$CONTENT") \
  "$TARGET"

echo "✅ 分批发送完成"
