# 🛡️ 分级巡检系统 - 设计文档

## 📋 系统概述

**目标：** 建立自动化、分级的系统健康监控和巡检机制
**原则：** 不同频率、不同深度、减少对正常服务的影响

---

## 🔄 巡检层级

### 1️⃣ 每天例行检查（Daily）

**脚本：** `check-daily.sh`
**频率：** 每天执行（建议凌晨 4:00）
**时长：** < 30秒
**影响：** 极低

**检查内容：**
- 内存使用率
- 磁盘使用率
- OpenClaw 进程状态
- 最近1小时错误日志
- 网络连通性

**适用场景：**
- 快速健康检查
- 日常监控
- 问题早期发现

---

### 2️⃣ 每周中度检查（Weekly）

**脚本：** `check-weekly.sh`
**频率：** 每周执行（建议周日凌晨 4:00）
**时长：** < 2分钟
**影响：** 低

**检查内容：**
- 系统资源详情（内存、磁盘、CPU）
- 进程和服务状态（僵尸进程、失败服务）
- 日志文件状态（大文件检查）
- **清理临时文件**（/tmp, 系统日志）
- 网络详细状态（连接统计）
- 工作区健康扫描（文件安检）

**适用场景：**
- 全面系统检查
- 定期清理维护
- 预防性维护

---

### 3️⃣ 每月大度检查（Monthly）

**脚本：** `check-monthly.sh`
**频率：** 每月执行（建议每月1日凌晨 4:00）
**时长：** 5-10分钟
**影响：** 中等（会有清理操作）

**检查内容：**
- 硬件和内核状态（CPU、内核错误）
- 存储系统详情（磁盘 I/O、大文件）
- 网络详细分析（接口、路由、端口）
- 进程和资源审计（文件描述符、进程树）
- 安全审计（登录记录、开放端口）
- 应用状态深度检查（日志分析、定时任务）
- 系统趋势分析（负载趋势、运行时间）
- **深度清理**（包管理器缓存、30天前日志）

**适用场景：**
- 全面系统审计
- 深度清理优化
- 趋势分析和规划

---

## ⏰ 定时任务配置

### 使用 cron 工具

```bash
# 编辑 crontab
crontab -e

# 添加以下任务
# 每天例行检查（凌晨 4:00）
0 4 * * * /root/.openclaw/workspace/check-daily.sh >> /root/.openclaw/workspace/logs/daily-check.log 2>&1

# 每周中度检查（周日凌晨 4:00）
0 4 * * 0 /root/.openclaw/workspace/check-weekly.sh >> /root/.openclaw/workspace/logs/weekly-check.log 2>&1

# 每月大度检查（每月1日凌晨 4:00）
0 4 1 * * /root/.openclaw/workspace/check-monthly.sh >> /root/.openclaw/workspace/logs/monthly-check.log 2>&1
```

### 使用 OpenClaw cron（推荐）

**创建定时任务：**

```bash
# 每天例行检查
openclaw cron add \
  --name "每天例行检查" \
  --schedule "0 4 * * *" \
  --payload-kind "systemEvent" \
  --text "⏰ 每天例行检查" \
  --session-target "main"

# 每周中度检查
openclaw cron add \
  --name "每周中度检查" \
  --schedule "0 4 * * 0" \
  --payload-kind "systemEvent" \
  --text "⏰ 每周中度检查" \
  --session-target "main"

# 每月大度检查
openclaw cron add \
  --name "每月大度检查" \
  --schedule "0 4 1 * *" \
  --payload-kind "systemEvent" \
  --text "⏰ 每月大度检查" \
  --session-target "main"
```

**然后修改 HEARTBEAT.md，添加检查任务触发：**

```markdown
## ⏰ 每天例行检查（每天 4:00）

当收到包含"⏰ 每天例行检查"的消息时：

1. 运行脚本：`bash /root/.openclaw/workspace/check-daily.sh`
2. 捕获脚本输出
3. 如果发现问题，通过飞书通知 Ken

## ⏰ 每周中度检查（每周日 4:00）

当收到包含"⏰ 每周中度检查"的消息时：

1. 运行脚本：`bash /root/.openclaw/workspace/check-weekly.sh`
2. 捕获脚本输出
3. 通过飞书发送报告给 Ken

## ⏰ 每月大度检查（每月1日 4:00）

当收到包含"⏰ 每月大度检查"的消息时：

1. 运行脚本：`bash /root/.openclaw/workspace/check-monthly.sh`
2. 捕获脚本输出
3. 通过飞书发送详细报告给 Ken
```

---

## 📊 告警机制

### 严重问题（ISSUES > 0）
- 立即发送飞书通知
- 标记为严重级别
- 建议立即处理

### 警告（WARNINGS > 0）
- 记录到日志
- 每周/每月报告中汇总
- 不主动通知（除非持续恶化）

### 正常（ISSUES = 0, WARNINGS = 0）
- 记录到日志
- 定期汇总报告

---

## 📁 日志管理

### 日志目录结构
```
/root/.openclaw/workspace/logs/
├── daily-check.log       # 每日检查日志
├── weekly-check.log      # 每周检查日志
├── monthly-check.log     # 每月检查日志
└── reports/
    ├── monthly-report-YYYYMMDD.txt  # 月度报告
    └── yearly-summary.txt           # 年度汇总
```

### 日志轮转
- 每日日志保留 7 天
- 每周日志保留 4 周
- 每月报告保留 12 个月

---

## 🎯 预期效果

### 短期（1个月内）
- ✅ 系统问题提前发现
- ✅ 磁盘空间可控
- ✅ 日志文件不会暴涨

### 中期（3个月内）
- ✅ 系统稳定性提升
- ✅ 资源使用趋势可见
- ✅ 主动预防性维护

### 长期（6个月+）
- ✅ 建立"荒野求生"能力
- ✅ 系统自我保护机制
- ✅ 不会因为隐性风险消失

---

## 🚀 部署步骤

1. **创建日志目录**
   ```bash
   mkdir -p /root/.openclaw/workspace/logs
   ```

2. **赋予脚本执行权限**
   ```bash
   chmod +x /root/.openclaw/workspace/check-*.sh
   ```

3. **测试运行**
   ```bash
   # 测试每天检查
   bash /root/.openclaw/workspace/check-daily.sh

   # 测试每周检查
   bash /root/.openclaw/workspace/check-weekly.sh

   # 测试每月检查（可以中止，耗时较长）
   bash /root/.openclaw/workspace/check-monthly.sh
   ```

4. **配置定时任务**
   - 选择 cron 或 OpenClaw cron
   - 根据说明添加任务

5. **监控首次运行**
   - 检查日志文件
   - 确认告警机制工作

---

**设计日期：** 2026-02-21
**版本：** 1.0
**状态：** 待部署 ✅
