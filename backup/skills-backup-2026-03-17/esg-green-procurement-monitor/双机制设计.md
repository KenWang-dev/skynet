# ESG监控系统 - 双机制设计

## 📋 两种机制对比

### 1️⃣ 定时任务（Routine）- 周报

**用途**：周期性完整报告
**频率**：每周一次（建议周五15:00）
**特点**：
- ✅ 无论有没有新消息，都按时生成
- ✅ 包含完整的5维分析
- ✅ 适合定期回顾和趋势分析

**运行流程**：
```bash
# 1. 数据收集（22个搜索）
bash run-optimized.sh

# 2. 自动化分析
bash auto-analyze.sh

# 3. 生成完整周报
# 4. 保存到 output/ESG-周报-YYYY-MM-DD.md
# 5. 发送飞书
```

---

### 2️⃣ 心跳机制（变相心跳）- 重要消息及时推送

**用途**：检测重要ESG动态，及时警报
**频率**：每12小时（建议00:00和12:00）
**特点**：
- ✅ 只搜索紧急关键词（CSRD、CBAM、双碳政策等）
- ✅ 只在发现重要消息时推送
- ✅ 快速搜索（仅2个搜索，5条结果）
- ✅ 避免信息过载

**运行流程**：
```bash
# 1. 快速检测（2个搜索，过去12小时）
bash check-urgent-news.sh

# 2. 如果发现重要消息
#    → 生成警报报告
#    → 立即发送飞书

# 3. 如果没有重要消息
#    → 静默退出（不推送）
```

---

## 🚨 重要消息定义

**欧盟政策**：
- CSRD directive（ESRS标准更新）
- CBAM implementation（碳边境税实施）
- EU green deal（欧盟绿色新政）

**中国政策**：
- 双碳政策发布（碳达峰/碳中和）
- 绿色采购新规（政府采购政策变化）
- ESG披露指引（证监会/交易所要求）

**关键词特征**：
- 包含"breaking"、"urgent"、"紧急"、"突发"
- 来自官方机构（gov.cn, europa.eu）
- 影响合规要求

---

## ⏰ Cron任务设置建议

### 周报任务（每周五15:00）
```bash
cron add \
  --name "ESG周报（完整版）" \
  --schedule "0 15 * * 5" \
  --sessionTarget isolated \
  --payload '{
    "kind": "agentTurn",
    "message": "生成ESG周报：\n1. bash run-optimized.sh（数据收集）\n2. bash auto-analyze.sh（自动化分析）\n3. 生成完整周报并发送飞书",
    "timeoutSeconds": 600
  }'
```

### 重要消息检测（每12小时）
```bash
cron add \
  --name "ESG重要消息检测（变相心跳）" \
  --schedule "0 */12 * * *" \
  --sessionTarget isolated \
  --payload '{
    "kind": "agentTurn",
    "message": "检测ESG重要消息：\nbash /root/.openclaw/workspace/skills/esg-green-procurement-monitor/check-urgent-news.sh\n\n如果检测到重要消息（退出代码100），立即生成警报并发送飞书。",
    "timeoutSeconds": 120
  }'
```

---

## 📊 对比总结

| 特性 | 周报（定时） | 重要消息检测（心跳） |
|------|------------|------------------|
| **频率** | 每周五15:00 | 每12小时 |
| **触发条件** | 时间到达 | 发现重要消息 |
| **搜索数量** | 22个（完整） | 2个（快速） |
| **报告内容** | 5维完整分析 | 仅重要消息摘要 |
| **推送频率** | 每周1次 | 按需（0-N次） |
| **适用场景** | 定期回顾 | 及时应对 |

---

## 💡 使用建议

### 适合你的方案
1. **周报**：每周五15:00 → 生成完整报告
2. **重要消息检测**：每天00:00和12:00 → 发现重要消息立即推送

### 优势
- ✅ 周报提供完整的趋势分析
- ✅ 重要消息检测确保不错过关键信息
- ✅ 两者互补，不冲突

### 注意事项
- ⚠️ 重要消息检测不要设置太频繁（避免API浪费）
- ⚠️ 周报时间避开重要消息检测时间（避免冲突）
- ⚠️ 关键词需要定期优化（避免误报/漏报）

---

## 🔧 调试与优化

### 测试重要消息检测
```bash
# 手动运行测试
bash check-urgent-news.sh

# 查看日志
cat /root/.openclaw/workspace/skills/esg-green-procurement-monitor/.esg_alert_log
```

### 调整检测频率
```bash
# 每6小时（更频繁）
--schedule "0 */6 * * *"

# 每24小时（更节省）
--schedule "0 0 * * *"
```

### 优化关键词
编辑 `check-urgent-news.sh` 中的 `URGENT_KEYWORDS` 变量

---

_版本：v2.1 双机制版_
_创建时间：2026-03-05_
