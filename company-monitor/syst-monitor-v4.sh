#!/bin/bash
# 生益科技监控系统 V4.0 - 实际可用版
# 股票代码：600183.SH

COMPANY_NAME="生益科技"
STOCK_CODE="600183.SH"
TIME=$(date +"%Y-%m-%d %H:%M")
WORK_DIR="/root/.openclaw/workspace/company-monitor"
HISTORY_FILE="${WORK_DIR}/syst-history.json"
NEWS_URL="https://www.syst.com.cn/cn/xwsj/list_32.aspx"
ANNOUNCE_URL="https://www.syst.com.cn/cn/gsgg/list_45.aspx"

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

# 抓取新闻页面
NEWS_HTML=$(timeout 5 curl -s "$NEWS_URL" 2>/dev/null)

echo "**【新闻动态】**"
if [ -n "$NEWS_HTML" ]; then
    # 提取新闻链接和标题
    echo "$NEWS_HTML" | grep -oP 'href="info_32\.aspx\?itemid=[0-9]+">[^<]+<' | sed 's/href="//g' | sed 's/">/ /g' | sed 's/<//g' | head -5 | while read line; do
        if [ -n "$line" ]; then
            ITEMID=$(echo "$line" | grep -oP 'itemid=\K[0-9]+')
            TITLE=$(echo "$line" | grep -oP '\s.*' | sed 's/^[ \t]*//')
            if [ -n "$TITLE" ]; then
                echo "📰 $TITLE"
                echo "   https://www.syst.com.cn/cn/xwsj/info_32.aspx?itemid=$ITEMID"
            fi
        fi
    done
else
    echo "⚠️ 无法获取新闻内容"
fi

echo ""
echo "　"
echo "**【公司公告】**"

# 抓取公告页面
ANNOUNCE_HTML=$(timeout 5 curl -s "$ANNOUNCE_URL" 2>/dev/null)

if [ -n "$ANNOUNCE_HTML" ]; then
    echo "$ANNOUNCE_HTML" | grep -oP 'href="info_45\.aspx\?itemid=[0-9]+">[^<]+<' | sed 's/href="//g' | sed 's/">/ /g' | sed 's/<//g' | head -5 | while read line; do
        if [ -n "$line" ]; then
            ITEMID=$(echo "$line" | grep -oP 'itemid=\K[0-9]+')
            TITLE=$(echo "$line" | grep -oP '\s.*' | sed 's/^[ \t]*//')
            if [ -n "$TITLE" ]; then
                echo "📋 $TITLE"
                echo "   https://www.syst.com.cn/cn/gsgg/info_45.aspx?itemid=$ITEMID"
            fi
        fi
    done
else
    echo "⚠️ 无法获取公告内容"
fi

echo ""
echo "　"
echo "**【数据源说明】**"
echo "• 新闻中心：$NEWS_URL"
echo "• 公司公告：$ANNOUNCE_URL"
echo "• 招聘信息：https://www.syst.com.cn/cn/rczp/index_34.aspx"
echo ""
echo "**【下一步】**"
echo "⏳ 添加竞争对手监控（景旺电子、深南电路、沪电股份）"
echo "⏳ 配置定时任务（每天早上8点自动发送）"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
