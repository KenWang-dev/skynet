#!/bin/bash
# 自动存档包装脚本 - 确保所有监控任务都保存到 archive 目录

# 用法：
# bash auto-archive-wrapper.sh "编码" "任务名称" "报告类型" "报告内容"

CODE="$1"
NAME="$2"
TYPE="$3"
CONTENT="$4"

# 生成时间戳
DATE=$(date +%Y-%m-%d)

# 构建存档路径
ARCHIVE_DIR="/root/.openclaw/workspace/archive/${CODE}-${NAME}"
FILENAME="${CODE}-${DATE}.md"
FILEPATH="${ARCHIVE_DIR}/${FILENAME}"

# 创建目录（如果不存在）
mkdir -p "$ARCHIVE_DIR"

# 保存报告
echo -e "$CONTENT" > "$FILEPATH"

echo "✅ 报告已自动存档：$FILEPATH"

# 更新索引（可选）
# source /root/.openclaw/workspace/archive/archive-functions.sh
# update_index "$CODE" "$NAME" "$FILENAME" "$DATE" "$TYPE"

# 返回存档路径，供后续使用
echo "$FILEPATH"
