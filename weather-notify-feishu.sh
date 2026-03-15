#!/bin/bash
# 天气提醒脚本（带飞书发送）
# 每天早上 7:35 执行

CITY="武汉"
TIME=$(date +"%Y-%m-%d %H:%M")
KEN_ID="ou_a7195bd3e0508f0e0d09f19ff12a8811"

# 获取天气数据（5秒超时）
WEATHER_DATA=$(timeout 5 curl -s "wttr.in/${CITY}?format=j1" 2>/dev/null)

# 如果 JSON 获取成功，解析详细数据
if [ -n "$WEATHER_DATA" ]; then
    # 当前天气
    TEMP=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].temp_C + "°C"' 2>/dev/null)
    FEELS=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].FeelsLikeC + "°C"' 2>/dev/null)
    HUMIDITY=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].humidity + "%"' 2>/dev/null)
    WIND_KMH=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].windspeedKmph + " km/h"' 2>/dev/null)
    WIND_DIR=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].winddir16Point' 2>/dev/null)
    UV_INDEX=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].uvIndex' 2>/dev/null)

    # 紫外线等级
    if [ "$UV_INDEX" -le 2 ]; then
        UV_DESC="低"
    elif [ "$UV_INDEX" -le 5 ]; then
        UV_DESC="中等"
    elif [ "$UV_INDEX" -le 7 ]; then
        UV_DESC="高"
    elif [ "$UV_INDEX" -le 10 ]; then
        UV_DESC="很高"
    else
        UV_DESC="极高"
    fi

    # 天气描述（英文转中文）
    CODE=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].weatherCode' 2>/dev/null)
    case $CODE in
        113) WEATHER_DESC="晴" ;;
        116) WEATHER_DESC="多云" ;;
        119) WEATHER_DESC="阴" ;;
        122) WEATHER_DESC="阴" ;;
        263|266|293|296|299|302|305|308|353|356|359) WEATHER_DESC="雨" ;;
        *) WEATHER_DESC=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].weatherDesc[0].value' 2>/dev/null) ;;
    esac

    # 今日预报
    MAX_TEMP=$(echo "$WEATHER_DATA" | jq -r '.weather[0].maxtempC + "°C"' 2>/dev/null)
    MIN_TEMP=$(echo "$WEATHER_DATA" | jq -r '.weather[0].mintempC + "°C"' 2>/dev/null)
    RAIN_CHANCE=$(echo "$WEATHER_DATA" | jq -r '.weather[0].hourly[0].chanceofrain + "%"' 2>/dev/null)

    # 未来3天预报
    DAY1_DATE=$(date -d "+1 day" +"%-m月%-d日")
    DAY1_WEEK=$(date -d "+1 day" +"%u")
    case $DAY1_WEEK in
        1) DAY1_WEEK="周一" ;;
        2) DAY1_WEEK="周二" ;;
        3) DAY1_WEEK="周三" ;;
        4) DAY1_WEEK="周四" ;;
        5) DAY1_WEEK="周五" ;;
        6) DAY1_WEEK="周六" ;;
        7) DAY1_WEEK="周日" ;;
    esac
    DAY1_MAX=$(echo "$WEATHER_DATA" | jq -r '.weather[1].maxtempC + "°C"' 2>/dev/null)
    DAY1_MIN=$(echo "$WEATHER_DATA" | jq -r '.weather[1].mintempC + "°C"' 2>/dev/null)
    DAY1_CODE=$(echo "$WEATHER_DATA" | jq -r '.weather[1].hourly[0].weatherCode' 2>/dev/null)
    case $DAY1_CODE in
        113) DAY1_DESC="晴" ;;
        116) DAY1_DESC="多云" ;;
        119|122) DAY1_DESC="阴" ;;
        263|266|293|296|299|302|305|308|353|356|359) DAY1_DESC="雨" ;;
        *) DAY1_DESC="多云" ;;
    esac

    DAY2_DATE=$(date -d "+2 days" +"%-m月%-d日")
    DAY2_WEEK=$(date -d "+2 days" +"%u")
    case $DAY2_WEEK in
        1) DAY2_WEEK="周一" ;;
        2) DAY2_WEEK="周二" ;;
        3) DAY2_WEEK="周三" ;;
        4) DAY2_WEEK="周四" ;;
        5) DAY2_WEEK="周五" ;;
        6) DAY2_WEEK="周六" ;;
        7) DAY2_WEEK="周日" ;;
    esac
    DAY2_MAX=$(echo "$WEATHER_DATA" | jq -r '.weather[2].maxtempC + "°C"' 2>/dev/null)
    DAY2_MIN=$(echo "$WEATHER_DATA" | jq -r '.weather[2].mintempC + "°C"' 2>/dev/null)
    DAY2_CODE=$(echo "$WEATHER_DATA" | jq -r '.weather[2].hourly[0].weatherCode' 2>/dev/null)
    case $DAY2_CODE in
        113) DAY2_DESC="晴" ;;
        116) DAY2_DESC="多云" ;;
        119|122) DAY2_DESC="阴" ;;
        263|266|293|296|299|302|305|308|353|356|359) DAY2_DESC="雨" ;;
        *) DAY2_DESC="多云" ;;
    esac

    # 穿衣建议（基于体感温度）
    FEELS_NUM=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].FeelsLikeC | tonumber' 2>/dev/null)
    if [ "$FEELS_NUM" -le 0 ]; then
        CLOTHING="羽绒服、厚毛衣、围巾、手套必备"
    elif [ "$FEELS_NUM" -le 10 ]; then
        CLOTHING="厚外套、毛衣、长裤"
    elif [ "$FEELS_NUM" -le 20 ]; then
        CLOTHING="薄外套、长袖衬衫"
    else
        CLOTHING="短袖、短裤"
    fi

    # 格式化消息
    MESSAGE="⏰ 天气报告

📍 ${CITY} · ${TIME}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
【当前天气】
🌤️ ${WEATHER_DESC}，${TEMP}（体感${FEELS}）
💧 湿度：${HUMIDITY}
💨 风速：${WIND_KMH}（${WIND_DIR}）
☀️ 紫外线指数：${UV_INDEX}（${UV_DESC}）

【今日预报】
📈 温度范围：${MIN_TEMP} ~ ${MAX_TEMP}
☔ 降水概率：${RAIN_CHANCE}

【生活建议】
👕 穿衣：${CLOTHING}
🏃 运动：适宜
☂️ 携带雨具：无需
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

未来3天：
🗓 ${DAY1_DATE}（${DAY1_WEEK}）${DAY1_DESC} ${DAY1_MIN}~${DAY1_MAX}
🗓 ${DAY2_DATE}（${DAY2_WEEK}）${DAY2_DESC} ${DAY2_MIN}~${DAY2_MAX}

祝你今天有美好的一天！🪭"

else
    # 降级方案：简单格式
    WEATHER=$(timeout 5 curl -s "wttr.in/${CITY}?format=%l:+%c+%t+%h+%w" 2>/dev/null)
    MESSAGE="⏰ 天气报告

${WEATHER}

祝你今天有美好的一天！🪭"
fi

# 输出到控制台（用于日志）
echo "$MESSAGE"

# 保存到临时文件（供主会话读取）
echo "$MESSAGE" > /tmp/weather-report.txt

# 通过飞书发送（使用 openclaw message 工具）
# 注意：这需要在主会话中执行，isolated 会话无法发送
echo "飞书发送需要在主会话中完成"
