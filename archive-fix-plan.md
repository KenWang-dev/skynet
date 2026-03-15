# 监控任务存档修复计划

**创建时间**：2026-03-07 14:35
**目标**：为所有 15 个监控任务添加本地存档机制
**状态**：🚧 执行中

---

## ✅ 已修复（1/15）

1. **AI 三巨头监控** (`ai-giants-monitor`)
   - 文件：SKILL.md
   - 修改：添加 Step 4 保存存档步骤
   - 路径：`/root/.openclaw/workspace/archive/B1-AI三巨头监控/B1-YYYY-MM-DD.md`

---

## ⏳ 待修复（14/15）

### 2. 电子供应链每日情报简报
- 技能：`electronics-supply-chain-daily`
- 编码：C1
- 路径：`/root/.openclaw/workspace/archive/C1-电子供应链每日情报简报/`

### 3. 电子供应链周度战略情报
- 技能：`electronics-supply-chain-weekly`
- 编码：C2
- 路径：`/root/.openclaw/workspace/archive/C2-电子供应链周度战略情报/`

### 4. 供应链风险监控
- 技能：`supply-chain-risk-monitor`
- 编码：D1（日报）、D2（周报）
- 路径：
  - `/root/.openclaw/workspace/archive/D1-供应链风险日报/`
  - `/root/.openclaw/workspace/archive/D2-供应链风险监控周报/`

### 5. 政策与法规监控
- 技能：`policy-regulation-monitor`
- 编码：E1（日报）、E2（周报）、E3（月报）
- 路径：
  - `/root/.openclaw/workspace/archive/E1-政策与法规监控日报/`
  - `/root/.openclaw/workspace/archive/E2-政策与法规监控周报/`
  - `/root/.openclaw/workspace/archive/E3-政策与法规监控月报/`

### 6. 宏观财务监控
- 技能：`macro-financial-monitor`
- 编码：F1（日报）、F2（周报）
- 路径：
  - `/root/.openclaw/workspace/archive/F1-宏观财务日报/`
  - `/root/.openclaw/workspace/archive/F2-宏观财务周报/`

### 7. 行业市场监控
- 技能：`industry-market-monitor`
- 编码：G2
- 路径：`/root/.openclaw/workspace/archive/G2-行业市场监控周报/`

### 8. AI 资本风向监控
- 技能：`gamma1-vc-monitor`
- 编码：待定
- 路径：待定

### 9. ESG 绿色采购监控
- 技能：`esg-green-procurement-monitor`
- 编码：J2
- 状态：✅ 已有存档机制（output/ 目录）
- 路径：`/root/.openclaw/workspace/skills/esg-green-procurement-monitor/output/`

### 10. 供应商生态系统监控
- 技能：`supplier-ecosystem-monitor`
- 编码：K2
- 路径：`/root/.openclaw/workspace/archive/K2-供应商生态系统监控周报/`

### 11. Karpathy AI 博客精选
- 技能：`karpathy-digest`
- 编码：A1
- 路径：`/root/.openclaw/workspace/archive/A1-Karpathy-AI博客精选/`

### 12-15. 其他监控任务
- AI 政策推手监控
- AI 人才监控
- AI 社会影响监控
- 采购心声监控

---

## 🔧 修复模板

### 在每个监控任务的 SKILL.md 中添加：

```markdown
## 存档要求

**重要：** 每次生成报告后必须先保存到本地，再发送飞书。

### 存档步骤

1. **保存到 archive 目录**：
   ```bash
   # 日报
   date=$(date +%Y-%m-%d)
   echo -e "$report_content" > "/root/.openclaw/workspace/archive/[编码]-[任务名称]/[编码]-$date.md"

   # 周报
   week=$(date +%Y-W%V)
   echo -e "$report_content" > "/root/.openclaw/workspace/archive/[编码]-[任务名称]/[编码]-周报-$week.md"
   ```

2. **发送飞书**：
   ```javascript
   message({
     action: "send",
     channel: "feishu",
     target: "ou_a7195bd3e0508f0e0d09f19ff12a8811",
     message: report_content
   });
   ```

3. **验证存档**：
   ```bash
   ls -lh "/root/.openclaw/workspace/archive/[编码]-[任务名称]/" | tail -5
   ```
```

---

## 📋 执行检查清单

- [x] 创建存档辅助函数（archive-functions.sh）
- [x] 修复 AI 三巨头监控
- [ ] 修复电子供应链监控（daily + weekly）
- [ ] 修复供应链风险监控
- [ ] 修复政策法规监控
- [ ] 修复宏观财务监控
- [ ] 修复行业市场监控
- [ ] 修复其他监控任务
- [ ] 更新总索引（archive-index.md）
- [ ] 测试存档机制

---

**维护者**：Claw1号 🪭
**预计完成时间**：2026-03-07 15:00
