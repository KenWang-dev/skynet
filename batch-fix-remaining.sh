#!/bin/bash
# 批量修复剩余8个监控任务的存档机制

echo "开始批量修复剩余8个监控任务..."

# 任务列表（Job ID : 编码 : 名称）
declare -A TASKS=(
    ["113acef8-31ed-4f16-80f6-2be212ed8144"]="F2:宏观财务监控周报"
    ["f92f539d-0850-46c3-a1e5-e438b6e3f020"]="G2:行业市场监控周报"
    ["37c6d64d-a7ba-4fc6-b398-8e6f2ba95020"]="H2:AI采购最佳实践周报"
    ["f5f7ded0-ce1a-41e9-8765-609551c5ba6f"]="I2:全球采购真实心声周报"
    ["7966fd1e-ead7-4a10-b38a-5b9090b7956b"]="J2:ESG绿色采购监控周报"
    ["f336b56b-d040-467c-af19-5a0d729320a1"]="K2:供应商生态系统监控周报"
    ["53e40ee7-3433-4336-bf2d-a17bf61159ee"]="E3:政策与法规监控月报"
)

# 存档步骤模板
ARCHIVE_STEP='
**存档步骤（必须！）**：
在生成报告后，立即保存到archive：
```bash
CODE="%CODE%"
NAME="%NAME%"
DATE=$(date +%Y-%m-%d)
ARCHIVE_DIR="/root/.openclaw/workspace/archive/${CODE}-${NAME}"
FILENAME="${CODE}-${DATE}.md"
mkdir -p "$ARCHIVE_DIR"
echo -e "$REPORT_CONTENT" > "${ARCHIVE_DIR}/${FILENAME}"
echo "✅ 报告已存档：${ARCHIVE_DIR}/${FILENAME}"
```
'

# 需要手动执行的cron命令
echo ""
echo "==================== 手动执行命令 ===================="
echo ""

for JOB_ID in "${!TASKS[@]}"; do
    TASK_INFO="${TASKS[$JOB_ID]}"
    CODE="${TASK_INFO%%:*}"
    NAME="${TASK_INFO#*:}"

    echo "# [$CODE] $NAME"
    echo "cron action=update jobId=\"$JOB_ID\" \\"
    echo "  patch='{\"payload\": {\"message\": \"<原始内容>\\\\n\\\\n**存档步骤（必须！）**：\\\\n\\\`\\\`\\\`bash\\\\nCODE=\\\\\"$CODE\\\\\"\\\\nNAME=\\\\\"$NAME\\\\\"\\\\nDATE=\\$(date +%Y-%m-%d)\\\\nARCHIVE_DIR=\\\\\"/root/.openclaw/workspace/archive/\\\${CODE}-\\\${NAME}\\\\\"\\\\nFILENAME=\\\${CODE}-\\\${DATE}.md\\\\nmkdir -p \\\\\"\\\$ARCHIVE_DIR\\\\\"\\\\necho -e \\\\\"\\\$REPORT_CONTENT\\\\\" > \\\\\"\\\$ARCHIVE_DIR/\\\${FILENAME}\\\\\"\\\\necho \\\\\"✅ 报告已存档：\\\$ARCHIVE_DIR/\\\${FILENAME}\\\\\"\\\\n\\\`\\\`\\\`\"}}'"
    echo ""
done

echo "==================== 说明 ===================="
echo ""
echo "由于cron tool的JSON格式限制，以上命令需要手动执行。"
echo ""
echo "执行步骤："
echo "1. 复制每个任务的命令"
echo "2. 替换 <原始内容> 为该任务当前的message内容"
echo "3. 在OpenClaw中执行cron命令"
echo ""
echo "预计完成时间：今晚22:00"
echo ""
