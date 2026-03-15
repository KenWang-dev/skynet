#!/bin/bash

################################################################################
# Zeta - AI人才流动监控 - 周报监控脚本
################################################################################
# 功能：搜索过去7天的AI人才流动情况
# 时间：每周六 8:48
# 核心：深度分析+交叉验证
################################################################################

set -e

# 配置
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
TIME_RANGE="days:7"  # 过去7天
OUTPUT_DIR="/tmp/zeta-ai-talent-monitor"
mkdir -p "$OUTPUT_DIR"

echo "🔍 AI人才流动监控 - 周报数据收集（过去7天）"
echo "⏰ 开始时间：$(date '+%Y-%m-%d %H:%M:%S %Z')"
echo ""

################################################################################
# 1. 趋势分析（7天）
################################################################################

echo "📊 【趋势分析】"
echo ""

# 岗位数量趋势
echo "📊 岗位数量趋势"
tavily search \
  -q "AI job hiring trend increase decrease past week 7 days" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_job_trend_${TIMESTAMP}.txt" 2>&1
echo "✅ 岗位数量趋势 完成"
echo ""

# 薪资水平趋势
echo "📊 薪资水平趋势"
tavily search \
  -q "AI engineer salary compensation trend change past week" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_salary_trend_${TIMESTAMP}.txt" 2>&1
echo "✅ 薪资水平趋势 完成"
echo ""

# 热门岗位变化
echo "📊 热门岗位变化"
tavily search \
  -q "\"AI engineer\" \"machine learning\" \"prompt engineer\" job demand trending past week" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_hot_jobs_change_${TIMESTAMP}.txt" 2>&1
echo "✅ 热门岗位变化 完成"
echo ""

echo "===================="
echo ""

################################################################################
# 2. 地域分布
################################################################################

echo "📊 【地域分布】"
echo ""

# 热门城市排名
echo "📊 热门城市排名"
tavily search \
  -q "AI job hiring ranking by city San Francisco New York London Beijing Shanghai Bangalore" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_city_ranking_${TIMESTAMP}.txt" 2>&1
echo "✅ 热门城市排名 完成"
echo ""

# 人才流向趋势
echo "📊 人才流向趋势"
tavily search \
  -q "AI talent migration relocation Silicon Valley to other cities remote work" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_talent_flow_${TIMESTAMP}.txt" 2>&1
echo "✅ 人才流向趋势 完成"
echo ""

# 产业集群分析
echo "📊 产业集群分析"
tavily search \
  -q "AI cluster hub Silicon Valley New York London Beijing Shenzhen talent concentration" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_industrial_cluster_${TIMESTAMP}.txt" 2>&1
echo "✅ 产业集群分析 完成"
echo ""

echo "===================="
echo ""

################################################################################
# 3. 企业需求
################################################################################

echo "📊 【企业需求】"
echo ""

# 大厂 vs 创业公司
echo "📊 大厂 vs 创业公司"
tavily search \
  -q "big tech vs startup AI hiring Google Meta Microsoft OpenAI Anthropic competition" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_big_tech_vs_startup_${TIMESTAMP}.txt" 2>&1
echo "✅ 大厂 vs 创业公司 完成"
echo ""

# 行业分布
echo "📊 行业分布"
tavily search \
  -q "AI talent hiring by industry finance healthcare manufacturing automotive" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_industry_distribution_${TIMESTAMP}.txt" 2>&1
echo "✅ 行业分布 完成"
echo ""

# 技能要求变化
echo "📊 技能要求变化"
tavily search \
  -q "AI engineer skills requirement Python PyTorch TensorFlow LLM LangChain past week" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_skills_requirement_${TIMESTAMP}.txt" 2>&1
echo "✅ 技能要求变化 完成"
echo ""

echo "===================="
echo ""

################################################################################
# 4. 商业落地验证
################################################################################

echo "📊 【商业落地验证】"
echo ""

# 大规模招聘企业
echo "📊 大规模招聘企业"
tavily search \
  -q "companies hiring AI engineers at scale mass hiring recruitment spree" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_mass_hiring_${TIMESTAMP}.txt" 2>&1
echo "✅ 大规模招聘企业 完成"
echo ""

# 招聘规模和薪资
echo "📊 招聘规模和薪资"
tavily search \
  -q "AI hiring scale number of positions salary compensation level 2024" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_hiring_scale_salary_${TIMESTAMP}.txt" 2>&1
echo "✅ 招聘规模和薪资 完成"
echo ""

# 融资与招聘关系
echo "📊 融资与招聘关系"
tavily search \
  -q "AI startup funding relationship with hiring recruitment Series A B C" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_funding_hiring_${TIMESTAMP}.txt" 2>&1
echo "✅ 融资与招聘关系 完成"
echo ""

echo "===================="
echo ""

################################################################################
# 5. 招聘平台深度分析
################################################################################

echo "📊 【招聘平台深度分析】"
echo ""

# LinkedIn 深度
echo "📊 LinkedIn 深度"
tavily search \
  -q "site:linkedin.com \"AI engineer\" \"machine learning\" hiring demand trend salary past week" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_linkedin_${TIMESTAMP}.txt" 2>&1
echo "✅ LinkedIn 深度 完成"
echo ""

# Reddit 深度讨论
echo "📊 Reddit 深度讨论"
tavily search \
  -q "site:reddit.com/r/jobs r/cscareerquestions r/MachineLearning AI hiring salary compensation discussion" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_reddit_${TIMESTAMP}.txt" 2>&1
echo "✅ Reddit 深度讨论 完成"
echo ""

# Blind 匿名讨论
echo "📊 Blind 匿名讨论"
tavily search \
  -q "site:teamblind.com AI engineer hiring compensation salary discussion" \
  -maxResults 10 \
  -days 7 \
  -searchDepth "basic" \
  -includeRawContent false \
  > "${OUTPUT_DIR}/weekly_blind_${TIMESTAMP}.txt" 2>&1
echo "✅ Blind 匿名讨论 完成"
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
echo "  2. 深度分析趋势和地域分布"
echo "  3. 交叉验证（Alpha、Beta、Gamma、Delta）"
echo "  4. 生成周报（汇报风格）"
echo "  5. 发送到飞书"
