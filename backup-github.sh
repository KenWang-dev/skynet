#!/bin/bash
# 自动备份脚本 - 每天凌晨 3 点执行

set -e  # 遇到错误立即退出

cd /root/.openclaw/workspace

echo "===== 开始备份：$(date) ====="

# 添加核心记忆文件
git add IDENTITY.md USER.md MEMORY.md SOUL.md inspiration.md 2>/dev/null || true

# 添加工具和项目文档
git add TODO.md TODOS.md TOOLS.md Claude.md 短视频制作方法.md 2>/dev/null || true

# 添加配置和脚本
git add Task_on_time.md weather-notify.sh backup-github.sh 2>/dev/null || true

# 添加新文档（如果存在）
git add "Claude Code Tips.md" "AI Coding项目.md" "Aiberm配置指南.md" Tips.md 2>/dev/null || true

# 添加记忆目录
git add memory/ 2>/dev/null || true

# 添加其他重要文件
git add *.md 2>/dev/null || true

# 检查是否有变更
if git diff --cached --quiet; then
    echo "无变更，跳过备份"
    echo "===== 备份跳过：$(date) ====="
    exit 0
fi

# 显示将要提交的文件
echo "将要提交的文件："
git diff --cached --name-only

# 提交变更
DATE=$(date +"%Y-%m-%d %H:%M:%S")
git commit -m "自动备份：$DATE

- 备份核心记忆文件
- 备份个人文档
- 备份配置和脚本

触发方式：定时任务（每天凌晨 3:00）"

# 推送到 GitHub
echo "正在推送到 GitHub..."
git push origin master

if [ $? -eq 0 ]; then
    echo "✅ 备份完成：$DATE"
    echo "===== 备份成功：$(date) ====="
else
    echo "❌ 推送失败：$DATE"
    echo "===== 备份失败：$(date) ====="
    exit 1
fi
