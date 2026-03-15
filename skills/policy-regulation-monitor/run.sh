#!/bin/bash
# 政策与法规监控 - 数据收集脚本（改进版）
# 5维监控 × 3大区域 × 7大行业 = 27个定向搜索
# 限定时间：过去7天的新闻动态

set -e

SCRIPT_DIR="/root/.openclaw/workspace/skills/policy-regulation-monitor"
DATA_DIR="/tmp/policy-regulation-monitor"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# 创建数据目录
mkdir -p "$DATA_DIR"

# 🔒 安全输出模式：不暴露内部框架细节
echo "🔍 开始数据收集（过去7天）..."
echo "⏱️ 开始时间：$(date)"

# 保存元数据（仅内部使用，不对外输出）
cat > "${DATA_DIR}/metadata_${TIMESTAMP}.json" << EOF
{
  "timestamp": "${TIMESTAMP}",
  "collectedAt": "$(date -Iseconds)",
  "monitorVersion": "v2.0",
  "searches": 27,
  "timeRange": "past 7 days"
}
EOF

# Tavily搜索脚本路径
TAVILY_SEARCH="/root/.openclaw/workspace/skills/tavily-search/scripts/search.mjs"

# 搜索参数：新闻主题 + 过去7天
SEARCH_PARAMS="--topic news --days 7"

# ==================== 数据收集（静默模式） ====================

# 搜索1：美国对华关税政策
node "$TAVILY_SEARCH" \
  "美国对华关税 贸易战 301关税 最新 OR site:ustr.gov OR site:commerce.gov" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D1_US_CN_tariff_${TIMESTAMP}.txt" 2>&1 || true

# 搜索2：欧盟碳边境税
node "$TAVILY_SEARCH" \
  "EU CBAM carbon border tax 碳边境调节机制 最新 OR site:ec.europa.eu" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D1_EU_CBAM_${TIMESTAMP}.txt" 2>&1 || true

# 搜索3：中国关税调整
node "$TAVILY_SEARCH" \
  "中国关税调整 降税 进口关税 最新 OR site:mofcom.gov.cn OR site:customs.gov.cn" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D1_CN_tariff_${TIMESTAMP}.txt" 2>&1 || true

# 搜索4：出口管制
node "$TAVILY_SEARCH" \
  "export control technology transfer 出口管制 技术出口 最新 OR site:bis.doc.gov" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D1_GLOBAL_export_control_${TIMESTAMP}.txt" 2>&1 || true

# 搜索5：贸易协定
node "$TAVILY_SEARCH" \
  "RCEP CPTPP trade agreement 贸易协定 最新 OR site:wto.org" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D1_GLOBAL_trade_agreement_${TIMESTAMP}.txt" 2>&1 || true

# ==================== D2 产业政策 ====================

# D2.1 中国集成电路产业政策

node "$TAVILY_SEARCH" \
  "中国集成电路产业政策 芯片政策 半导体扶持 最新 OR site:miit.gov.cn" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D2_CN_semi_policy_${TIMESTAMP}.txt" 2>&1 || true

# D2.2 欧盟芯片法案

node "$TAVILY_SEARCH" \
  "EU Chips Act 欧盟芯片法案 European Chips Act 最新 OR site:ec.europa.eu" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D2_EU_chips_act_${TIMESTAMP}.txt" 2>&1 || true

# D2.3 美国芯片与科学法案

node "$TAVILY_SEARCH" \
  "CHIPS and Science Act 美国芯片法案 semiconductor subsidy 最新 OR site:commerce.gov" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D2_US_chips_act_${TIMESTAMP}.txt" 2>&1 || true

# D2.4 新能源产业政策

node "$TAVILY_SEARCH" \
  "新能源产业政策 电动车补贴 光伏政策 最新 OR site:ndrc.gov.cn" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D2_CN_new_energy_${TIMESTAMP}.txt" 2>&1 || true

# D2.5 外资准入负面清单

node "$TAVILY_SEARCH" \
  "外资准入负面清单 negative list foreign investment 最新 OR site:ndrc.gov.cn" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D2_CN_negative_list_${TIMESTAMP}.txt" 2>&1 || true

# D2.6 国产化替代政策

node "$TAVILY_SEARCH" \
  "国产化替代 信创 政府采购国产化 最新 OR site:gov.cn" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D2_CN_localization_${TIMESTAMP}.txt" 2>&1 || true


# ==================== D3 环保法规 ====================

# D3.1 欧盟CSRD

