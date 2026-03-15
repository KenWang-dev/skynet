#!/bin/bash
# SSH 简易防护脚本（fail2ban 替代方案）
# 功能：自动封禁频繁失败的 SSH IP

LOG_FILE="/var/log/secure"
BANNED_IPS="/tmp/ssh-banned-ips.txt"
MAX_ATTEMPTS=5
TIME_WINDOW=600  # 10分钟

# 获取最近10分钟内失败次数超过阈值的IP
grep "$(date -d '10 minutes ago' '+%b %d %H')" $LOG_FILE 2>/dev/null | \
    grep "Failed password" | \
    awk '{print $(NF-3)}' | \
    sort | uniq -c | \
    awk -v max=$MAX_ATTEMPTS '$1 > max {print $2}' > $BANNED_IPS.tmp

# 封禁这些IP
while read ip; do
    if [ ! -z "$ip" ]; then
        # 使用 iptables 封禁
        iptables -A INPUT -s $ip -j DROP 2>/dev/null && echo "✅ 已封禁 $ip"
    fi
done < $BANNED_IPS.tmp

rm -f $BANNED_IPS.tmp

echo "🛡️ SSH 防护检查完成 - $(date '+%Y-%m-%d %H:%M:%S')"
