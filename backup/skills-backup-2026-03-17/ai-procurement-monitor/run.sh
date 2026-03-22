#!/bin/bash
# AI采购最佳实践监控 - 数据收集脚本
# 使用Tavily Deep搜索过去7天的动态

set -e

# 配置
OUTPUT_DIR="/tmp/ai-procurement-monitor"
SEARCH_DAYS="7"  # 搜索过去7天
MAX_RESULTS="10"  # 每个维度最多10条结果

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 获取当前日期
WEEK_NUMBER=$(date +"%U")
CURRENT_DATE=$(date +"%Y-%m-%d")
YEAR=$(date +"%Y")
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo "[$(date)] 开始收集AI采购监控数据..."
echo "搜索范围：过去 ${SEARCH_DAYS} 天"
echo "输出目录：${OUTPUT_DIR}"

# Tavily搜索脚本路径
TAVILY_SEARCH="/root/.openclaw/workspace/skills/tavily-search/scripts/search.mjs"

# 维度一：全球AI采购全景扫描
echo "[$(date)] 搜索维度一：全球AI采购全景..."
node "$TAVILY_SEARCH" \
  "AI procurement market size 2025 Gartner McKinsey adoption rate electronics manufacturing trends" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/dim1_global_${TIMESTAMP}.txt" 2>&1

# 维度二：标杆企业实践
echo "[$(date)] 搜索维度二：标杆企业实践..."
node "$TAVILY_SEARCH" \
  "HP Dell Siemens Foxconn AI procurement SAP Ariba Oracle Coupa implementation case study best practices" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/dim2_benchmarks_${TIMESTAMP}.txt" 2>&1

# 维度三：AI能力成熟度
echo "[$(date)] 搜索维度三：AI能力成熟度..."
node "$TAVILY_SEARCH" \
  "AI procurement automation Copilot agent maturity model autonomous sourcing intelligent procurement" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/dim3_maturity_${TIMESTAMP}.txt" 2>&1

# 维度四：ROI与价值
echo "[$(date)] 搜索维度四：ROI与价值量化..."
node "$TAVILY_SEARCH" \
  "AI procurement ROI cost savings efficiency benchmark case study electronics manufacturing value metrics" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/dim4_roi_${TIMESTAMP}.txt" 2>&1

# 维度五：风险与合规
echo "[$(date)] 搜索维度五：风险与合规..."
node "$TAVILY_SEARCH" \
  "AI procurement data security compliance GDPR supplier risk management privacy enterprise AI governance" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/dim5_risk_${TIMESTAMP}.txt" 2>&1

# 维度六：组织转型
echo "[$(date)] 搜索维度六：组织与人才..."
node "$TAVILY_SEARCH" \
  "AI procurement team training transformation change management skills upskilling digital transformation" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/dim6_org_${TIMESTAMP}.txt" 2>&1

# 维度七：经验教训
echo "[$(date)] 搜索维度七：经验教训..."
node "$TAVILY_SEARCH" \
  "AI procurement implementation failure lessons learned challenges pitfalls best practices deployment" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/dim7_lessons_${TIMESTAMP}.txt" 2>&1

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
echo "使用以下命令查看结果："
echo "  ls -lh ${OUTPUT_DIR}/*_${TIMESTAMP}.*"

# 输出文件列表供AI读取
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "数据文件清单："
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ls -lh "${OUTPUT_DIR}"/*_${TIMESTAMP}.* | awk '{print $9, "("$5")"}'
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
