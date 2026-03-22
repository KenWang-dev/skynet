#!/bin/bash
# Delta1 - AI政策推手监控脚本（日报版）
# 监控中美两国政府对 AI 的政策倾向、资金支持、人才政策、产业园区
# 时间范围：过去 24 小时

set -e

SCRIPT_DIR="/root/.openclaw/workspace/skills/delta-ai-policy-monitor"
DATA_DIR="/tmp/delta-ai-policy-monitor"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# 创建数据目录
mkdir -p "$DATA_DIR"

echo "🔍 AI 政策推手监控 - 日报数据收集（过去24小时）"
echo "⏰ 开始时间：$(date)"
echo ""

# Tavily搜索脚本路径
TAVILY_SEARCH="/root/.openclaw/workspace/skills/tavily-search/scripts/search.mjs"

# 搜索参数：新闻主题 + 过去1天
SEARCH_PARAMS="--topic news --days 1"

# ==================== 中国部分 ====================

echo "📊 【中国】政策法规"
node "$TAVILY_SEARCH" \
  "AI政策 人工智能 国务院 工信部 两会 政策文件 2026 OR site:gov.cn" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/CN_policy_daily_${TIMESTAMP}.txt" 2>&1 || true

echo "📊 【中国】资金支持"
node "$TAVILY_SEARCH" \
  "AI 大基金 银行贷款 税收优惠 产业基金 2026 OR site:xinhuanet.com OR site:people.com.cn" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/CN_funding_daily_${TIMESTAMP}.txt" 2>&1 || true

echo "📊 【中国】产业园区"
node "$TAVILY_SEARCH" \
  "AI 产业园区 算力中心 数据中心 落地 开工 2026 OR site:36kr.com" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/CN_parks_daily_${TIMESTAMP}.txt" 2>&1 || true

echo ""
echo "===================="
echo ""

# ==================== 美国部分 ====================

echo "📊 【美国】政策法规"
node "$TAVILY_SEARCH" \
  "AI policy Trump White House Congress 2026 OR site:whitehouse.gov OR site:congress.gov" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/US_policy_daily_${TIMESTAMP}.txt" 2>&1 || true

echo "📊 【美国】资金支持"
node "$TAVILY_SEARCH" \
  "AI funding CHIPS Act NSF NIST budget 2026 OR site:reuters.com OR site:axios.com" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/US_funding_daily_${TIMESTAMP}.txt" 2>&1 || true

echo "📊 【美国】Trump 相关"
node "$TAVILY_SEARCH" \
  "Trump AI artificial intelligence policy 2026 OR site:truthsocial.com OR site:x.com" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/US_trump_daily_${TIMESTAMP}.txt" 2>&1 || true

echo ""
echo "✅ 数据收集完成（过去24小时）"
echo "⏰ 完成时间：$(date)"
echo "📁 数据已保存到：${DATA_DIR}/"
echo ""
echo "下一步："
echo "  1. 分析搜索结果"
echo "  2. 生成日报（快速摘要）"
echo "  3. 发送到飞书"
