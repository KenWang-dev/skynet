#!/bin/bash
# ESG周报一键运行脚本
# 完整流程：数据收集 → 自动化分析 → 生成周报 → 保存 → 发送

set -e

SCRIPT_DIR="/root/.openclaw/workspace/skills/esg-green-procurement-monitor"
CURRENT_DATE=$(date +"%Y-%m-%d")

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 ESG周报一键运行脚本 v2.1"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "开始时间：$(date)"
echo ""

# ==================== 步骤1：数据收集 ====================
echo "📂 步骤1：数据收集（22个定向搜索）"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

bash "${SCRIPT_DIR}/run-optimized.sh"

if [ $? -ne 0 ]; then
  echo "❌ 数据收集失败"
  exit 1
fi

echo ""
echo "✅ 数据收集完成"
echo ""

# ==================== 步骤2：自动化分析 ====================
echo "🤖 步骤2：自动化分析（去重+分类+趋势）"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

bash "${SCRIPT_DIR}/auto-analyze.sh"

if [ $? -ne 0 ]; then
  echo "❌ 自动化分析失败"
  exit 1
fi

echo ""
echo "✅ 自动化分析完成"
echo ""

# ==================== 步骤3：提示AI生成周报 ====================
echo "📊 步骤3：AI生成周报"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ 数据和分析已准备完成"
echo ""
echo "📋 综合分析报告："
ANALYSIS_REPORT=$(ls -t /tmp/esg-green-procurement-monitor/analyzed/analysis_summary_*.md 2>/dev/null | head -1)
if [ -n "$ANALYSIS_REPORT" ]; then
  echo "   📄 ${ANALYSIS_REPORT}"
  echo ""
  echo "💡 基于以下分析生成周报："
  grep -A 10 "## 💡 AI生成周报建议" "$ANALYSIS_REPORT" | tail -n +2
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⏭️  下一步："
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. 阅读综合分析报告（上面已显示）"
echo "2. 基于分析结果生成周报（手动或AI）"
echo "3. 保存到：${SCRIPT_DIR}/output/ESG-周报-${CURRENT_DATE}.md"
echo "4. 更新索引：${SCRIPT_DIR}/output/index.md"
echo "5. 发送飞书给 Ken"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 一键运行完成！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "完成时间：$(date)"
echo ""
