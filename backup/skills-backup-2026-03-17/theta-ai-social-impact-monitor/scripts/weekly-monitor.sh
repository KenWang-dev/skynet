#!/bin/bash

################################################################################
# Theta - AI社会影响监控 - 周报监控脚本
################################################################################
# 功能：搜索过去7天的AI社会影响情况
# 时间：每周六 9:05
# 核心：深度分析+历史维度（尤瓦尔·赫拉利视角）
################################################################################

set -e

# 配置
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
TIME_RANGE="days:7"  # 过去7天
OUTPUT_DIR="/tmp/theta-ai-social-impact-monitor"
mkdir -p "$OUTPUT_DIR"

echo "🔍 AI社会影响监控 - 周报数据收集（过去7天）"
echo "⏰ 开始时间：$(date '+%Y-%m-%d %H:%M:%S %Z')"
echo ""

################################################################################
# 1. 个体层面（7天趋势）
################################################################################

echo "📊 【个体层面 - 本周趋势】"
echo ""

# 超级富豪
echo "📊 超级富豪"
tavily search \
  -q "ultra-rich billionaire AI artificial intelligence impact lifestyle usage view opinion past week" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_ultra_rich_${TIMESTAMP}.txt" 2>&1
echo "✅ 超级富豪 完成"
echo ""

# 中产家庭
echo "📊 中产家庭"
tavily search \
  -q "middle class AI artificial intelligence impact work life family usage opinion past week" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_middle_class_${TIMESTAMP}.txt" 2>&1
echo "✅ 中产家庭 完成"
echo ""

# 普通老百姓
echo "📊 普通老百姓"
tavily search \
  -q "general public AI artificial intelligence impact job employment opinion fear hope past week" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_general_public_${TIMESTAMP}.txt" 2>&1
echo "✅ 普通老百姓 完成"
echo ""

# 中美对比
echo "📊 中美对比"
tavily search \
  -q "China US AI artificial intelligence social impact comparison difference public opinion" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_china_us_comparison_${TIMESTAMP}.txt" 2>&1
echo "✅ 中美对比 完成"
echo ""

echo "===================="
echo ""

################################################################################
# 2. 组织层面（7天趋势）
################################################################################

echo "📊 【组织层面 - 本周趋势】"
echo ""

# 中小企业
echo "📊 中小企业"
tavily search \
  -q "SME small business AI artificial intelligence adoption efficiency cost impact past week" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_sme_${TIMESTAMP}.txt" 2>&1
echo "✅ 中小企业 完成"
echo ""

# 大公司
echo "📊 大公司"
tavily search \
  -q "large corporation AI artificial intelligence strategy business model organization impact past week" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_large_corporation_${TIMESTAMP}.txt" 2>&1
echo "✅ 大公司 完成"
echo ""

echo "===================="
echo ""

################################################################################
# 3. 研究机构层面（7天趋势）
################################################################################

echo "📊 【研究机构 - 本周观点】"
echo ""

# 学术研究
echo "📊 学术研究"
tavily search \
  -q "site:arxiv.org AI artificial intelligence social impact ethics safety governance past week" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_academic_research_${TIMESTAMP}.txt" 2>&1
echo "✅ 学术研究 完成"
echo ""

# 咨询机构
echo "📊 咨询机构"
tavily search \
  -q "McKinsey BCG Deloitte AI artificial intelligence impact report employment economy past week" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_consulting_firm_${TIMESTAMP}.txt" 2>&1
echo "✅ 咨询机构 完成"
echo ""

echo "===================="
echo ""

################################################################################
# 4. 历史维度（尤瓦尔·赫拉利视角）
################################################################################

echo "📊 【历史维度 - 尤瓦尔·赫拉利视角】"
echo ""

# 尤瓦尔·赫拉利
echo "📊 尤瓦尔·赫拉利"
tavily search \
  -q "Yuval Noah Harari AI artificial intelligence history humanity revolution interview speech" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_harari_${TIMESTAMP}.txt" 2>&1
echo "✅ 尤瓦尔·赫拉利 完成"
echo ""

# AI与历史对比
echo "📊 AI与历史对比"
tavily search \
  -q "AI revolution compared to agricultural revolution industrial revolution history humanity" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_history_comparison_${TIMESTAMP}.txt" 2>&1
echo "✅ AI与历史对比 完成"
echo ""

echo "===================="
echo ""

################################################################################
# 5. 社交媒体深度分析
################################################################################

echo "📊 【社交媒体深度分析】"
echo ""

# Reddit 深度讨论
echo "📊 Reddit"
tavily search \
  -q "site:reddit.com AI artificial intelligence social impact discussion ultra-rich middle-class employment past week" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_reddit_${TIMESTAMP}.txt" 2>&1
echo "✅ Reddit 完成"
echo ""

# YouTube 热门视频
echo "📊 YouTube"
tavily search \
  -q "site:youtube.com AI artificial intelligence social impact education documentary past week" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_youtube_${TIMESTAMP}.txt" 2>&1
echo "✅ YouTube 完成"
echo ""

################################################################################
# 6. 完成
################################################################################

echo "✅ 数据收集完成（过去7天）"
echo "⏰ 完成时间：$(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "📁 数据已保存到：$OUTPUT_DIR"
echo ""
echo "下一步："
echo "  1. 分析搜索结果"
echo "  2. 总结本周趋势"
echo "  3. 历史维度深度分析（尤瓦尔·赫拉利视角）"
echo "  4. 生成周报（汇报风格）"
echo "  5. 发送到飞书"
