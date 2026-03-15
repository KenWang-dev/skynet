# 📋 监控任务存档规范

**适用于所有监控任务**
**生效时间**：2026-03-07
**维护者**：Claw1号 🪭

---

## ✅ 必须执行的存档步骤

**每次生成报告后，必须先保存到本地，再发送飞书！**

### 通用模板

```javascript
// 1. 生成报告内容
const reportContent = `# 📊 监控报告标题

报告内容...
`;

// 2. 保存到本地（必须！）
const date = new Date().toISOString().split('T')[0]; // YYYY-MM-DD
const code = "XX"; // 任务代码：A1, B1, C1, D1 等
const taskName = "任务名称";
const filePath = `/root/.openclaw/workspace/archive/${code}-${taskName}/${code}-${date}.md`;

// 写入文件
fs.writeFileSync(filePath, reportContent);

// 3. 发送飞书
message({
  action: "send",
  channel: "feishu",
  target: "ou_a7195bd3e0508f0e0d09f19ff12a8811",
  message: reportContent
});
```

---

## 📁 存档路径规范

### 日报
```
/root/.openclaw/workspace/archive/[代码]-[任务名称]/[代码]-YYYY-MM-DD.md
```

**示例：**
- AI 三巨头监控日报：
  ```
  /root/.openclaw/workspace/archive/B1-AI三巨头监控/B1-2026-03-07.md
  ```

- 电子供应链每日情报：
  ```
  /root/.openclaw/workspace/archive/C1-电子供应链每日情报简报/C1-2026-03-07.md
  ```

### 周报
```
/root/.openclaw/workspace/archive/[代码]-[任务名称]/[代码]-周报-YYYY-Www.md
```

**示例：**
- 供应链风险监控周报：
  ```
  /root/.openclaw/workspace/archive/D2-供应链风险监控周报/D2-周报-2026-W10.md
  ```

---

## 🔤 任务代码对照表

| 代码 | 任务名称 | 类型 |
|------|----------|------|
| A1 | Karpathy AI博客精选 | 日报 |
| B1 | AI三巨头监控 | 日报 |
| C1 | 电子供应链每日情报简报 | 日报 |
| C2 | 电子供应链周度战略情报 | 周报 |
| D1 | 供应链风险日报 | 日报 |
| D2 | 供应链风险监控周报 | 周报 |
| E1 | 政策与法规监控日报 | 日报 |
| E2 | 政策与法规监控周报 | 周报 |
| E3 | 政策与法规监控月报 | 月报 |
| F1 | 宏观财务日报 | 日报 |
| F2 | 宏观财务周报 | 周报 |
| G2 | 行业市场监控周报 | 周报 |
| H2 | AI采购最佳实践周报 | 周报 |
| I2 | 采购心声监控周报 | 周报 |
| J2 | ESG绿色采购监控周报 | 周报 |
| K2 | 供应商生态系统监控周报 | 周报 |

---

## ✅ 验证检查清单

报告发送后，必须验证存档是否成功：

```bash
# 检查文件是否存在
ls -lh /root/.openclaw/workspace/archive/[代码]-[任务名称]/ | tail -5

# 检查文件内容
head -20 /root/.openclaw/workspace/archive/[代码]-[任务名称]/[代码]-YYYY-MM-DD.md
```

**如果文件不存在，存档失败！需要重新保存！**

---

## 🚨 常见错误

### ❌ 错误1：只发送飞书，不保存本地
```javascript
// 错误做法
message({ action: "send", channel: "feishu", target: "...", message: report });
// 缺少本地保存！
```

### ❌ 错误2：路径错误
```javascript
// 错误路径
fs.writeFileSync("/root/.openclaw/workspace/report.md", content);
// 应该放在 archive/[代码]-[任务名称]/ 目录下
```

### ❌ 错误3：命名格式错误
```javascript
// 错误命名
const filePath = `./report-${date}.md`;
// 应该是：[代码]-YYYY-MM-DD.md
```

---

**记住：飞书发送 ≠ 本地存档！两者都要做！** 🪭
