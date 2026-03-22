#!/bin/bash
# Gamma1 - AI资本风向监控脚本（日报版）
# 监控 6 家顶级风投的投资动态
# 时间范围：过去 24 小时

set -e

SCRIPT_DIR="/root/.openclaw/workspace/skills/gamma1-vc-monitor"
DATA_DIR="/tmp/gamma1-vc-monitor"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# 创建数据目录
mkdir -p "$DATA_DIR"

echo "🔍 AI 资本风向监控 - 日报数据收集（过去24小时）"
echo "⏰ 开始时间：$(date)"
echo ""

# Tavily搜索脚本路径
TAVILY_SEARCH="/root/.openclaw/workspace/skills/tavily-search/scripts/search.mjs"

# 搜索参数：新闻主题 + 过去1天
SEARCH_PARAMS="--topic news --days 1"

# ==================== 海外 3 家 ====================

echo "📊 Y Combinator（YC）"
node "$TAVILY_SEARCH" \
  "Y Combinator investment AI 2026 OR site:ycombinator.com/news" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/YC_daily_${TIMESTAMP}.txt" 2>&1 || true

echo "📊 Andreessen Horowitz（a16z）"
node "$TAVILY_SEARCH" \
  "a16z investment AI crypto 2026 OR site:a16z.com/blog" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/a16z_daily_${TIMESTAMP}.txt" 2>&1 || true

echo "📊 Sequoia Capital"
node "$TAVILY_SEARCH" \
  "Sequoia Capital investment AI 2026 OR site:sequoiacap.com/websites" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/Sequoia_daily_${TIMESTAMP}.txt" 2>&1 || true

echo ""
echo "===================="
echo ""

# ==================== 国内 3 家 ====================

echo "📊 红杉中国"
node "$TAVILY_SEARCH" \
  "红杉中国 AI 投资 2026 OR site:36kr.com/tag/红杉中国" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/SequoiaChina_daily_${TIMESTAMP}.txt" 2>&1 || true

echo "📊 IDG 资本"
node "$TAVILY_SEARCH" \
  "IDG 资本 人工智能 投资 2026 OR site:idgcapital.com" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/IDG_daily_${TIMESTAMP}.txt" 2>&1 || true

echo "📊 奇迹创业营（Miracles+）"
node "$TAVILY_SEARCH" \
  "奇迹创业营 陆奇 Miracles+ 投资 2026 OR site:miraclesplus.com" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/Miracles_daily_${TIMESTAMP}.txt" 2>&1 || true

echo ""
echo "✅ 数据收集完成（过去24小时）"
echo "⏰ 完成时间：$(date)"
echo "📁 数据已保存到：${DATA_DIR}/"
echo ""
echo "下一步："
echo "  1. 分析搜索结果"
echo "  2. 生成日报（快速摘要）"
echo "  3. 发送到飞书"
