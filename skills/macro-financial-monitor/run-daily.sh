#!/bin/bash

# 宏观财务监控日报脚本
# 监控内容：原材料价格、汇率、利率
# 时间范围：过去24小时

set -e

OUTPUT_DIR="/tmp/macro-financial-monitor"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p "$OUTPUT_DIR"

# Tavily 搜索脚本路径
TAVILY_SCRIPT="/root/.openclaw/workspace/skills/tavily-search/scripts/search.mjs"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 宏观财务监控 - 日报数据收集"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "开始时间：$(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 原材料价格（6个搜索）
echo "📈 原材料价格（6个搜索）"

echo "   🔍 LME铜价..."
node "$TAVILY_SCRIPT" "LME铜价 最新" -n 5 --topic news --days 1 > "$OUTPUT_DIR/D1_copper_${TIMESTAMP}.txt" 2>&1 &
PID1=$!

echo "   🔍 铝价..."
node "$TAVILY_SCRIPT" "铝价 今日" -n 5 --topic news --days 1 > "$OUTPUT_DIR/D1_aluminum_${TIMESTAMP}.txt" 2>&1 &
PID2=$!

echo "   🔍 稀土价格..."
node "$TAVILY_SCRIPT" "稀土价格 氧化镨钕" -n 5 --topic news --days 1 > "$OUTPUT_DIR/D1_rareearth_${TIMESTAMP}.txt" 2>&1 &
PID3=$!

echo "   🔍 螺纹钢价格..."
node "$TAVILY_SCRIPT" "螺纹钢价格 今日" -n 5 --topic news --days 1 > "$OUTPUT_DIR/D1_steel_${TIMESTAMP}.txt" 2>&1 &
PID4=$!

echo "   🔍 WTI原油价格..."
node "$TAVILY_SCRIPT" "WTI原油 价格" -n 5 --topic news --days 1 > "$OUTPUT_DIR/D1_oil_${TIMESTAMP}.txt" 2>&1 &
PID5=$!

echo "   🔍 黄金价格..."
node "$TAVILY_SCRIPT" "黄金价格 今日" -n 5 --topic news --days 1 > "$OUTPUT_DIR/D1_gold_${TIMESTAMP}.txt" 2>&1 &
PID6=$!

wait $PID1 $PID2 $PID3 $PID4 $PID5 $PID6
echo "   ✅ 原材料价格 完成（6个搜索）"
echo ""

# 汇率（2个搜索）
echo "💱 汇率（2个搜索）"

echo "   🔍 美元人民币汇率..."
node "$TAVILY_SCRIPT" "美元人民币 汇率 最新" -n 5 --topic news --days 1 > "$OUTPUT_DIR/D2_usdcny_${TIMESTAMP}.txt" 2>&1 &
PID7=$!

echo "   🔍 人民币中间价..."
node "$TAVILY_SCRIPT" "人民币 中间价 今日" -n 5 --topic news --days 1 > "$OUTPUT_DIR/D2_midrate_${TIMESTAMP}.txt" 2>&1 &
PID8=$!

wait $PID7 $PID8
echo "   ✅ 汇率 完成（2个搜索）"
echo ""

# 利率（1个搜索）
echo "📉 利率（1个搜索）"

echo "   🔍 LPR利率..."
node "$TAVILY_SCRIPT" "LPR利率 最新" -n 5 --topic news --days 1 > "$OUTPUT_DIR/D3_lpr_${TIMESTAMP}.txt" 2>&1 &
PID9=$!

wait $PID9
echo "   ✅ 利率 完成（1个搜索）"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 数据收集完成！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 收集统计："
echo "   📈 原材料价格：6个搜索"
echo "   💱 汇率：2个搜索"
echo "   📉 利率：1个搜索"
echo "   ━━━━━━━━━━━━━━━━━━━━━"
echo "   📊 总计：9个定向搜索"
echo "   ⏰ 时间范围：过去24小时"
echo ""
echo "📁 数据位置：$OUTPUT_DIR"
echo "⏰ 时间戳：$TIMESTAMP"
echo ""
echo "💡 下一步："
echo "   1. 分析搜索结果"
echo "   2. 生成日报（原材料价格 + 汇率 + 利率）"
echo "   3. 识别重要信号（涨跌幅、预警阈值）"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "完成时间：$(date '+%Y-%m-%d %H:%M:%S')"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
