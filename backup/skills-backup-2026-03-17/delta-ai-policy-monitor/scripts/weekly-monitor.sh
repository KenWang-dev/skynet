#!/bin/bash
# Delta2 - AI政策推手监控脚本（周报版）
# 监控中美两国政府对 AI 的政策倾向、资金支持、人才政策、产业园区
# 时间范围：过去 7 天

set -e

SCRIPT_DIR="/root/.openclaw/workspace/skills/delta-ai-policy-monitor"
DATA_DIR="/tmp/delta-ai-policy-monitor"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# 创建数据目录
mkdir -p "$DATA_DIR"

echo "🔍 AI 政策推手监控 - 周报数据收集（过去7天）"
echo "⏰ 开始时间：$(date)"
echo ""

# Tavily搜索脚本路径
TAVILY_SEARCH="/root/.openclaw/workspace/skills/tavily-search/scripts/search.mjs"

# 搜索参数：新闻主题 + 过去7天
SEARCH_PARAMS="--topic news --days 7"

# ==================== 中国部分 ====================

echo "📊 【中国】政策法规"
node "$TAVILY_SEARCH" \
  "AI政策 人工智能 国务院 工信部 发改委 两会 2026 OR site:gov.cn" \
  -n 10 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/CN_policy_weekly_${TIMESTAMP}.txt" 2>&1 || true

echo "📊 【中国】资金支持"
node "$TAVILY_SEARCH" \
  "AI 大基金 银行贷款 税收优惠 产业基金 引导基金 2026 OR site:xinhuanet.com OR site:people.com.cn OR site:caixin.com" \
  -n 10 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/CN_funding_weekly_${TIMESTAMP}.txt" 2>&1 || true

echo "📊 【中国】人才政策"
node "$TAVILY_SEARCH" \
  "AI 人才 补贴 落户政策 签证 教育 2026 OR site:gov.cn OR site:moe.gov.cn" \
  -n 10 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/CN_talent_weekly_${TIMESTAMP}.txt" 2>&1 || true

echo "📊 【中国】产业园区"
node "$TAVILY_SEARCH" \
  "AI 产业园区 算力中心 数据中心 企业入驻 基础设施 2026 OR site:36kr.com OR site:stcn.com" \
  -n 10 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/CN_parks_weekly_${TIMESTAMP}.txt" 2>&1 || true

echo "📊 【中国】区域对比"
node "$TAVILY_SEARCH" \
  "北上广深 AI 政策 深圳 上海 北京 产业园 2026 OR site:shanghai.gov.cn OR site:beijing.gov.cn" \
  -n 10 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/CN_regions_weekly_${TIMESTAMP}.txt" 2>&1 || true

echo ""
echo "===================="
echo ""

# ==================== 美国部分 ====================

echo "📊 【美国】政策法规"
node "$TAVILY_SEARCH" \
  "AI policy White House Congress bill legislation 2026 OR site:whitehouse.gov OR site:congress.gov" \
  -n 10 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/US_policy_weekly_${TIMESTAMP}.txt" 2>&1 || true

echo "📊 【美国】资金支持"
node "$TAVILY_SEARCH" \
  "AI funding CHIPS Act NSF NIST DOE federal budget 2026 OR site:reuters.com OR site:politico.com" \
  -n 10 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/US_funding_weekly_${TIMESTAMP}.txt" 2>&1 || true

echo "📊 【美国】Trump 视角"
node "$TAVILY_SEARCH" \
  "Trump AI artificial intelligence policy executive order 2026 OR site:whitehouse.gov OR site:truthsocial.com" \
  -n 10 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/US_trump_weekly_${TIMESTAMP}.txt" 2>&1 || true

echo "📊 【美国】人才政策"
node "$TAVILY_SEARCH" \
  "AI talent H-1B visa immigration NSF education 2026 OR site:dol.gov OR site:uscis.gov" \
  -n 10 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/US_talent_weekly_${TIMESTAMP}.txt" 2>&1 || true

echo "📊 【美国】区域对比"
node "$TAVILY_SEARCH" \
  "AI hubs California New York tech clusters federal state 2026 OR site:ca.gov OR site:ny.gov" \
  -n 10 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/US_regions_weekly_${TIMESTAMP}.txt" 2>&1 || true

echo ""
echo "✅ 数据收集完成（过去7天）"
echo "⏰ 完成时间：$(date)"
echo "📁 数据已保存到：${DATA_DIR}/"
echo ""
echo "下一步："
echo "  1. 分析搜索结果"
echo "  2. 生成周报（深度分析）"
echo "  3. 发送到飞书"
