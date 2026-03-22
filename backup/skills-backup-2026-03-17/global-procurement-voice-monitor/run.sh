#!/bin/bash
# 全球采购真实心声监控 - 数据收集脚本
# 使用Tavily Deep搜索过去7天的采购从业者真实心声

set -e

# 配置
OUTPUT_DIR="/tmp/global-procurement-voice-monitor"
SEARCH_DAYS="7"  # 搜索过去7天
MAX_RESULTS="15"  # 每个维度最多15条结果

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 获取当前日期
WEEK_NUMBER=$(date +"%U")
CURRENT_DATE=$(date +"%Y-%m-%d")
YEAR=$(date +"%Y")
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo "[$(date)] 开始收集全球采购真实心声数据..."
echo "搜索范围：过去 ${SEARCH_DAYS} 天"
echo "输出目录：${OUTPUT_DIR}"

# Tavily搜索脚本路径
TAVILY_SEARCH="/root/.openclaw/workspace/skills/tavily-search/scripts/search.mjs"

# D1：痛点主题 - 工作负荷与效率
echo "[$(date)] 搜索 D1.1：工作负荷与效率..."
node "$TAVILY_SEARCH" \
  "采购 工作量大 加班 流程繁琐 效率 low overtime workload procurement" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D1_workload_${TIMESTAMP}.txt" 2>&1

# D1：痛点主题 - 薪酬与职业发展
echo "[$(date)] 搜索 D1.2：薪酬与职业发展..."
node "$TAVILY_SEARCH" \
  "采购 薪资 low 职业发展 晋升 procurement salary career path promotion" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D1_salary_${TIMESTAMP}.txt" 2>&1

# D1：痛点主题 - 专业能力挑战
echo "[$(date)] 搜索 D1.3：专业能力挑战..."
node "$TAVILY_SEARCH" \
  "采购 数字化转型 技能不足 新要求 digital transformation skills procurement training" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D1_skills_${TIMESTAMP}.txt" 2>&1

# D2：抱怨对象 - 供应商端
echo "[$(date)] 搜索 D2.1：供应商端..."
node "$TAVILY_SEARCH" \
  "采购 供应商 投诉 交期 质量 配合度 supplier complaint delivery quality procurement" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D2_supplier_${TIMESTAMP}.txt" 2>&1

# D2：抱怨对象 - 内部上级/跨部门
echo "[$(date)] 搜索 D2.2：内部上级/跨部门..."
node "$TAVILY_SEARCH" \
  "采购 跨部门 协调 上司 内部摩擦 stakeholder conflict procurement internal" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D2_internal_${TIMESTAMP}.txt" 2>&1

# D2：抱怨对象 - 制度与系统
echo "[$(date)] 搜索 D2.3：制度与系统..."
node "$TAVILY_SEARCH" \
  "采购 ERP SRM 系统 审批 流程 system approval process bureaucracy procurement" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D2_system_${TIMESTAMP}.txt" 2>&1

# D3：情绪光谱 - 吐槽调侃型
echo "[$(date)] 搜索 D3.1：吐槽调侃型..."
node "$TAVILY_SEARCH" \
  "采购 吐槽 日常 槽点 procurement meme funny vent daily life" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D3_vent_${TIMESTAMP}.txt" 2>&1

# D3：情绪光谱 - 焦虑疲惫型
echo "[$(date)] 搜索 D3.2：焦虑疲惫型..."
node "$TAVILY_SEARCH" \
  "采购 疲惫 压力 焦虑 心累 procurement stress burnout tired overwhelmed" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D3_stress_${TIMESTAMP}.txt" 2>&1

# D3：情绪光谱 - 崩溃绝望型
echo "[$(date)] 搜索 D3.3：崩溃绝望型..."
node "$TAVILY_SEARCH" \
  "采购 崩溃 想辞职 后悔 转行 procurement quit regret leaving career change" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D3_crisis_${TIMESTAMP}.txt" 2>&1

# D4：事态阶段 - 困局僵持中
echo "[$(date)] 搜索 D4.1：困局僵持中..."
node "$TAVILY_SEARCH" \
  "采购 怎么办 求助 困局 僵持 stuck help procurement deadlock" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D4_stuck_${TIMESTAMP}.txt" 2>&1

# D4：事态阶段 - 已解决/复盘中
echo "[$(date)] 搜索 D4.3：已解决/复盘中..."
node "$TAVILY_SEARCH" \
  "采购 经验 教训 复盘 lessons learned procurement experience reflection" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D4_resolved_${TIMESTAMP}.txt" 2>&1

# D5：地域文化 - 中国平台
echo "[$(date)] 搜索 D5.1：中国平台（知乎/小红书/脉脉）..."
node "$TAVILY_SEARCH" \
  "site:zhihu.com OR site:xiaohongshu.com OR site:maimai.cn 采购 吐槽 职场" \
  -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D5_china_${TIMESTAMP}.txt" 2>&1

# D5：地域文化 - 印度/北美/欧洲（LinkedIn/Reddit）
echo "[$(date)] 搜索 D5.2/3：印度/欧美平台（LinkedIn/Reddit）..."
node "$TAVILY_SEARCH" \
  "site:linkedin.com OR site:reddit.com procurement vent frustrated burnout" \
  -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D5_global_${TIMESTAMP}.txt" 2>&1

# D6：角色画像 - 执行层
echo "[$(date)] 搜索 D6.1：执行层（0-3年）..."
node "$TAVILY_SEARCH" \
  "采购员 buyer assistant 采购助理 入门 junior procurement entry level" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D6_junior_${TIMESTAMP}.txt" 2>&1

# D6：角色画像 - 中层管理
echo "[$(date)] 搜索 D6.2：中层管理（3-8年）..."
node "$TAVILY_SEARCH" \
  "采购经理 category manager procurement manager middle management" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D6_middle_${TIMESTAMP}.txt" 2>&1

# D6：角色画像 - 高层决策
echo "[$(date)] 搜索 D6.3：高层决策（10年+）..."
node "$TAVILY_SEARCH" \
  "采购总监 CPO procurement director VP strategic executive" \
  --deep -n "$MAX_RESULTS" --days "$SEARCH_DAYS" \
  > "${OUTPUT_DIR}/D6_senior_${TIMESTAMP}.txt" 2>&1

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
echo "  D1 痛点主题：3个搜索（工作负荷/薪酬发展/专业能力）"
echo "  D2 抱怨对象：3个搜索（供应商/内部/系统）"
echo "  D3 情绪光谱：3个搜索（吐槽/焦虑/崩溃）"
echo "  D4 事态阶段：2个搜索（困局/已解决）"
echo "  D5 地域文化：2个搜索（中国平台/全球平台）"
echo "  D6 角色画像：3个搜索（执行层/中层/高层）"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
