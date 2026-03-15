#!/bin/bash

################################################################################
# Zeta - AI人才流动监控 - 日报监控脚本
################################################################################
# 功能：搜索过去24小时的AI人才流动情况
# 时间：每天 8:45
# 核心：快速扫描岗位数量、薪资水平、热门岗位
################################################################################

set -e

# 配置
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
TIME_RANGE="days:1"  # 过去24小时
OUTPUT_DIR="/tmp/zeta-ai-talent-monitor"
mkdir -p "$OUTPUT_DIR"

echo "🔍 AI人才流动监控 - 日报数据收集（过去24小时）"
echo "⏰ 开始时间：$(date '+%Y-%m-%d %H:%M:%S %Z')"
echo ""

################################################################################
# 1. 岗位数量
################################################################################

echo "📊 【岗位数量】"
echo ""

# AI岗位新增
echo "📊 AI岗位新增数量"
tavily search \
  -q "AI engineer job hiring recruitment past 24 hours" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/job_quantity_${TIMESTAMP}.txt" 2>&1
echo "✅ AI岗位新增数量 完成"
echo ""

# 环比变化
echo "📊 环比变化"
tavily search \
  -q "AI job hiring trend increase decrease compared to previous period" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/job_trend_${TIMESTAMP}.txt" 2>&1
echo "✅ 环比变化 完成"
echo ""

echo "===================="
echo ""

################################################################################
# 2. 薪资水平
################################################################################

echo "📊 【薪资水平】"
echo ""

# AI岗位薪资中位数
echo "📊 AI岗位薪资中位数"
tavily search \
  -q "AI engineer salary median compensation 2024" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/salary_median_${TIMESTAMP}.txt" 2>&1
echo "✅ AI岗位薪资中位数 完成"
echo ""

# 薪资溢价
echo "📊 薪资溢价"
tavily search \
  -q "AI engineer salary premium compared to other software engineer jobs" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/salary_premium_${TIMESTAMP}.txt" 2>&1
echo "✅ 薪资溢价 完成"
echo ""

echo "===================="
echo ""

################################################################################
# 3. 热门岗位
################################################################################

echo "📊 【热门岗位】"
echo ""

# 热门AI岗位
echo "📊 热门AI岗位"
tavily search \
  -q "\"AI engineer\" \"machine learning engineer\" \"prompt engineer\" \"AI product manager\" job demand trending" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/hot_jobs_${TIMESTAMP}.txt" 2>&1
echo "✅ 热门AI岗位 完成"
echo ""

# 新增岗位
echo "📊 新增岗位"
tavily search \
  -q "new AI job titles emerging \"prompt engineer\" \"AI ethicist\" \"LLM engineer\"" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/new_jobs_${TIMESTAMP}.txt" 2>&1
echo "✅ 新增岗位 完成"
echo ""

echo "===================="
echo ""

################################################################################
# 4. 企业动态
################################################################################

echo "📊 【企业动态】"
echo ""

# 大厂招聘
echo "📊 大厂招聘"
tavily search \
  -q "Google Meta Microsoft Amazon OpenAI Anthropic AI engineer hiring recruitment" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/big_tech_hiring_${TIMESTAMP}.txt" 2>&1
echo "✅ 大厂招聘 完成"
echo ""

# 创业公司招聘
echo "📊 创业公司招聘"
tavily search \
  -q "AI startup hiring recruitment Series A Series B funding" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/startup_hiring_${TIMESTAMP}.txt" 2>&1
echo "✅ 创业公司招聘 完成"
echo ""

# 地域分布
echo "📊 地域分布"
tavily search \
  -q "AI job hiring location San Francisco Bay Area New York London Beijing Shanghai" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/location_${TIMESTAMP}.txt" 2>&1
echo "✅ 地域分布 完成"
echo ""

echo "===================="
echo ""

################################################################################
# 5. 招聘平台补充
################################################################################

echo "📊 【招聘平台】"
echo ""

# LinkedIn
echo "📊 LinkedIn"
tavily search \
  -q "site:linkedin.com \"AI engineer\" \"machine learning\" hiring recruitment" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/linkedin_${TIMESTAMP}.txt" 2>&1
echo "✅ LinkedIn 完成"
echo ""

# Reddit
echo "📊 Reddit"
tavily search \
  -q "site:reddit.com/r/jobs \"AI engineer\" \"machine learning\" hiring salary" \
  -maxResults 5 \
  -days 1 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/reddit_${TIMESTAMP}.txt" 2>&1
echo "✅ Reddit 完成"
echo ""

################################################################################
# 6. 完成
################################################################################

echo "✅ 数据收集完成（过去24小时）"
echo "⏰ 完成时间：$(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "📁 数据已保存到：$OUTPUT_DIR"
echo ""
echo "下一步："
echo "  1. 分析搜索结果"
echo "  2. 统计岗位数量和薪资"
echo "  3. 生成日报（汇报风格）"
echo "  4. 发送到飞书"
