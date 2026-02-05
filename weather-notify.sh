#!/bin/bash
# 天气提醒脚本 - 每天早上 7:30 执行

# 获取武汉天气
WEATHER=$(curl -s "wttr.in/武汉?format=%l:+%c+%t+%h+%w" 2>/dev/null)

# 获取当前时间
TIME=$(date +"%Y-%m-%d %H:%M")

# 输出格式：时间 + 天气信息
echo "⏰ $TIME"
echo "$WEATHER"
