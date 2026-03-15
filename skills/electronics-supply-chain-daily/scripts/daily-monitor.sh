#!/bin/bash
# 电子供应链每日情报监控脚本（最终版 v10）
# 版本：v1.0
# 更新时间：2026-03-03
# 核心原则：纯空行分隔，无任何分隔线

set -e

OUTPUT_DIR="/tmp/electronics-supply-daily"
mkdir -p "$OUTPUT_DIR"

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
DATE_START=$(date -d "24 hours ago" +"%Y-%m-%d")
CURRENT_DATE=$(date +"%Y-%m-%d")
WEEKDAY=$(date +"%A" | sed 's/Monday/周一/;s/Tuesday/周二/;s/Wednesday/周三/;s/Thursday/周四/;s/Friday/周五/;s/Saturday/周六/;s/Sunday/周日/')

echo "🔍 电子供应链每日情报监控"
echo "⏰ 时间：$TIMESTAMP"
echo "📅 范围：过去 24 小时（$DATE_START 至今）"
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
# Group A: 红灯事件扫描
# ============================================
echo "🔴 Group A: 红灯事件扫描"
node "$TAVILY_DIR/scripts/search.mjs" \
  "semiconductor fire shutdown disruption explosion" \
  --topic news \
  --days 1 \
  --deep \
  -n 5 \
  > "$OUTPUT_DIR/groupa-redlight.txt" 2>&1

echo "  ✅ 红灯事件扫描完成"

# ============================================
# Group B: 核心品类趋势
# ============================================
echo "💼 Group B: 核心品类趋势"

# 存储芯片
node "$TAVILY_DIR/scripts/search.mjs" \
  "DRAM NAND Samsung Hynix price increase contract" \
  --topic news \
  --days 1 \
  --deep \
  -n 5 \
  > "$OUTPUT_DIR/groupb-memory.txt" 2>&1

# MCU/功率器件
node "$TAVILY_DIR/scripts/search.mjs" \
  "MCU microcontroller inventory level lead time" \
  --topic news \
  --days 1 \
  --deep \
  -n 3 \
  > "$OUTPUT_DIR/groupb-mcu.txt" 2>&1

# 被动元件
node "$TAVILY_DIR/scripts/search.mjs" \
  "MLCC connector lead time Murata TE Molex" \
  --topic news \
  --days 1 \
  --deep \
  -n 3 \
  > "$OUTPUT_DIR/groupb-passive.txt" 2>&1

echo "  ✅ 核心品类趋势完成"

# ============================================
# Group C: 关键指标
# ============================================
echo "💰 Group C: 关键指标"
node "$TAVILY_DIR/scripts/search.mjs" \
  "LME copper gold price daily" \
  --topic news \
  --days 1 \
  --deep \
  -n 3 \
  > "$OUTPUT_DIR/groupc-indicators.txt" 2>&1

echo "  ✅ 关键指标完成"
echo ""

# ============================================
# 生成最终报告（纯空行分隔，无分隔线）
# ============================================
echo "📊 生成最终报告..."

cat > "$OUTPUT_DIR/final-report.txt" << EOF
📊 电子供应链每日情报

${CURRENT_DATE}（${WEEKDAY}）| 过去 24 小时

🔴 红灯事件

请查看 ${OUTPUT_DIR}/groupa-redlight.txt 获取详细信息。

💼 核心品类趋势

【存储芯片】

请查看 ${OUTPUT_DIR}/groupb-memory.txt 获取详细信息。

【MCU / 功率器件】

请查看 ${OUTPUT_DIR}/groupb-mcu.txt 获取详细信息。

【被动元件】

请查看 ${OUTPUT_DIR}/groupb-passive.txt 获取详细信息。

💰 关键指标

请查看 ${OUTPUT_DIR}/groupc-indicators.txt 获取详细信息。

🎯 核心洞察

基于今日搜索结果，请关注 DRAM 价格上涨趋势对采购成本的影响。

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
echo "格式：纯空行分隔，无分隔线（v10）"
echo "下一步：AI 将分析搜索结果并生成飞书报告"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
