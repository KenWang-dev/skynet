# 服务器迁移指南

## 📋 迁移清单

### 第一步：备份当前环境（在旧服务器）

```bash
# 1. 创建备份目录
mkdir -p /tmp/openclaw-backup

# 2. 备份配置文件
cp -r ~/.openclaw/ /tmp/openclaw-backup/config

# 3. 备份工作区数据
cp -r /root/.openclaw/workspace/ /tmp/openclaw-backup/workspace

# 4. 备份技能文件
cp -r /root/.openclaw/skills/ /tmp/openclaw-backup/skills

# 5. 打包备份
cd /tmp
tar -czf openclaw-backup-$(date +%Y%m%d).tar.gz openclaw-backup/
```

### 第二步：上传备份到新服务器

```bash
# 在旧服务器上执行（替换NEW_SERVER_IP）
scp /tmp/openclaw-backup-*.tar.gz root@NEW_SERVER_IP:/tmp/
```

### 第三步：在新服务器上恢复

```bash
# 1. 解压备份
cd /tmp
tar -xzf openclaw-backup-*.tar.gz

# 2. 恢复配置文件
cp -r openclaw-backup/config/* ~/.openclaw/

# 3. 恢复工作区数据
cp -r openclaw-backup/workspace/* /root/.openclaw/workspace/

# 4. 恢复技能文件
cp -r openclaw-backup/skills/* /root/.openclaw/skills/

# 5. 设置权限
chmod -R 755 /root/.openclaw/workspace/
chmod +x /root/.openclaw/workspace/scripts/*.sh
```

### 第四步：配置环境变量

```bash
# 编辑环境变量文件
nano ~/.openclaw/config/config.yaml

# 确保以下配置正确：
# - TAVILY_API_KEY
# - 飞书 API tokens
# - QQ Bot 配置
```

### 第五步：重启 OpenClaw

```bash
# 重启服务
openclaw gateway restart
```

### 第六步：测试功能

```bash
# 1. 测试飞书发送
echo "测试消息" | openclaw send --channel feishu

# 2. 测试定时任务
openclaw cron list

# 3. 测试 Tavily 搜索
cd /root/.openclaw/workspace/skills/tavily-search
node scripts/search.mjs "测试" -n 1
```

## ⚠️ 重要提示

### 必须重新配置的项目

1. **飞书 API**
   - 检查 `plugins.entries.feishu`
   - 验证 app_id, app_secret

2. **Tavily API**
   - 验证 `TAVILY_API_KEY` 环境变量

3. **定时任务**
   - 所有 cron 任务会自动迁移
   - 但需要重新启用

### 可选配置

1. **设置 8G 内存**
   ```bash
   bash /root/.openclaw/workspace/setup-8g-memory.sh
   ```

2. **修改 SSH 防护频率**
   - 已改为 12 小时一次
   - 会自动生效

## 🎯 快速迁移（推荐）

如果新服务器已经安装了 OpenClaw，只需要：

```bash
# 1. 上传备份
scp /tmp/openclaw-backup-*.tar.gz root@NEW_SERVER_IP:/tmp/

# 2. 在新服务器上一键恢复
cd /tmp
tar -xzf openclaw-backup-*.tar.gz
cp -r openclaw-backup/config/* ~/.openclaw/
cp -r openclaw-backup/workspace/* /root/.openclaw/workspace/
cp -r openclaw-backup/skills/* /root/.openclaw/skills/

# 3. 重启
openclaw gateway restart
```

## ✅ 迁移完成检查清单

- [ ] 配置文件已恢复
- [ ] 工作区数据已恢复
- [ ] 技能文件已恢复
- [ ] 飞书 API 正常工作
- [ ] Tavily 搜索正常
- [ ] 定时任务已恢复
- [ ] 天气报告能发送
- [ ] AI 监控能运行

---

**准备好了告诉我新服务器的 IP 地址，我协助你完成迁移！**
