#!/bin/bash
# 生益科技（600183.SH）监控系统
# 版本：v2.0 实际可用版

COMPANY_NAME="生益科技"
STOCK_CODE="600183.SH"
BASE_URL="https://www.syst.com.cn"
TIME=$(date +"%Y-%m-%d %H:%M")
WORK_DIR="/root/.openclaw/workspace/company-monitor"
HISTORY_FILE="${WORK_DIR}/syst-history.json"
NEWS_URL="${BASE_URL}/cn/xwsj/list_32.aspx"
ANNOUNCE_URL="${BASE_URL}/cn/gsgg/list_45.aspx"

# 创建工作目录
mkdir -p "$WORK_DIR"

# 初始化历史文件
if [ ! -f "$HISTORY_FILE" ]; then
    echo "{\"last_check\": null, \"news\": [], \"announcements\": []}" > "$HISTORY_FILE"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 ${COMPANY_NAME}(${STOCK_CODE}) 监控报告"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🕐 检查时间：${TIME}"
echo ""

# 抓取新闻中心
echo "**【新闻动态】**"
NEWS_CONTENT=$(timeout 5 curl -s "$NEWS_URL" 2>/dev/null)
if [ -n "$NEWS_CONTENT" ]; then
    # 提取新闻标题（简化版，实际需要更复杂的解析）
    echo "$NEWS_CONTENT" | grep -oP '(?<=<a title=")[^"]*' | head -3 | while read title; do
        if [ -n "$title" ]; then
            echo "📰 $title"
        fi
    done
else
    echo "⚠️ 无法获取新闻内容"
fi

echo ""
echo "　"
echo "**【公司公告】**"
ANNOUNCE_CONTENT=$(timeout 5 curl -s "$ANNOUNCE_URL" 2>/dev/null)
if [ -n "$ANNOUNCE_CONTENT" ]; then
    echo "$ANNOUNCE_CONTENT" | grep -oP '(?<=<a title=")[^"]*' | head -3 | while read title; do
        if [ -n "$title" ]; then
            echo "📋 $title"
        fi
    done
else
    echo "⚠️ 无法获取公告内容"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "💡 监控渠道："
echo "• 新闻中心：${NEWS_URL}"
echo "• 公司公告：${ANNOUNCE_URL}"
echo ""
echo "• 股价：需接入股票API"
echo "• 招聘：${BASE_URL}/cn/rczp/index_34.aspx"
echo ""
echo "✅ 数据来源：官网公开信息"
