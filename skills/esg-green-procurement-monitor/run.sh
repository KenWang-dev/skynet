#!/bin/bash
# ESG与绿色采购监控 - 数据收集脚本
# 使用Tavily Deep搜索过去7天的ESG与绿色采购动态

set -e

# 配置
OUTPUT_DIR="/tmp/esg-green-procurement-monitor"
SEARCH_DAYS="7"  # 搜索过去7天
MAX_RESULTS="15"  # 每个维度最多15条结果

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 获取当前日期
WEEK_NUMBER=$(date +"%U")
CURRENT_DATE=$(date +"%Y-%m-%d")
YEAR=$(date +"%Y")
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo "[$(date)] 开始收集ESG与绿色采购数据..."
echo "搜索范围：过去 ${SEARCH_DAYS} 天"
echo "输出目录：${OUTPUT_DIR}"

# Tavily搜索脚本路径
TAVILY_SEARCH="/root/.openclaw/workspace/skills/tavily-search/scripts/search.mjs"

# D1：政策与法规
echo "[$(date)] 搜索 D1.1：绿色采购政策..."
node "$TAVILY_SEARCH" \
  "green procurement policy carbon border adjustment sustainable procurement government" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D1_policy_${TIMESTAMP}.txt" 2>&1

echo "[$(date)] 搜索 D1.2：碳关税与环保法规..."
node "$TAVILY_SEARCH" \
  "CBAM carbon border tax environmental regulation RoHS REACH compliance" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D1_regulation_${TIMESTAMP}.txt" 2>&1

echo "[$(date)] 搜索 D1.3：ESG披露要求..."
node "$TAVILY_SEARCH" \
  "ESG disclosure requirement sustainability reporting CSRD directive" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D1_esg_disclosure_${TIMESTAMP}.txt" 2>&1

# D2：最佳实践
echo "[$(date)] 搜索 D2.1：绿色采购案例..."
node "$TAVILY_SEARCH" \
  "green procurement best practices case study sustainable sourcing examples" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D2_cases_${TIMESTAMP}.txt" 2>&1

echo "[$(date)] 搜索 D2.2：企业绿色供应链..."
node "$TAVILY_SEARCH" \
  "corporate sustainable supply chain green procurement strategy Apple Walmart" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D2_corporate_${TIMESTAMP}.txt" 2>&1

echo "[$(date)] 搜索 D2.3：循环经济采购..."
node "$TAVILY_SEARCH" \
  "circular economy procurement closed loop recycling sustainable materials" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D2_circular_${TIMESTAMP}.txt" 2>&1

# D3：技术与创新
echo "[$(date)] 搜索 D3.1：碳足迹追踪..."
node "$TAVILY_SEARCH" \
  "carbon footprint tracking supply chain Scope 3 emission measurement technology" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D3_carbon_${TIMESTAMP}.txt" 2>&1

echo "[$(date)] 搜索 D3.2：绿色采购技术..."
node "$TAVILY_SEARCH" \
  "green procurement technology AI blockchain sustainable sourcing platform" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D3_tech_${TIMESTAMP}.txt" 2>&1

echo "[$(date)] 搜索 D3.3：绿色新材料..."
node "$TAVILY_SEARCH" \
  "sustainable materials green innovation biodegradable alternative materials" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D3_materials_${TIMESTAMP}.txt" 2>&1

# D4：供应商ESG
echo "[$(date)] 搜索 D4.1：供应商ESG评分..."
node "$TAVILY_SEARCH" \
  "supplier ESG rating MSCI Sustainalytics EcoVadis score evaluation" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D4_rating_${TIMESTAMP}.txt" 2>&1

echo "[$(date)] 搜索 D4.2：供应商绿色管理..."
node "$TAVILY_SEARCH" \
  "supplier sustainability management green supply chain program certification" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D4_supplier_${TIMESTAMP}.txt" 2>&1

echo "[$(date)] 搜索 D4.3：Scope 3排放..."
node "$TAVILY_SEARCH" \
  "Scope 3 emission supply chain carbon accounting value chain tracking" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D4_scope3_${TIMESTAMP}.txt" 2>&1

# D5：认证与标准
echo "[$(date)] 搜索 D5.1：绿色认证体系..."
node "$TAVILY_SEARCH" \
  "green certification ISO 14001 FSC PEFC Energy Star eco-label procurement" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D5_certification_${TIMESTAMP}.txt" 2>&1

echo "[$(date)] 搜索 D5.2：ESG评级标准..."
node "$TAVILY_SEARCH" \
  "ESG rating standard GRI SASB TCFD sustainability framework benchmark" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D5_standard_${TIMESTAMP}.txt" 2>&1

echo "[$(date)] 搜索 D5.3：行业绿色标准..."
node "$TAVILY_SEARCH" \
  "industry green standard sustainable procurement guideline electronics automotive" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D5_industry_${TIMESTAMP}.txt" 2>&1

# 保存元数据
cat > "${OUTPUT_DIR}/metadata_${TIMESTAMP}.json" <<EOF
{
  "week_number": ${WEEK_NUMBER},
  "date": "${CURRENT_DATE}",
  "year": ${YEAR},
  "search_days": ${SEARCH_DAYS},
  "max_results": ${MAX_RESULTS},
  "timestamp": "${TIMESTAMP}",
  "generated_at": "$(date -Iseconds)"
}
EOF

echo "[$(date)] 数据收集完成！"
echo "结果保存在：${OUTPUT_DIR}/"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "数据文件清单："
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ls -lh "${OUTPUT_DIR}"/*_${TIMESTAMP}.* | awk '{print $9, "("$5")"}'
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 覆盖维度："
echo "  D1 政策与法规：3个搜索（政策/法规/披露）"
echo "  D2 最佳实践：3个搜索（案例/企业/循环经济）"
echo "  D3 技术与创新：3个搜索（碳足迹/技术/材料）"
echo "  D4 供应商ESG：3个搜索（评分/管理/Scope3）"
echo "  D5 认证与标准：3个搜索（认证/标准/行业）"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
