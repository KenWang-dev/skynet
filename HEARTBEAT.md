# HEARTBEAT.md

当收到以下特定 systemEvent 时，执行对应操作：

## ⏰ 天气报告（每天 7:35）

当收到包含"⏰ 天气报告"或"天气提醒任务"的消息时：

1. 运行脚本：`bash /root/.openclaw/workspace/weather-notify.sh`
2. 捕获脚本输出
3. 通过飞书发送给 Ken（ou_a7195bd3e0508f0e0d09f19ff12a8811）
4. 使用 `message` 工具，action=send, channel=feishu, target=ou_a7195bd3e0508f0e0d09f19ff12a8811

脚本输出的格式已经很好，直接发送即可。

## 📋 每日备份通知（每天 8:00）

当收到包含"📋 每日备份通知"或"备份完成通知"的消息时：

1. 检查 GitHub 最新提交时间
2. 通过飞书发送美化的备份通知给 Ken

格式示例：
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 每日备份通知
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ 凌晨 3:00 已完成 GitHub 自动备份

📦 备份内容：
• IDENTITY.md（我的身份）
• MEMORY.md（长期记忆）
• SOUL.md（灵魂准则）
• inspiration.md（灵感汇总）

🔗 仓库：https://github.com/KenWang-dev/Openclawd_feishu

✅ 所有记忆安全保存
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

祝你有美好的一天！🪭
```

---

# 其他时间

如果没有收到上述特定消息，回复：HEARTBEAT_OK
