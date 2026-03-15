#!/bin/bash

################################################################################
# Theta - AI社会影响监控 - 日报监控脚本
################################################################################
# 功能：搜索过去24小时的AI社会影响情况
# 时间：每天 9:00
# 核心：追踪及时的、重点的、突发的、重大的事件
################################################################################

set -e

# 配置
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
TIME_RANGE="days:1"  # 过去24小时
OUTPUT_DIR="/tmp/theta-ai-social-impact-monitor"
mkdir -p "$OUTPUT_DIR"

echo "🔍 AI社会影响监控 - 日报数据收集（过去24小时）"
echo "⏰ 开始时间：$(date '+%Y-%m-%d %H:%M:%S %Z')"
echo ""

################################################################################
# 1. 个体层面
################################################################################

echo "📊 【个体层面】"
echo ""

# 超级富豪
echo "📊 超级富豪"
tavily search \
  -q "ultra-rich billionaire AI artificial intelligence impact lifestyle usage view opinion" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/ultra_rich_${TIMESTAMP}.txt" 2>&1
echo "✅ 超级富豪 完成"
echo ""

# 中产家庭
echo "📊 中产家庭"
tavily search \
  -q "middle class AI artificial intelligence impact work life family usage opinion" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/middle_class_${TIMESTAMP}.txt" 2>&1
echo "✅ 中产家庭 完成"
echo ""

# 普通老百姓
echo "📊 普通老百姓"
tavily search \
  -q "general public AI artificial intelligence impact job employment opinion fear hope" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/general_public_${TIMESTAMP}.txt" 2>&1
echo "✅ 普通老百姓 完成"
echo ""

echo "===================="
echo ""

################################################################################
# 2. 组织层面
################################################################################

echo "📊 【组织层面】"
echo ""

# 中小企业
echo "📊 中小企业"
tavily search \
  -q "SME small business AI artificial intelligence adoption efficiency cost impact" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/sme_${TIMESTAMP}.txt" 2>&1
echo "✅ 中小企业 完成"
echo ""

# 大公司
echo "📊 大公司"
tavily search \
  -q "large corporation AI artificial intelligence strategy business model organization impact" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/large_corporation_${TIMESTAMP}.txt" 2>&1
echo "✅ 大公司 完成"
echo ""

echo "===================="
echo ""

################################################################################
# 3. 研究机构层面
################################################################################

echo "📊 【研究机构】"
echo ""

# 学术研究
echo "📊 学术研究"
tavily search \
  -q "site:arxiv.org AI artificial intelligence social impact ethics safety governance" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/academic_research_${TIMESTAMP}.txt" 2>&1
echo "✅ 学术研究 完成"
echo ""

# 咨询机构
echo "📊 咨询机构"
tavily search \
  -q "McKinsey BCG Deloitte AI artificial intelligence impact report employment economy" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/consulting_firm_${TIMESTAMP}.txt" 2>&1
echo "✅ 咨询机构 完成"
echo ""

echo "===================="
echo ""

################################################################################
# 4. 社交媒体补充
################################################################################

echo "📊 【社交媒体】"
echo ""

# Reddit
echo "📊 Reddit"
tavily search \
  -q "site:reddit.com AI artificial intelligence social impact discussion ultra-rich middle-class" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/reddit_${TIMESTAMP}.txt" 2>&1
echo "✅ Reddit 完成"
echo ""

# Twitter
echo "📊 Twitter/X"
tavily search \
  -q "site:twitter.com AI artificial intelligence impact society billionaire middle-class" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/twitter_${TIMESTAMP}.txt" 2>&1
echo "✅ Twitter/X 完成"
echo ""

################################################################################
# 5. 完成
################################################################################

echo "✅ 数据收集完成（过去24小时）"
echo "⏰ 完成时间：$(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "📁 数据已保存到：$OUTPUT_DIR"
echo ""
echo "下一步："
echo "  1. 分析搜索结果"
echo "  2. 筛选重大、突发事件"
echo "  3. 生成日报（汇报风格）"
echo "  4. 发送到飞书"
