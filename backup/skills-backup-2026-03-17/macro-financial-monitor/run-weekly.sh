#!/bin/bash

# 宏观财务监控周报脚本
# 监控内容：银行贷款政策、利息变化
# 时间范围：过去7天

set -e

OUTPUT_DIR="/tmp/macro-financial-monitor"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p "$OUTPUT_DIR"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 宏观财务监控 - 周报数据收集"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "开始时间：$(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 银行贷款政策（2个搜索）
echo "🏦 银行贷款政策（2个搜索）"

echo "   🔍 银行贷款利率..."
tavily search "银行贷款利率 最新" --topic news --days 7 --max-results 10 > "$OUTPUT_DIR/D4_loanrate_${TIMESTAMP}.txt" 2>&1 &
PID1=$!

echo "   🔍 央行降准政策..."
tavily search "央行降准 政策" --topic news --days 7 --max-results 10 > "$OUTPUT_DIR/D4_rrr_${TIMESTAMP}.txt" 2>&1 &
PID2=$!

wait $PID1 $PID2
echo "   ✅ 银行贷款政策 完成（2个搜索）"
echo ""

# 利息变化（3个搜索）
echo "💰 利息变化（3个搜索）"

echo "   🔍 企业融资成本..."
tavily search "企业融资成本" --topic news --days 7 --max-results 10 > "$OUTPUT_DIR/D5_corporate_${TIMESTAMP}.txt" 2>&1 &
PID3=$!

echo "   🔍 Shibor利率..."
tavily search "Shibor 利率" --topic news --days 7 --max-results 10 > "$OUTPUT_DIR/D5_shibor_${TIMESTAMP}.txt" 2>&1 &
PID4=$!

echo "   🔍 DR007利率..."
tavily search "DR007 利率" --topic news --days 7 --max-results 10 > "$OUTPUT_DIR/D5_dr007_${TIMESTAMP}.txt" 2>&1 &
PID5=$!

wait $PID3 $PID4 $PID5
echo "   ✅ 利息变化 完成（3个搜索）"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 数据收集完成！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 收集统计："
echo "   🏦 银行贷款政策：2个搜索"
echo "   💰 利息变化：3个搜索"
echo "   ━━━━━━━━━━━━━━━━━━━━━"
echo "   📊 总计：5个定向搜索"
echo "   ⏰ 时间范围：过去7天"
echo ""
echo "📁 数据位置：$OUTPUT_DIR"
echo "⏰ 时间戳：$TIMESTAMP"
echo ""
echo "💡 下一步："
echo "   1. 分析搜索结果"
echo "   2. 生成周报（银行贷款政策 + 利息变化 + 趋势分析）"
echo "   3. 识别重要信号（政策变化、利率趋势）"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "完成时间：$(date '+%Y-%m-%d %H:%M:%S')"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
