#!/bin/bash
# ESG重要消息检测脚本（变相心跳机制）
# 每12小时检测一次，发现重要消息立即推送

set -e

SCRIPT_DIR="/root/.openclaw/workspace/skills/esg-green-procurement-monitor"
ALERT_FILE="${SCRIPT_DIR}/.esg_alert_log"
CURRENT_DATE=$(date +"%Y-%m-%d %H:%M:%S")

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 ESG重要消息检测"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "检测时间：${CURRENT_DATE}"
echo ""

# 配置
SEARCH_HOURS="12"  # 搜索过去12小时
MAX_RESULTS="5"    # 每个搜索最多5条结果

# 定义重要关键词
URGENT_KEYWORDS="
CSRD directive|CBAM implementation|碳边境调节机制|双碳政策发布
ESG disclosure|SEC climate rule|欧盟CSRD|中国ESG指引
重大政策|紧急法规|breaking regulation|urgent policy
"

echo "🔍 检测过去 ${SEARCH_HOURS} 小时的重要ESG消息..."
echo ""

# 快速搜索（使用Tavily）
TAVILY_SEARCH="/root/.openclaw/workspace/skills/tavily-search/scripts/search.mjs"

# 搜索欧盟政策
echo "📂 检测欧盟政策动态..."
TEMP_EU="/tmp/esg_alert_eu_$(date +%s).txt"
node "$TAVILY_SEARCH" \
  "CSRD directive ESRS breaking news OR CBAM implementation update" \
  -n "$MAX_RESULTS" --hours "$SEARCH_HOURS" \
  > "$TEMP_EU" 2>&1 || true

# 搜索中国政策
echo "📂 检测中国政策动态..."
TEMP_CN="/tmp/esg_alert_cn_$(date +%s).txt"
node "$TAVILY_SEARCH" \
  "双碳政策发布 绿色采购新规 ESG披露 突发政策 OR site:gov.cn 紧急通知" \
  -n "$MAX_RESULTS" --hours "$SEARCH_HOURS" \
  > "$TEMP_CN" 2>&1 || true

# 分析结果
HAS_URGENT_NEWS=false
URGENT_COUNT=0

# 检查欧盟政策
if [ -s "$TEMP_EU" ]; then
  EU_TITLES=$(grep "^- \*\*" "$TEMP_EU" | wc -l)
  if [ "$EU_TITLES" -gt 0 ]; then
    HAS_URGENT_NEWS=true
    ((URGENT_COUNT+=EU_TITLES))
    echo "   ⚠️  发现欧盟政策：${EU_TITLES}条"
  fi
fi

# 检查中国政策
if [ -s "$TEMP_CN" ]; then
  CN_TITLES=$(grep "^- \*\*" "$TEMP_CN" | wc -l)
  if [ "$CN_TITLES" -gt 0 ]; then
    HAS_URGENT_NEWS=true
    ((URGENT_COUNT+=CN_TITLES))
    echo "   ⚠️  发现中国政策：${CN_TITLES}条"
  fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$HAS_URGENT_NEWS" = true ]; then
  echo "🚨 检测到 ${URGENT_COUNT} 条重要ESG消息！"
  echo ""

  # 生成警报报告
  ALERT_REPORT="${SCRIPT_DIR}/.esg_alert_report_$(date +%Y%m%d_%H%M%S).md"

  cat > "$ALERT_REPORT" << EOF
# 🚨 ESG重要消息警报

**检测时间**：${CURRENT_DATE}
**检测范围**：过去 ${SEARCH_HOURS} 小时
**消息数量**：${URGENT_COUNT}条

---

## 📋 欧盟政策动态

$(if [ -s "$TEMP_EU" ] && [ "$(grep "^- \*\*" "$TEMP_EU" | wc -l)" -gt 0 ]; then
    grep "^- \*\*" "$TEMP_EU" | head -5
  else
    echo "_无重要动态_"
  fi)

---

## 📋 中国政策动态

$(if [ -s "$TEMP_CN" ] && [ "$(grep "^- \*\*" "$TEMP_CN" | wc -l)" -gt 0 ]; then
    grep "^- \*\*" "$TEMP_CN" | head -5
  else
    echo "_无重要动态_"
  fi)

---

## 💡 建议行动

- 如果是CSRD/CBAM相关：检查合规要求是否变化
- 如果是中国政策：评估对供应链的影响
- 如果涉及客户/供应商：及时通知相关部门

---

_这是ESG监控系统的自动警报，请根据实际情况采取行动_
EOF

  echo "📄 警报报告已生成：${ALERT_REPORT}"
  echo ""
  echo "💡 下一步：读取警报报告并发送飞书"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # 保存到日志
  echo "${CURRENT_DATE} - 发现${URGENT_COUNT}条重要消息" >> "$ALERT_FILE"

  # 这里应该发送飞书，但为了防止循环，暂时只生成报告
  exit 100  # 返回特殊代码表示需要发送警报

else
  echo "✅ 未检测到重要ESG消息"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # 记录正常日志
  echo "${CURRENT_DATE} - 无重要消息" >> "$ALERT_FILE"

  exit 0  # 正常退出
fi
