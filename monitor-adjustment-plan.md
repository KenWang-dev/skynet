# 监控任务临时调整方案

**创建时间：** 2026-03-07 13:25
**测试周期：** 约1周
**目的：** 避免任务积压，便于逐个测试和调整

---

## 📋 原始时间表（7:00-8:00 密集时段）

| 任务 | 原时间 | Cron表达式 | 状态 |
|------|--------|-----------|------|
| Karpathy AI 博客精选 | 07:02 | `2 7 * * *` | ✅ 运行 |
| AI 三巨头监控日报 | 07:05 | `5 7 * * *` | ✅ 运行 |
| 电子供应链每日情报 | 07:10 | `10 7 * * *` | ✅ 运行 |
| 供应链风险日报 | 07:15 | `15 7 * * *` | ❌ 已停（3/1起）|
| 政策法规监控日报 | 07:18 | `18 7 * * *` | ⚠️ 待确认 |
| 宏观财务监控日报 | 07:25 | `25 7 * * *` | ✅ 运行 |
| AI 资本风向监控日报 | 07:35 | `35 7 * * *` | ⚠️ 待确认 |

---

## 🔄 临时调整方案（间隔1小时）

**新的时间表（测试期间）：**

| 任务 | 新时间 | 新Cron表达式 | 调整命令 |
|------|--------|-------------|----------|
| AI 三巨头监控日报 | 07:00 | `0 7 * * *` | 见下方 |
| 电子供应链每日情报 | 08:00 | `0 8 * * *` | 见下方 |
| 宏观财务监控日报 | 09:00 | `0 9 * * *` | 见下方 |
| 政策法规监控日报 | 10:00 | `0 10 * * *` | 见下方 |
| AI 资本风向监控日报 | 11:00 | `0 11 * * *` | 见下方 |
| Karpathy AI 博客精选 | 12:00 | `0 12 * * *` | 见下方 |

**周报保持不变：**
- 供应链风险周报：周六 10:00
- ESG 绿色采购周报：周六 14:00

---

## 🔧 执行命令（临时调整）

### 1. 更新日报任务

```bash
# AI 三巨头监控日报 - 07:00
openclaw cron update \
  --id "<job-id>" \
  --patch '{"schedule":{"kind":"cron","expr":"0 7 * * *","tz":"Asia/Shanghai"}}'

# 电子供应链每日情报 - 08:00
openclaw cron update \
  --id "<job-id>" \
  --patch '{"schedule":{"kind":"cron","expr":"0 8 * * *","tz":"Asia/Shanghai"}}'

# 宏观财务监控日报 - 09:00
openclaw cron update \
  --id "<job-id>" \
  --patch '{"schedule":{"kind":"cron","expr":"0 9 * * *","tz":"Asia/Shanghai"}}'

# 政策法规监控日报 - 10:00
openclaw cron update \
  --id "<job-id>" \
  --patch '{"schedule":{"kind":"cron","expr":"0 10 * * *","tz":"Asia/Shanghai"}}'

# AI 资本风向监控日报 - 11:00
openclaw cron update \
  --id "<job-id>" \
  --patch '{"schedule":{"kind":"cron","expr":"0 11 * * *","tz":"Asia/Shanghai"}}'

# Karpathy AI 博客精选 - 12:00
openclaw cron update \
  --id "<job-id>" \
  --patch '{"schedule":{"kind":"cron","expr":"0 12 * * *","tz":"Asia/Shanghai"}}'
```

---

## 🔙 恢复命令（测试完成后）

```bash
# 恢复原始时间表

# AI 三巨头监控日报 - 07:05
openclaw cron update \
  --id "<job-id>" \
  --patch '{"schedule":{"kind":"cron","expr":"5 7 * * *","tz":"Asia/Shanghai"}}'

# 电子供应链每日情报 - 07:10
openclaw cron update \
  --id "<job-id>" \
  --patch '{"schedule":{"kind":"cron","expr":"10 7 * * *","tz":"Asia/Shanghai"}}'

# 宏观财务监控日报 - 07:25
openclaw cron update \
  --id "<job-id>" \
  --patch '{"schedule":{"kind":"cron","expr":"25 7 * * *","tz":"Asia/Shanghai"}}'

# 政策法规监控日报 - 07:18
openclaw cron update \
  --id "<job-id>" \
  --patch '{"schedule":{"kind":"cron","expr":"18 7 * * *","tz":"Asia/Shanghai"}}'

# AI 资本风向监控日报 - 07:35
openclaw cron update \
  --id "<job-id>" \
  --patch '{"schedule":{"kind":"cron","expr":"35 7 * * *","tz":"Asia/Shanghai"}}'

# Karpathy AI 博客精选 - 07:02
openclaw cron update \
  --id "<job-id>" \
  --patch '{"schedule":{"kind":"cron","expr":"2 7 * * *","tz":"Asia/Shanghai"}}'
```

---

## 📝 注意事项

1. **需要先获取 job-id**：运行 `openclaw cron list` 查看每个任务的 ID
2. **周报任务不调整**：保持周六原时间
3. **测试周期**：约1周，根据效果决定是否延长
4. **记录观察**：每天记录任务执行情况，便于优化

---

## 📊 测试检查清单

- [ ] 所有任务在新时间正常执行
- [ ] 无积压现象
- [ ] 飞书消息发送正常
- [ ] 报告质量符合要求
- [ ] 准备恢复原始时间表

---

**维护者：** Claw1号 🪭
