#!/bin/bash
# 恢复监控任务原始时间
# 创建时间：2026-03-07 19:25
# 恢复时间：2026-03-14（一周后）

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 恢复监控任务原始时间"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "⏰ 恢复时间：$(date '+%Y-%m-%d %H:%M:%S')"
echo "📋 恢复原因：测试完成，恢复正常时间表"
echo ""

# Beta1 - AI三巨头监控：8:00 → 7:05
echo "1️⃣  恢复 Beta1 - AI三巨头监控（7:05）"
cron action=update jobId=d53a7a1c-98da-463e-a810-117e97de2bc6 \
  patch='{"schedule":{"expr":"5 7 * * *","kind":"cron","tz":"Asia/Shanghai"}}'
echo "   ✅ 已恢复到 7:05"
echo ""

# A1 - 电子供应链每日情报简报：9:00 → 7:10
echo "2️⃣  恢复 A1 - 电子供应链每日情报简报（7:10）"
cron action=update jobId=df51eeb3-0afb-499e-9dc8-2ec249da91d9 \
  patch='{"schedule":{"expr":"10 7 * * *","kind":"cron","tz":"Asia/Shanghai"}}'
echo "   ✅ 已恢复到 7:10"
echo ""

# B1 - 供应链风险日报：10:00 → 7:15
echo "3️⃣  恢复 B1 - 供应链风险日报（7:15）"
cron action=update jobId=0d516cee-5fe9-4cfa-942a-c0d39c022478 \
  patch='{"schedule":{"expr":"15 7 * * *","kind":"cron","tz":"Asia/Shanghai"}}'
echo "   ✅ 已恢复到 7:15"
echo ""

# C1 - 政策与法规监控日报：11:00 → 7:20
echo "4️⃣  恢复 C1 - 政策与法规监控日报（7:20）"
cron action=update jobId=1b061019-3fc4-4dc0-aade-8d6de20ac6cb \
  patch='{"schedule":{"expr":"20 7 * * *","kind":"cron","tz":"Asia/Shanghai"}}'
echo "   ✅ 已恢复到 7:20"
echo ""

# D1 - 宏观财务日报：12:00 → 7:25
echo "5️⃣  恢复 D1 - 宏观财务日报（7:25）"
cron action=update jobId=17e273bd-c446-40e1-8a70-3ea981a55074 \
  patch='{"schedule":{"expr":"25 7 * * *","kind":"cron","tz":"Asia/Shanghai"}}'
echo "   ✅ 已恢复到 7:25"
echo ""

# Gamma1 - AI资本风向监控（日报）：13:00 → 8:35
echo "6️⃣  恢复 Gamma1 - AI资本风向监控（8:35）"
cron action=update jobId=36b50dfd-7535-44d2-a0b7-7d0fe103346e \
  patch='{"schedule":{"expr":"35 8 * * *","kind":"cron","tz":"Asia/Shanghai"}}'
echo "   ✅ 已恢复到 8:35"
echo ""

# Delta1 - AI政策推手监控（日报）：14:00 → 8:40
echo "7️⃣  恢复 Delta1 - AI政策推手监控（8:40）"
cron action=update jobId=85e02aa8-f2c4-46c4-a930-ef3dbafe1e14 \
  patch='{"schedule":{"expr":"40 8 * * *","kind":"cron","tz":"Asia/Shanghai"}}'
echo "   ✅ 已恢复到 8:40"
echo ""

# Zeta1 - AI人才流动监控（日报）：16:00 → 8:45
echo "8️⃣  恢复 Zeta1 - AI人才流动监控（8:45）"
cron action=update jobId=a8fb9ecc-6157-4c1e-8f16-3f2871000176 \
  patch='{"schedule":{"expr":"45 8 * * *","kind":"cron","tz":"Asia/Shanghai"}}'
echo "   ✅ 已恢复到 8:45"
echo ""

# Theta1 - AI社会影响监控（日报）：15:00 → 9:00
echo "9️⃣  恢复 Theta1 - AI社会影响监控（9:00）"
cron action=update jobId=4135f991-dc5e-47e1-a157-90c255029e53 \
  patch='{"schedule":{"expr":"0 9 * * *","kind":"cron","tz":"Asia/Shanghai"}}'
echo "   ✅ 已恢复到 9:00"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 所有任务已恢复到原始时间"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 恢复后的时间表："
echo "   7:00 - Alpha1（保持不变）"
echo "   7:05 - Beta1"
echo "   7:10 - A1"
echo "   7:15 - B1"
echo "   7:20 - C1"
echo "   7:25 - D1"
echo "   8:35 - Gamma1"
echo "   8:40 - Delta1"
echo "   8:45 - Zeta1"
echo "   9:00 - Theta1"
echo ""
echo "🎯 恢复完成时间：$(date '+%Y-%m-%d %H:%M:%S')"
echo ""
