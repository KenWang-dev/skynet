#!/bin/bash
# 天气提醒脚本 - 每天早上 7:35 执行
# 数据源：高德天气 API（更稳定）

AMAP_KEY="78cf2a171c27491e6a29869f791d4159"
CITY="武汉"
CITY_ADCODE="420100"
TIME=$(date +"%Y-%m-%d %H:%M")

# 获取实况天气（使用 HTTP 而不是 HTTPS）
LIVE_URL="http://restapi.amap.com/v3/weather/weatherInfo?key=${AMAP_KEY}&city=${CITY_ADCODE}&extensions=base"
LIVE_DATA=$(timeout 5 curl -s "$LIVE_URL" 2>/dev/null)

# 获取预报天气
FORECAST_URL="http://restapi.amap.com/v3/weather/weatherInfo?key=${AMAP_KEY}&city=${CITY_ADCODE}&extensions=all"
FORECAST_DATA=$(timeout 5 curl -s "$FORECAST_URL" 2>/dev/null)

# 检查数据是否获取成功
LIVE_STATUS=$(echo "$LIVE_DATA" | jq -r '.status' 2>/dev/null)
FORECAST_STATUS=$(echo "$FORECAST_DATA" | jq -r '.status' 2>/dev/null)

if [ "$LIVE_STATUS" = "1" ] && [ "$FORECAST_STATUS" = "1" ]; then
    # 解析实况天气
    TEMP=$(echo "$LIVE_DATA" | jq -r '.lives[0].temperature + "°C"' 2>/dev/null)
    HUMIDITY=$(echo "$LIVE_DATA" | jq -r '.lives[0].humidity + "%"' 2>/dev/null)
    WIND_DIR=$(echo "$LIVE_DATA" | jq -r '.lives[0].winddirection' 2>/dev/null)
    WIND_POWER=$(echo "$LIVE_DATA" | jq -r '.lives[0].windpower + "级"' 2>/dev/null)
    WEATHER_DESC=$(echo "$LIVE_DATA" | jq -r '.lives[0].weather' 2>/dev/null)

    # 解析今日预报
    TODAY_DAYTEMP=$(echo "$FORECAST_DATA" | jq -r '.forecasts[0].casts[0].daytemp + "°C"' 2>/dev/null)
    TODAY_NIGHTTEMP=$(echo "$FORECAST_DATA" | jq -r '.forecasts[0].casts[0].nighttemp + "°C"' 2>/dev/null)
    TODAY_DAYWEATHER=$(echo "$FORECAST_DATA" | jq -r '.forecasts[0].casts[0].dayweather' 2>/dev/null)

    # 计算温度范围
    if [ "$TODAY_DAYTEMP" != "°C" ] && [ "$TODAY_NIGHTTEMP" != "°C" ]; then
        DAY_NUM=$(echo "$TODAY_DAYTEMP" | sed 's/°C//')
        NIGHT_NUM=$(echo "$TODAY_NIGHTTEMP" | sed 's/°C//')
        if [ "$DAY_NUM" -gt "$NIGHT_NUM" ]; then
            TEMP_RANGE="${TODAY_NIGHTTEMP} ~ ${TODAY_DAYTEMP}"
        else
            TEMP_RANGE="${TODAY_DAYTEMP} ~ ${TODAY_NIGHTTEMP}"
        fi
    else
        TEMP_RANGE="--"
    fi

    # 穿衣建议
    TEMP_NUM=$(echo "$TEMP" | sed 's/°C//' | awk '{print int($1)}')
    if [ -n "$TEMP_NUM" ] && [ "$TEMP_NUM" -le 0 ]; then
        CLOTHING="羽绒服、厚毛衣、围巾、手套必备"
    elif [ -n "$TEMP_NUM" ] && [ "$TEMP_NUM" -le 10 ]; then
        CLOTHING="厚外套、毛衣、长裤"
    elif [ -n "$TEMP_NUM" ] && [ "$TEMP_NUM" -le 20 ]; then
        CLOTHING="薄外套、长袖衬衫"
    else
        CLOTHING="短袖、短裤"
    fi

    # 未来3天预报
    DAY1_DATE=$(echo "$FORECAST_DATA" | jq -r '.forecasts[0].casts[1].date' 2>/dev/null | sed 's/2026-//')
    DAY1_WEEK=$(echo "$FORECAST_DATA" | jq -r '.forecasts[0].casts[1].week' 2>/dev/null)
    DAY1_DAYWEATHER=$(echo "$FORECAST_DATA" | jq -r '.forecasts[0].casts[1].dayweather' 2>/dev/null)
    DAY1_DAYTEMP=$(echo "$FORECAST_DATA" | jq -r '.forecasts[0].casts[1].daytemp + "°C"' 2>/dev/null)
    DAY1_NIGHTTEMP=$(echo "$FORECAST_DATA" | jq -r '.forecasts[0].casts[1].nighttemp + "°C"' 2>/dev/null)

    DAY2_DATE=$(echo "$FORECAST_DATA" | jq -r '.forecasts[0].casts[2].date' 2>/dev/null | sed 's/2026-//')
    DAY2_WEEK=$(echo "$FORECAST_DATA" | jq -r '.forecasts[0].casts[2].week' 2>/dev/null)
    DAY2_DAYWEATHER=$(echo "$FORECAST_DATA" | jq -r '.forecasts[0].casts[2].dayweather' 2>/dev/null)
    DAY2_DAYTEMP=$(echo "$FORECAST_DATA" | jq -r '.forecasts[0].casts[2].daytemp + "°C"' 2>/dev/null)
    DAY2_NIGHTTEMP=$(echo "$FORECAST_DATA" | jq -r '.forecasts[0].casts[2].nighttemp + "°C"' 2>/dev/null)

    DAY3_DATE=$(echo "$FORECAST_DATA" | jq -r '.forecasts[0].casts[3].date' 2>/dev/null | sed 's/2026-//')
    DAY3_WEEK=$(echo "$FORECAST_DATA" | jq -r '.forecasts[0].casts[3].week' 2>/dev/null)
    DAY3_DAYWEATHER=$(echo "$FORECAST_DATA" | jq -r '.forecasts[0].casts[3].dayweather' 2>/dev/null)
    DAY3_DAYTEMP=$(echo "$FORECAST_DATA" | jq -r '.forecasts[0].casts[3].daytemp + "°C"' 2>/dev/null)
    DAY3_NIGHTTEMP=$(echo "$FORECAST_DATA" | jq -r '.forecasts[0].casts[3].nighttemp + "°C"' 2>/dev/null)

    # 格式化输出
    echo "📍 ${CITY} · ${TIME}"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "**【当前天气】**"
    echo "🌤️ ${WEATHER_DESC}，${TEMP}"
    echo "💧 湿度：${HUMIDITY}"
    echo "💨 风力：${WIND_POWER}（${WIND_DIR}）"
    echo ""
    echo "　"
    echo "**【今日预报】**"
    echo "📈 温度范围：${TEMP_RANGE}"
    echo "☁️ 白天：${TODAY_DAYWEATHER}，${TODAY_DAYTEMP}"
    echo "🌙 晚上：${TODAY_NIGHTTEMP}"
    echo ""
    echo "　"
    echo "**【生活建议】**"
    echo "👕 穿衣：${CLOTHING}"
    echo "🏃 运动：适宜"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "**未来3天：**"
    echo "🗓 ${DAY1_DATE}（${DAY1_WEEK}）${DAY1_DAYWEATHER} ${DAY1_NIGHTTEMP}~${DAY1_DAYTEMP}"
    echo ""
    echo "🗓 ${DAY2_DATE}（${DAY2_WEEK}）${DAY2_DAYWEATHER} ${DAY2_NIGHTTEMP}~${DAY2_DAYTEMP}"
    echo ""
    echo "🗓 ${DAY3_DATE}（${DAY3_WEEK}）${DAY3_DAYWEATHER} ${DAY3_NIGHTTEMP}~${DAY3_DAYTEMP}"
else
    # 失败降级方案
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "⚠️ 天气数据获取失败"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📍 ${CITY} · ${TIME}"
    echo ""
    echo "❌ 高德天气 API 无响应"
    echo "• 实况天气状态: ${LIVE_STATUS}"
    echo "• 预报天气状态: ${FORECAST_STATUS}"
fi