node "$TAVILY_SEARCH" \
  "EU CSRD Corporate Sustainability Reporting Directive 最新 OR site:ec.europa.eu" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D3_EU_CSRD_${TIMESTAMP}.txt" 2>&1 || true

# D3.2 中国双碳政策

node "$TAVILY_SEARCH" \
  "双碳政策 2030碳达峰 2060碳中和 最新 OR site:ndrc.gov.cn" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D3_CN_carbon_neutral_${TIMESTAMP}.txt" 2>&1 || true

# D3.3 美国通胀削减法案（IRA）

node "$TAVILY_SEARCH" \
  "Inflation Reduction Act IRA climate policy 最新 OR site:whitehouse.gov" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D3_US_IRA_${TIMESTAMP}.txt" 2>&1 || true

# D3.4 环保标准更新

node "$TAVILY_SEARCH" \
  "排放标准 能效标准 环保标准更新 最新 OR site:mee.gov.cn" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D3_GLOBAL_env_standard_${TIMESTAMP}.txt" 2>&1 || true

# D3.5 ESG披露强制要求

node "$TAVILY_SEARCH" \
  "ESG披露 强制ESG报告 sustainability reporting 最新 OR site:ifrs.org" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D3_GLOBAL_ESG_disclosure_${TIMESTAMP}.txt" 2>&1 || true


# ==================== D4 数据安全与隐私 ====================

# D4.1 中国数据出境安全评估

node "$TAVILY_SEARCH" \
  "数据出境安全评估 跨境数据传输 PIPL 最新 OR site:cac.gov.cn" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D4_CN_data_crossborder_${TIMESTAMP}.txt" 2>&1 || true

# D4.2 欧盟AI法案

node "$TAVILY_SEARCH" \
  "EU AI Act 欧盟AI法案 artificial intelligence 最新 OR site:ec.europa.eu" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D4_EU_AI_act_${TIMESTAMP}.txt" 2>&1 || true

# D4.3 美国AI行政命令

node "$TAVILY_SEARCH" \
  "Biden AI executive order AI safety 最新 OR site:whitehouse.gov" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D4_US_AI_order_${TIMESTAMP}.txt" 2>&1 || true

# D4.4 网络安全法规

node "$TAVILY_SEARCH" \
  "网络安全法 关键信息基础设施 CII 最新 OR site:miit.gov.cn" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D4_GLOBAL_cybersecurity_${TIMESTAMP}.txt" 2>&1 || true

# D4.5 隐私保护法规

node "$TAVILY_SEARCH" \
  "GDPR PIPL privacy law 最新 OR site:edpb.europa.eu" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D4_GLOBAL_privacy_${TIMESTAMP}.txt" 2>&1 || true


# ==================== D5 供应链安全 ====================

# D5.1 美国实体清单

node "$TAVILY_SEARCH" \
  "Entity List 实体清单 export blacklist 最新 OR site:bis.doc.gov" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D5_US_entity_list_${TIMESTAMP}.txt" 2>&1 || true

# D5.2 中国反外国制裁法

node "$TAVILY_SEARCH" \
  "反外国制裁法 Anti-Foreign Sanctions Law 最新 OR site:gov.cn" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D5_CN_sanction_law_${TIMESTAMP}.txt" 2>&1 || true

# D5.3 供应链安全审查

node "$TAVILY_SEARCH" \
  "供应链安全审查 supply chain review 最新 OR site:homelandsecurity.gov" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D5_GLOBAL_supply_review_${TIMESTAMP}.txt" 2>&1 || true

# D5.4 友岸外包政策

node "$TAVILY_SEARCH" \
  "ally-shoring friend-shoring nearshoring 供应链重组 最新 OR site:trade.gov" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D5_GLOBAL_reshoring_${TIMESTAMP}.txt" 2>&1 || true

# D5.5 关键物资储备

node "$TAVILY_SEARCH" \
  "关键物资储备 稀土储备 semiconductor stockpile 最新 OR site:doi.gov" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D5_GLOBAL_stockpile_${TIMESTAMP}.txt" 2>&1 || true

# D5.6 军民两用物项管制

node "$TAVILY_SEARCH" \
  "dual-use technology 军民两用 最新 OR site:bis.doc.gov" \
  -n 8 \
  $SEARCH_PARAMS \
  > "${DATA_DIR}/D5_GLOBAL_dual_use_${TIMESTAMP}.txt" 2>&1 || true


# ==================== 完成 ====================
echo "✅ 数据收集完成（过去7天）"
echo "⏰ 完成时间：$(date)"
echo "📁 数据已保存到：${DATA_DIR}/"
