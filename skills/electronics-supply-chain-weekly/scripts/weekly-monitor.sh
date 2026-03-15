#!/bin/bash
# 电子供应链周度战略情报监控脚本
# 版本：v1.0
# 创建时间：2026-03-03
# 基于：日报 v17 格式 + 深度研究方法论

set -e

OUTPUT_DIR="/tmp/electronics-supply-weekly"
mkdir -p "$OUTPUT_DIR"

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
DATE_START=$(date -d "7 days ago" +"%Y-%m-%d")
DATE_END=$(date +"%Y-%m-%d")
WEEKDAY=$(date +"%A" | sed 's/Monday/周一/;s/Tuesday/周二/;s/Wednesday/周三/;s/Thursday/周四/;s/Friday/周五/;s/Saturday/周六/;s/Sunday/周日/')

echo "🔍 电子供应链周度战略情报监控"
echo "⏰ 时间：$TIMESTAMP"
echo "📅 范围：过去 7 天（$DATE_START 至 $DATE_END）"
echo ""

TAVILY_DIR="/root/.openclaw/workspace/skills/tavily-search"

# 检查依赖
if [ ! -d "$TAVILY_DIR" ]; then
    echo "❌ Tavily 技能不存在：$TAVILY_DIR"
    exit 1
fi

if [ -z "$TAVILY_API_KEY" ]; then
    echo "❌ 缺少 TAVILY_API_KEY 环境变量"
    exit 1
fi

echo "📋 开始搜索任务..."
echo ""

# ============================================
# Group A: 半导体核心趋势
# ============================================
echo "📊 Group A: 半导体核心趋势"
node "$TAVILY_DIR/scripts/search.mjs" \
  "MOSFET MCU DRAM price trend weekly contract inventory" \
  --topic news \
  --days 7 \
  --deep \
  -n 10 \
  > "$OUTPUT_DIR/groupa-semiconductor.txt" 2>&1

echo "  ✅ 半导体核心趋势完成"

# ============================================
# Group B: 被动与连接器
# ============================================
echo "🔌 Group B: 被动与连接器"
node "$TAVILY_DIR/scripts/search.mjs" \
  "MLCC connector lead time TE Molex Murata price" \
  --topic news \
  --days 7 \
  --deep \
  -n 5 \
  > "$OUTPUT_DIR/groupb-passive.txt" 2>&1

echo "  ✅ 被动与连接器完成"

# ============================================
# Group C: 基础原材料
# ============================================
echo "🏭 Group C: 基础原材料"
node "$TAVILY_DIR/scripts/search.mjs" \
  "Foundry utilization CCL copper lithium price" \
  --topic news \
  --days 7 \
  --deep \
  -n 5 \
  > "$OUTPUT_DIR/groupc-materials.txt" 2>&1

echo "  ✅ 基础原材料完成"

# ============================================
# Group D: 原厂动态与财报
# ============================================
echo "🏢 Group D: 原厂动态与财报"
node "$TAVILY_DIR/scripts/search.mjs" \
  "semiconductor earnings guidance capacity expansion" \
  --topic news \
  --days 7 \
  --deep \
  -n 5 \
  > "$OUTPUT_DIR/groupd-corporate.txt" 2>&1

echo "  ✅ 原厂动态完成"

# ============================================
# Group E: 宏观与物流
# ============================================
echo "🌐 Group E: 宏观与物流"
node "$TAVILY_DIR/scripts/search.mjs" \
  "export control PMI SCFI freight USD CNY" \
  --topic news \
  --days 7 \
  --deep \
  -n 5 \
  > "$OUTPUT_DIR/groupe-macro.txt" 2>&1

echo "  ✅ 宏观与物流完成"

# ============================================
# Group F: 黑天鹅兜底
# ============================================
echo "⚠️  Group F: 黑天鹅兜底"
node "$TAVILY_DIR/scripts/search.mjs" \
  "electronic components supply chain disruption alert" \
  --topic news \
  --days 7 \
  --deep \
  -n 5 \
  > "$OUTPUT_DIR/groupf-blackswan.txt" 2>&1

echo "  ✅ 黑天鹅兜底完成"

# ============================================
# Group G: 自然灾害
# ============================================
echo "🌋 Group G: 自然灾害"
node "$TAVILY_DIR/scripts/search.mjs" \
  "earthquake typhoon flood drought semiconductor impact" \
  --topic news \
  --days 7 \
  --deep \
  -n 5 \
  > "$OUTPUT_DIR/groupg-disaster.txt" 2>&1

echo "  ✅ 自然灾害完成"
echo ""

# ============================================
# 生成最终报告
# ============================================
echo "📊 生成最终报告..."

cat > "$OUTPUT_DIR/final-report.txt" << EOF
📊 **电子供应链周度战略情报**

**报告周期**：${DATE_START} 至 ${DATE_END}（${WEEKDAY}）

　　

🔴 **红灯事件验证与追踪**

请查看 ${OUTPUT_DIR}/groupf-blackswan.txt 获取详细信息。

　　

💼 **重点品类趋势**

请查看 ${OUTPUT_DIR}/groupa-semiconductor.txt 和 ${OUTPUT_DIR}/groupb-passive.txt 获取详细信息。

　　

💰 **上游原材料监测**

请查看 ${OUTPUT_DIR}/groupc-materials.txt 获取详细信息。

　　

🌐 **宏观环境与供应链生态**

请查看 ${OUTPUT_DIR}/groupe-macro.txt 和 ${OUTPUT_DIR}/groupg-disaster.txt 获取详细信息。

　　

🎯 **战略决策建议**

基于本周搜索结果的深度分析，请关注核心供应链风险和采购机会。

　　

🔔 **报告生成时间**：${TIMESTAMP}

**下周早会时间**：周一 7:45

🪭 **Claw1号**
EOF

# 输出到控制台
cat "$OUTPUT_DIR/final-report.txt"

echo ""
echo "✅ 所有任务完成！"
echo "📁 结果保存到：$OUTPUT_DIR"
echo ""
echo "📋 文件列表："
ls -lh "$OUTPUT_DIR" | tail -n +2
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "格式：全角空格分隔 + 关键词加粗（v17）"
echo "时间范围：过去 7 天"
echo "下一步：AI 将分析搜索结果并生成飞书周报"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
