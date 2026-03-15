#!/bin/bash
# 行业市场监控 - 数据收集脚本
# 波特五力模型 + PESTEL分析框架
# 11个维度 × 3大区域 = 33个定向搜索

set -e

SCRIPT_DIR="/root/.openclaw/workspace/skills/industry-market-monitor"
DATA_DIR="/tmp/industry-market-monitor"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# 创建数据目录
mkdir -p "$DATA_DIR"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 行业市场监控 - 数据收集"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "开始时间：$(date)"
echo ""

# Tavily搜索脚本路径
TAVILY_SEARCH="/root/.openclaw/workspace/skills/tavily-search/scripts/search.mjs"

# 搜索参数：新闻主题 + 过去30天
SEARCH_PARAMS="--topic news --days 30"

# ==================== 波特五力 ====================
echo "📊 波特五力模型（10个搜索）"
echo ""

# 1. 供应商议价能力
echo "   🔍 1.1 供应商集中度..."
node "$TAVILY_SEARCH" \
  "供应商集中度 CR3 CR5 行业集中度 电子制造业 OR site:gartner.com OR site:idc.com" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/F1_supplier_concentration_${TIMESTAMP}.txt" 2>&1 || true

echo "   🔍 1.2 供应商前向整合..."
node "$TAVILY_SEARCH" \
  "供应商前向整合 纵向整合 电子行业 OR site:asiae.com" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/F1_supplier_forward_${TIMESTAMP}.txt" 2>&1 || true

# 2. 买方议价能力
echo "   🔍 2.1 买方集中度..."
node "$TAVILY_SEARCH" \
  "买方集中度 下游集中度 电子行业 OR site:idc.com" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/F2_buyer_concentration_${TIMESTAMP}.txt" 2>&1 || true

echo "   🔍 2.2 买方后向整合..."
node "$TAVILY_SEARCH" \
  "买方后向整合 客户自建产能 电子行业 OR site:caixin.com" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/F2_buyer_backward_${TIMESTAMP}.txt" 2>&1 || true

# 3. 新进入者威胁
echo "   🔍 3.1 行业进入壁垒..."
node "$TAVILY_SEARCH" \
  "电子行业进入壁垒 资本门槛 技术门槛 OR site:iresearch.com.cn" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/F3_entry_barriers_${TIMESTAMP}.txt" 2>&1 || true

echo "   🔍 3.2 新创企业融资..."
node "$TAVILY_SEARCH" \
  "电子行业初创企业 融资 A轮B轮 OR site:36kr.com" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/F3_startups_${TIMESTAMP}.txt" 2>&1 || true

# 4. 替代品威胁
echo "   🔍 4.1 替代技术..."
node "$TAVILY_SEARCH" \
  "电子替代技术 新材料 新工艺 OR site:techcrunch.com" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/F4_substitute_tech_${TIMESTAMP}.txt" 2>&1 || true

echo "   🔍 4.2 替代材料..."
node "$TAVILY_SEARCH" \
  "电子替代材料 SiC GaN 新材料 OR site:semiengineering.com" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/F4_substitute_material_${TIMESTAMP}.txt" 2>&1 || true

# 5. 行业竞争程度
echo "   🔍 5.1 行业竞争格局..."
node "$TAVILY_SEARCH" \
  "电子行业竞争格局 市场份额 价格战 OR site:idc.com" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/F5_competition_${TIMESTAMP}.txt" 2>&1 || true

echo "   🔍 5.2 行业并购..."
node "$TAVILY_SEARCH" \
  "电子行业并购 M&A 行业整合 OR site:caixin.com" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/F5_m_a_${TIMESTAMP}.txt" 2>&1 || true

echo "   ✅ 波特五力 完成（10个搜索）"
echo ""

# ==================== PESTEL ====================
echo "📊 PESTEL分析（6个搜索）"
echo ""

# P - Political
echo "   🔍 P.1 贸易政策..."
node "$TAVILY_SEARCH" \
  "电子贸易政策 关税 贸易协定 OR site:mofcom.gov.cn" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/P_trade_${TIMESTAMP}.txt" 2>&1 || true

echo "   🔍 P.2 产业政策..."
node "$TAVILY_SEARCH" \
  "电子产业政策 政府补贴 产业扶持 OR site:miit.gov.cn" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/P_industrial_${TIMESTAMP}.txt" 2>&1 || true

# E - Economic
echo "   🔍 E.1 宏观经济..."
node "$TAVILY_SEARCH" \
  "电子行业宏观经济 GDP 通胀 OR site:pbc.gov.cn" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/E_macro_${TIMESTAMP}.txt" 2>&1 || true

echo "   🔍 E.2 利率汇率..."
node "$TAVILY_SEARCH" \
  "LPR利率 汇率变化 央行 OR site:pbc.gov.cn" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/E_rates_${TIMESTAMP}.txt" 2>&1 || true

# S - Social
echo "   🔍 S.1 消费趋势..."
node "$TAVILY_SEARCH" \
  "电子消费趋势 消费者偏好 OR site:cbndata.com" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/S_consumer_${TIMESTAMP}.txt" 2>&1 || true

# T - Technological
echo "   🔍 T.1 技术突破..."
node "$TAVILY_SEARCH" \
  "电子技术突破 新技术 专利 OR site:ieee.org" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/T_tech_${TIMESTAMP}.txt" 2>&1 || true

# E - Environmental
echo "   🔍 E.1 环保法规..."
node "$TAVILY_SEARCH" \
  "电子环保法规 ESG 碳排放 OR site:mee.gov.cn" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/E_env_${TIMESTAMP}.txt" 2>&1 || true

# L - Legal
echo "   🔍 L.1 合规要求..."
node "$TAVILY_SEARCH" \
  "电子合规要求 法律诉讼 OR site:court.gov.cn" \
  -n 5 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/L_compliance_${TIMESTAMP}.txt" 2>&1 || true

echo "   ✅ PESTEL 完成（6个搜索）"
echo ""

# ==================== 完成 ====================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 数据收集完成！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 收集统计："
echo "   📊 波特五力：10个搜索"
echo "   📊 PESTEL：6个搜索"
echo "   ━━━━━━━━━━━━━━━━━━━━━━"
echo "   📊 总计：16个定向搜索"
echo "   ⏰ 时间范围：过去7天"
echo ""
echo "📁 数据位置：${DATA_DIR}/"
echo "⏰ 时间戳：${TIMESTAMP}"
echo ""
echo "💡 下一步："
echo "   1. 分析搜索结果"
echo "   2. 生成周报（波特五力 + PESTEL）"
echo "   3. 识别重要信号"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "完成时间：$(date)"
echo ""
