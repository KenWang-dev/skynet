#!/bin/bash
# 智能分割飞书长消息
# 在语义块边界断开，避免截断

INPUT_FILE="$1"
FEISHU_TARGET="${2:-ou_a7195bd3e0508f0e0d09f19ff12a8811}"
MAX_LENGTH="${3:-4096}"  # 飞书消息长度限制

if [ ! -f "$INPUT_FILE" ]; then
  echo "错误：文件不存在 $INPUT_FILE"
  exit 1
fi

# 读取文件内容
CONTENT=$(cat "$INPUT_FILE")
TOTAL_LENGTH=${#CONTENT}

echo "原文长度: $TOTAL_LENGTH 字符"
echo "飞书限制: $MAX_LENGTH 字符"

if [ $TOTAL_LENGTH -le $MAX_LENGTH ]; then
  echo "✅ 消息长度在限制内，一次发送"
  # 一次发送
  /root/.nvm/versions/node/v22.22.0/bin/node /root/.nvm/versions/node/v22.22.0/lib/node_modules/openclaw/dist/index.js message send --channel feishu --target "$FEISHU_TARGET" --message "$CONTENT"
else
  echo "⚠️ 消息过长，需要分批发送"

  # 按照语义块分割
  # 策略：在 ## 标题或 --- 分隔线处断开
  awk -v max_len="$MAX_LENGTH" -v target="$FEISHU_TARGET" '
    BEGIN {
      current_part = ""
      part_num = 1
      print "开始分割消息..."
    }

    # 记录每个块的起始位置
    /^## / {
      # 如果当前部分已经接近限制，先发送
      if (length(current_part) > max_len * 0.8) {
        print "发送第 " part_num " 部分，长度: " length(current_part)
        system("echo " shellescape(current_part) " | /root/.nvm/versions/node/v22.22.0/bin/node /root/.nvm/versions/node/v22.22.0/lib/node_modules/openclaw/dist/index.js message send --channel feishu --target " target " --message -")
        current_part = ""
        part_num++
      }
    }

    /^---/ {
      # 分隔线也是一个好的断点
      if (length(current_part) > max_len * 0.7) {
        print "发送第 " part_num " 部分，长度: " length(current_part)
        system("echo " shellescape(current_part) " | /root/.nvm/versions/node/v22.22.0/bin/node /root/.nvm/versions/node/v22.22.0/lib/node_modules/openclaw/dist/index.js message send --channel feishu --target " target " --message -")
        current_part = ""
        part_num++
      }
    }

    # 累积内容
    {
      current_part = current_part $0 "\n"

      # 硬性限制：如果超过最大长度，强制断开
      if (length(current_part) >= max_len) {
        print "⚠️ 发送第 " part_num " 部分（强制断开），长度: " length(current_part)
        system("echo " shellescape(current_part) " | /root/.nvm/versions/node/v22.22.0/bin/node /root/.nvm/versions/node/v22.22.0/lib/node_modules/openclaw/dist/index.js message send --channel feishu --target " target " --message -")
        current_part = ""
        part_num++
      }
    }

    END {
      # 发送剩余部分
      if (length(current_part) > 0) {
        print "发送第 " part_num " 部分（最后部分），长度: " length(current_part)
        system("echo " shellescape(current_part) " | /root/.nvm/versions/node/v22.22.0/bin/node /root/.nvm/versions/node/v22.22.0/lib/node_modules/openclaw/dist/index.js message send --channel feishu --target " target " --message -")
      }
      print "✅ 分批发送完成，共 " part_num " 部分"
    }

    function shellescape(str) {
      gsub(/'\''/, "'\''\\'\'''\''", str)
      return "'\''" str "'\''"
    }
  ' "$INPUT_FILE"
fi

echo "✅ 发送完成"
