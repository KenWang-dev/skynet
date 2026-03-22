# 电子供应链情报系统 - 完整配置

## 📊 系统概览

**双轨系统**：日报 + 周报，覆盖不同需求

### 📅 **日报**（每天 7:30）
- **目的**：快速扫描 + 红灯预警
- **范围**：过去 24 小时
- **阅读时长**：< 2 分钟
- **技能目录**：`/root/.openclaw/workspace/skills/electronics-supply-chain-daily/`
- **Cron ID**：df51eeb3-0afb-499e-9dc8-2ec249da91d9

### 📆 **周报**（每周一 7:45）
- **目的**：趋势研判 + 周期性复盘 + 采购决策支持
- **范围**：过去 7 天
- **阅读时长**：5-10 分钟
- **技能目录**：`/root/.openclaw/workspace/skills/electronics-supply-chain-weekly/`
- **Cron ID**：0ede9ace-4940-4013-8514-4fc42d2a4eed

---

## 🎨 统一格式规范（v17）

### 分隔方式
- **使用全角空格**（　）分隔所有板块
- **核心品类内部**：每个小品类之间也用全角空格
- **❌ 禁止**：分隔线（`━━━`）或连续换行

### 加粗规则
- **标题加粗**：所有板块标题
- **品类加粗**：【存储芯片】、【MCU / 功率器件】 等
- **关键词加粗**：公司名、产品名、关键数据

### 符号系统
- **价格趋势**：↑↑ 大幅上涨 | ↑ 小幅上涨 | → 持平 | ↓ 小幅下跌 | ↓↓ 大幅下跌
- **紧急度**：🔴 高 | 🟡 中 | 🟢 低
- **状态**：✅ 已证实 | ❓ 传闻

---

## 📂 文件结构

```
/root/.openclaw/workspace/skills/
├── electronics-supply-chain-daily/         # 日报技能
│   ├── SKILL.md                            # 日报说明
│   ├── FORMAT.md                           # 日报格式（v17）
│   └── scripts/
│       └── daily-monitor.sh                # 日报监控脚本
│
├── electronics-supply-chain-weekly/        # 周报技能
│   ├── SKILL.md                            # 周报说明（完整 6 大部分）
│   └── scripts/
│       └── weekly-monitor.sh               # 周报监控脚本
│
└── electronics-supply-chain-monitor/
    └── references/
        └── methodology-deep-research.md    # 深度研究方法论
```

---

## 🕐 定时任务时间表

| 任务 | 频率 | 时间 | Cron ID | 状态 |
|------|------|------|---------|------|
| **电子供应链日报** | 每天 | 7:30 | df51eeb3... | ✅ 运行中 |
| **电子供应链周报** | 每周一 | 7:45 | 0ede9ace... | ✅ 运行中 |
| AI 三巨头监控 | 每天 | 8:00 | d53a7a1c... | ✅ 运行中 |

---

## 🔍 搜索策略

### 日报（3 大 Group）
- **Group A**：红灯事件扫描
- **Group B**：核心品类趋势（存储、MCU、被动元件）
- **Group C**：关键指标（LME 铜/金、汇率）

### 周报（7 大 Group）
- **Group A**：半导体核心趋势
- **Group B**：被动与连接器
- **Group C**：基础原材料
- **Group D**：原厂动态与财报
- **Group E**：宏观与物流
- **Group F**：黑天鹅兜底
- **Group G**：自然灾害

---

## ⚙️ 技术实现

### 搜索引擎
- **Tavily Deep 模式**：多源验证 + AI 摘要
- **时间锚定**：日报 24 小时 / 周报 7 天
- **信源分级**：Tier 1（优先）> Tier 2（可用）> Tier 3（验证）

### 发送方式
- **工具**：`message` 工具（channel=feishu）
- **接收人**：Ken（ou_a7195bd3e0508f0e0d09f19ff12a8811）
- **格式**：全角空格分隔 + 关键词加粗

---

## 🚀 快速操作

### 查看任务状态
```bash
cron list
```

### 手动测试日报
```bash
bash /root/.openclaw/workspace/skills/electronics-supply-chain-daily/scripts/daily-monitor.sh
```

### 手动测试周报
```bash
bash /root/.openclaw/workspace/skills/electronics-supply-chain-weekly/scripts/weekly-monitor.sh
```

### 查看搜索结果
```bash
# 日报
ls -lh /tmp/electronics-supply-daily/

# 周报
ls -lh /tmp/electronics-supply-weekly/
```

---

## 📝 配置历史

- **2026-03-03**：系统创建完成
  - 日报格式：v17（全角空格 + 加粗）
  - 周报格式：基于日报 v17 + 深度研究框架
  - 定时任务：日报 7:30 / 周报 7:45

---

**创建者**：Claw1号 🪭
**创建时间**：2026-03-03
**基于方法论**：电子供应链情报深度研究框架
