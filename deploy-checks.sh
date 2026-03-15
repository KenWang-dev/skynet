#!/bin/bash
# 分级巡检系统 - 一键部署脚本

echo "🚀 分级巡检系统部署"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 创建日志目录
echo "📁 创建日志目录..."
mkdir -p /root/.openclaw/workspace/logs
mkdir -p /root/.openclaw/workspace/logs/reports
echo "✅ 日志目录已创建"
echo ""

# 赋予脚本执行权限
echo "🔧 赋予脚本执行权限..."
chmod +x /root/.openclaw/workspace/check-daily.sh
chmod +x /root/.openclaw/workspace/check-weekly.sh
chmod +x /root/.openclaw/workspace/check-monthly.sh
chmod +x /root/.openclaw/workspace/wilderness-survival-scan.sh
chmod +x /root/.openclaw/workspace/system-health-check.sh
echo "✅ 权限已设置"
echo ""

# 测试运行（快速测试）
echo "🧪 测试运行..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "1. 测试每天例行检查..."
bash /root/.openclaw/workspace/check-daily.sh
DAILY_RESULT=$?
echo ""

echo "2. 测试系统健康检查（快速模式）..."
bash /root/.openclaw/workspace/system-health-check.sh > /tmp/quick-test.log 2>&1 &
HEALTH_PID=$!
sleep 5
if ps -p $HEALTH_PID > /dev/null; then
    echo "✅ 系统健康检查正在运行..."
    kill $HEALTH_PID 2>/dev/null
else
    echo "✅ 系统健康检查完成"
fi
echo ""

# 显示配置信息
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 部署状态"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ 脚本已就绪："
echo "   • check-daily.sh（每天例行检查）"
echo "   • check-weekly.sh（每周中度检查）"
echo "   • check-monthly.sh（每月大度检查）"
echo ""
echo "✅ 辅助工具："
echo "   • wilderness-survival-scan.sh（危险源扫描）"
echo "   • system-health-check.sh（系统健康检查）"
echo ""
echo "✅ 日志目录：/root/.openclaw/workspace/logs"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⏰ 下一步：配置定时任务"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "选择配置方式："
echo ""
echo "A. 使用系统 cron（传统方式）"
echo "   运行: crontab -e"
echo "   添加以下内容："
echo ""
echo "   # 每天例行检查（凌晨 4:00）"
echo "   0 4 * * * /root/.openclaw/workspace/check-daily.sh >> /root/.openclaw/workspace/logs/daily-check.log 2>&1"
echo ""
echo "   # 每周中度检查（周日凌晨 4:00）"
echo "   0 4 * * 0 /root/.openclaw/workspace/check-weekly.sh >> /root/.openclaw/workspace/logs/weekly-check.log 2>&1"
echo ""
echo "   # 每月大度检查（每月1日凌晨 4:00）"
echo "   0 4 1 * * /root/.openclaw/workspace/check-monthly.sh >> /root/.openclaw/workspace/logs/monthly-check.log 2>&1"
echo ""
echo ""
echo "B. 使用 OpenClaw cron（推荐，AI 自动化）"
echo "   我可以帮你创建定时任务，只需要你确认："
echo ""
echo "   • 每天例行检查：每天凌晨 4:00"
echo "   • 每周中度检查：每周日凌晨 4:00"
echo "   • 每月大度检查：每月1日凌晨 4:00"
echo ""
echo "   告诉我 '创建定时任务' 即可"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📚 详细文档：CHECK_SCHEDULE_DESIGN.md"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ 部署完成！"
