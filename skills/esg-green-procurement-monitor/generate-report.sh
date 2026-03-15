#!/bin/bash
# ESG周报自动生成与存档脚本

set -e

# 配置
DATA_DIR="/tmp/esg-green-procurement-monitor"
REPORT_OUTPUT_DIR="/root/.openclaw/workspace/skills/esg-green-procurement-monitor/output"
CURRENT_DATE=$(date +"%Y-%m-%d")
WEEK_NUMBER=$(date +"%U")
REPORT_FILE="${REPORT_OUTPUT_DIR}/ESG-周报-${CURRENT_DATE}.md"
INDEX_FILE="${REPORT_OUTPUT_DIR}/index.md"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 ESG周报自动生成与存档系统"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "日期：${CURRENT_DATE}（第${WEEK_NUMBER}周）"
echo ""

# 检查数据目录是否存在
if [ ! -d "$DATA_DIR" ]; then
  echo "❌ 错误：数据目录不存在：${DATA_DIR}"
  echo "请先运行数据收集脚本：bash run-optimized.sh"
  exit 1
fi

# 检查是否有最新数据
LATEST_TIMESTAMP=$(ls -t ${DATA_DIR}/metadata_*.json 2>/dev/null | head -1 | grep -o '[0-9]\{8\}_[0-9]\{6\}')
if [ -z "$LATEST_TIMESTAMP" ]; then
  echo "❌ 错误：未找到数据文件"
  echo "请先运行数据收集脚本：bash run-optimized.sh"
  exit 1
fi

echo "✅ 检测到数据文件：${LATEST_TIMESTAMP}"
echo ""

# 检查报告是否已存在
if [ -f "$REPORT_FILE" ]; then
  echo "⚠️  报告已存在：${REPORT_FILE}"
  read -p "是否覆盖？(y/N): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 已取消"
    exit 0
  fi
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🤖 正在生成周报..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 这里调用AI生成报告（通过agentTurn）
# 注意：这个脚本本身不生成报告，而是准备数据供AI使用
echo "📋 数据准备完成！"
echo ""
echo "下一步："
echo "1. 读取数据文件：${DATA_DIR}/"
echo "2. 分析并生成周报"
echo "3. 保存到：${REPORT_FILE}"
echo "4. 更新索引：${INDEX_FILE}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 准备工作完成，等待AI生成报告"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
