# 存档要求

**重要：** 每次生成报告后必须先保存到本地，再发送飞书！

## 存档步骤

### 1. 保存到 archive 目录

**日报格式：**
```bash
date=$(date +%Y-%m-%d)
report_content="# 📊 监控报告标题\n\n报告内容..."
echo -e "$report_content" > "/root/.openclaw/workspace/archive/[代码]-[任务名称]/[代码]-${date}.md"
```

**周报格式：**
```bash
week=$(date +Y-W%V)
report_content="# 📊 周报标题\n\n报告内容..."
echo -e "$report_content" > "/root/.openclaw/workspace/archive/[代码]-[任务名称]/[代码]-周报-${week}.md"
```

### 2. 验证存档

```bash
# 检查文件是否存在
ls -lh "/root/.openclaw/workspace/archive/[代码]-[任务名称]/" | tail -5

# 检查文件内容
head -20 "/root/.openclaw/workspace/archive/[代码]-[任务名称]/[代码]-YYYY-MM-DD.md"
```

### 3. 发送飞书

```javascript
message({
  action: "send",
  channel: "feishu",
  target: "ou_a7195bd3e0508f0e0d09f19ff12a8811",
  message: report_content
});
```

---

## 存档路径对照表

| 任务代码 | 任务名称 | 存档路径 | 文件命名格式 |
|---------|---------|---------|-------------|
| A1 | Karpathy AI博客精选 | `A1-Karpathy-AI博客精选/` | `A1-YYYY-MM-DD.md` |
| B1 | AI三巨头监控 | `B1-AI三巨头监控/` | `B1-YYYY-MM-DD.md` |
| C1 | 电子供应链每日情报简报 | `C1-电子供应链每日情报简报/` | `C1-YYYY-MM-DD.md` |
| C2 | 电子供应链周度战略情报 | `C2-电子供应链周度战略情报/` | `C2-周报-YYYY-Www.md` |
| D1 | 供应链风险日报 | `D1-供应链风险日报/` | `D1-YYYY-MM-DD.md` |
| D2 | 供应链风险监控周报 | `D2-供应链风险监控周报/` | `D2-周报-YYYY-Www.md` |
| E1 | 政策与法规监控日报 | `E1-政策与法规监控日报/` | `E1-YYYY-MM-DD.md` |
| E2 | 政策与法规监控周报 | `E2-政策与法规监控周报/` | `E2-周报-YYYY-Www.md` |
| E3 | 政策与法规监控月报 | `E3-政策与法规监控月报/` | `E3-月报-YYYY-MM.md` |
| F1 | 宏观财务日报 | `F1-宏观财务日报/` | `F1-YYYY-MM-DD.md` |
| F2 | 宏观财务周报 | `F2-宏观财务周报/` | `F2-周报-YYYY-Www.md` |
| G2 | 行业市场监控周报 | `G2-行业市场监控周报/` | `G2-周报-YYYY-Www.md` |
| H2 | AI采购最佳实践周报 | `H2-AI采购最佳实践周报/` | `H2-周报-YYYY-Www.md` |
| I2 | 采购心声监控周报 | `I2-采购心声监控周报/` | `I2-周报-YYYY-Www.md` |
| J2 | ESG绿色采购监控周报 | `J2-ESG绿色采购监控周报/` | `J2-周报-YYYY-Www.md` |
| K2 | 供应商生态系统监控周报 | `K2-供应商生态系统监控周报/` | `K2-周报-YYYY-Www.md` |

---

**记住：先保存本地，再发送飞书！** 🪭
