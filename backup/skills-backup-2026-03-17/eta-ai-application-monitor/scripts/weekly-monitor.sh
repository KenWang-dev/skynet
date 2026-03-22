#!/bin/bash

################################################################################
# Eta - AI应用落地监控 - 周报监控脚本
################################################################################
# 功能：搜索过去7天的AI应用落地情况
# 时间：每周六 8:53
# 核心：找出ROI最高的AI应用案例（5倍增长或50%降本）
################################################################################

set -e

# 配置
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
TIME_RANGE="days:7"  # 过去7天
OUTPUT_DIR="/tmp/eta-ai-application-monitor"
mkdir -p "$OUTPUT_DIR"

echo "🔍 AI应用落地监控 - 周报数据收集（过去7天）"
echo "⏰ 开始时间：$(date '+%Y-%m-%d %H:%M:%S %Z')"
echo ""

################################################################################
# 1. 新产品发现（TOP 5）
################################################################################

echo "📊 【新产品发现】"
echo ""

# Product Hunt TOP 5
echo "📊 Product Hunt TOP 5"
tavily search \
  -q "site:producthunt.com AI artificial intelligence launch launched past week" \
  -maxResults 5 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/producthunt_top5_${TIMESTAMP}.txt" 2>&1
echo "✅ Product Hunt TOP 5 完成"
echo ""

# App Store TOP 5
echo "📊 App Store TOP 5"
tavily search \
  -q "AI artificial intelligence app store productivity tools top rated trending" \
  -maxResults 5 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/appstore_top5_${TIMESTAMP}.txt" 2>&1
echo "✅ App Store TOP 5 完成"
echo ""

# GitHub Trending TOP 5
echo "📊 GitHub Trending TOP 5"
tavily search \
  -q "site:github.com trending AI machine learning LLM past week" \
  -maxResults 5 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/github_trending_top5_${TIMESTAMP}.txt" 2>&1
echo "✅ GitHub Trending TOP 5 完成"
echo ""

echo "===================="
echo ""

################################################################################
# 2. 行业应用（7个重点行业）
################################################################################

echo "📊 【行业应用】"
echo ""

# 制造业（优先）
echo "📊 制造业"
tavily search \
  -q "AI artificial intelligence manufacturing ROI case study success \"5x\" \"5 times\" revenue growth cost reduction" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/manufacturing_${TIMESTAMP}.txt" 2>&1
echo "✅ 制造业 完成"
echo ""

# 医疗
echo "📊 医疗"
tavily search \
  -q "AI artificial intelligence healthcare medical ROI case study success \"5x\" revenue growth cost reduction" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/healthcare_${TIMESTAMP}.txt" 2>&1
echo "✅ 医疗 完成"
echo ""

# 教育
echo "📊 教育"
tavily search \
  -q "AI artificial intelligence education learning ROI case study success \"5x\" revenue growth cost reduction" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/education_${TIMESTAMP}.txt" 2>&1
echo "✅ 教育 完成"
echo ""

# 金融
echo "📊 金融"
tavily search \
  -q "AI artificial intelligence finance fintech ROI case study success \"5x\" revenue growth cost reduction" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/finance_${TIMESTAMP}.txt" 2>&1
echo "✅ 金融 完成"
echo ""

# 法律
echo "📊 法律"
tavily search \
  -q "AI artificial intelligence legal law ROI case study success \"5x\" revenue growth cost reduction" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/legal_${TIMESTAMP}.txt" 2>&1
echo "✅ 法律 完成"
echo ""

# 数据分析
echo "📊 数据分析"
tavily search \
  -q "AI artificial intelligence data analytics ROI case study success \"5x\" revenue growth cost reduction" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/data_analytics_${TIMESTAMP}.txt" 2>&1
echo "✅ 数据分析 完成"
echo ""

# 客户支持
echo "📊 客户支持"
tavily search \
  -q "AI artificial intelligence customer support service ROI case study success \"5x\" revenue growth cost reduction" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/customer_support_${TIMESTAMP}.txt" 2>&1
echo "✅ 客户支持 完成"
echo ""

echo "===================="
echo ""

################################################################################
# 3. 完成
################################################################################

echo "✅ 数据收集完成（过去7天）"
echo "⏰ 完成时间：$(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "📁 数据已保存到：$OUTPUT_DIR"
echo ""
echo "下一步："
echo "  1. 分析搜索结果"
echo "  2. 筛选ROI最高的案例（5倍增长或50%降本）"
echo "  3. 生成周报（汇报风格）"
echo "  4. 发送到飞书"
