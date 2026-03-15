#!/bin/bash
# 批量修复所有监控任务的存档机制

# 任务编码和名称映射
declare -A TASKS=(
    ["D1"]="供应链风险日报"
    ["E1"]="政策与法规监控日报"
    ["F1"]="宏观财务日报"
    ["C2"]="电子供应链周度战略情报"
    ["D2"]="供应链风险监控周报"
    ["E2"]="政策与法规监控周报"
    ["F2"]="宏观财务监控周报"
    ["G2"]="行业市场监控周报"
    ["H2"]="AI采购最佳实践周报"
    ["I2"]="全球采购真实心声周报"
    ["J2"]="ESG绿色采购监控周报"
    ["K2"]="供应商生态系统监控周报"
    ["E3"]="政策与法规监控月报"
)

# 存档模板
ARCHIVE_TEMPLATE='
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

echo "✅ 存档机制批量修复脚本已准备"
echo ""
echo "需要手动修改的cron任务："
for CODE in "${!TASKS[@]}"; do
    NAME="${TASKS[$CODE]}"
    echo "- [$CODE] $NAME"
done

echo ""
echo "下一步：使用cron tool逐个更新任务payload"
echo "参考格式："
echo 'cron action=update jobId="<JOB_ID>" patch=\'{"payload": {"message": "<原始内容>\\n\\n<存档模板>"}}\''
