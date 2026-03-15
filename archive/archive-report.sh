#!/bin/bash
# 天网监控系统 - 简化版存档脚本
# 用于在cron任务中快速存档报告

# 用法：archive_report.sh <任务编码> <任务名称> <报告内容>

TASK_CODE="$1"
TASK_NAME="$2"
REPORT_CONTENT="$3"
SUMMARY="$4"

# 定义存档目录和文件
ARCHIVE_DIR="/root/.openclaw/workspace/archive/${TASK_CODE}-${TASK_NAME}"
ARCHIVE_FILE="${ARCHIVE_DIR}/${TASK_CODE}-$(date +%Y-%m-%d).md"
INDEX_FILE="${ARCHIVE_DIR}/${TASK_CODE}-index.md"

# 创建存档目录
mkdir -p "$ARCHIVE_DIR"

# 生成报告文件
cat > "$ARCHIVE_FILE" << EOF
# ${TASK_CODE} - ${TASK_NAME} - $(date +%Y-%m-%d)

**生成时间**：$(date '+%Y-%m-%d %H:%M:%S')
**任务编码**：${TASK_CODE}
**任务名称**：${TASK_NAME}

---

## 📊 报告内容

${REPORT_CONTENT}

---

**存档时间**：$(date '+%Y-%m-%d %H:%M:%S')
EOF

# 更新索引文档
if [ ! -f "$INDEX_FILE" ]; then
    # 创建新索引
    cat > "$INDEX_FILE" << EOF
# ${TASK_CODE} - ${TASK_NAME} - 报告索引

**任务编码**：${TASK_CODE}
**任务名称**：${TASK_NAME}
**存档位置**：/root/.openclaw/workspace/archive/${TASK_CODE}-${TASK_NAME}

---

## 📊 报告列表

### $(date +%Y年)

#### $(date +%Y年$(date +%m | sed 's/^0//')月)
- [$(date +%Y-%m-%d)](./${TASK_CODE}-$(date +%Y-%m-%d).md) - ${SUMMARY}

---

## 📈 统计数据

**总报告数**：1
**最早报告**：$(date +%Y-%m-%d)
**最新报告**：$(date +%Y-%m-%d)

---

**最后更新**：$(date '+%Y-%m-%d %H:%M:%S')
EOF
else
    # 更新现有索引
    # 检查是否已经有这个日期的报告
    if ! grep -q "$(date +%Y-%m-%d)" "$INDEX_FILE"; then
        # 在对应的月份部分添加新报告
        sed -i "/#### $(date +%Y年$(date +%m | sed 's/^0//')月)/a\\- [$(date +%Y-%m-%d)](./${TASK_CODE}-$(date +%Y-%m-%d).md) - ${SUMMARY}" "$INDEX_FILE"

        # 更新统计数据
        local total_reports=$(find "$ARCHIVE_DIR" -name "${TASK_CODE}-*.md" ! -name "${TASK_CODE}-index.md" | wc -l)
        sed -i "s/\*\*总报告数\*\*\*[0-9]*/\*\*总报告数\*\*\*$total_reports/" "$INDEX_FILE"
        sed -i "s/\*\*最新报告\*\*\*.*/\*\*最新报告\*\*\*$(date +%Y-%m-%d)/" "$INDEX_FILE"
        sed -i "s/\*\*最后更新\*\*\*.*/\*\*最后更新\*\*\*$(date '+%Y-%m-%d %H:%M:%S')/" "$INDEX_FILE"
    fi
fi

echo "✅ 报告已存档：${ARCHIVE_FILE}"
