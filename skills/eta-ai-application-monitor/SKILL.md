# Eta - AI应用落地监控 - SKILL.md

**创建时间**：2026-03-06 09:48 GMT+8
**创建者**：Claw1号
**编码**：Eta（η，希腊字母第七个）
**版本**：v1.0

---

## 🎯 技能简介

**技能名称**：Eta - AI应用落地监控
**核心问题**：应用往哪落地？
**核心目标**：找出全球落地最好、ROI最高的AI应用案例
**监控频率**：周报（每周六 8:53）
**时间范围**：默认过去7天（可临时调整为过去1个月等）

version: 1.0.0
author: OpenClaw Agent
---

## 🔑 核心原则

### 1. 帕雷托法则（80/20法则）
- 只关注TOP 20%的关键应用
- 找出全球落地最好的AI应用
- 拒绝平庸案例（10%增长这种没有价值）

### 2. ROI量化标准（非常严格）
**营收增长型**：
- ✅ **入选标准**：5倍以上增长
- 例如：1000万 → 5000万/8000万

**成本降低型**：
- ✅ **入选标准**：50%以上降低
- 例如：1亿 → 5000万

**❌ 拒绝标准**：10%、20%这种小幅增长（没有价值）

### 3. 来源引用（必须标注）
- 所有数据必须标注引用源
- 确保信息可验证

### 4. 行业优先级
制造业（优先）→ 医疗 → 教育 → 金融 → 法律 → 数据分析 → 客户支持

---

## 📊 监控维度

### 1. 新产品发现（TOP 5）
**渠道**：
- Product Hunt（按点赞数排序）
- App Store（按排行榜、评分排序）
- GitHub Trending（按stars、forks排序）

**筛选**：按帕雷托法则，只选TOP 5

**输出**：本周TOP 5热门AI产品

### 2. 行业应用（7个重点行业）
**行业**：制造业（优先）、医疗、教育、金融、法律、数据分析、客户支持

**渠道**：
- Hugging Face（热门行业模型）
- Reddit（r/artificial、r/MachineLearning）
- 行业报告（Gartner、IDC、麦肯锡、CB Insights）

**输出**：每个行业的AI应用概况、应用场景、主要厂商

### 3. 经典案例分析（3-5个）
**选择原则**：
- 总共3-5个案例
- 每个行业/赛道1个最典型的
- 必须符合ROI标准（5倍增长/50%降本）

**案例深度**：
- 传统做法 vs AI做法
- ROI分析（量化）
- 降本增效（量化指标）
- 落地阻碍
- 成功/失败原因
- **引用源**（必须标注）

### 4. 趋势分析
- 产品趋势、行业趋势、技术趋势、商业趋势
- 核心洞察
- 下周预测

---

## 🎨 报告格式

使用"汇报风格"（REPORT_STYLE_STANDARD.md）：
- 报告标题：📊 **AI应用落地监控 - 周报**
- 大板块：**【板块名称】**
- 子板块：**子板块名称**（加粗）
- 新闻条目：**- 标题** + 　　**简要解析** + 　　📎 **来源**
- 空行规则：语义块之间空行
- 结尾：下周六见！🪭

---

## 🌍 数据渠道

**核心渠道**：
1. Product Hunt
2. App Store
3. GitHub Trending
4. Hugging Face
5. Reddit（r/artificial、r/MachineLearning）
6. 行业报告（Gartner、IDC、麦肯锡、CB Insights）

---

## 📁 文件结构

```
/root/.openclaw/workspace/skills/eta-ai-application-monitor/
├── SKILL.md (本文件)
├── scripts/
│   └── weekly-monitor.sh
└── FORMAT-v3-FINAL.md (指向通用排版规范)
```

---

## 📝 使用方法

### Cron 任务配置

```bash
# 每周六 8:53 运行
expr: "53 8 * * 6"
tz: "Asia/Shanghai"
```

### 脚本执行

```bash
bash /root/.openclaw/workspace/skills/eta-ai-application-monitor/scripts/weekly-monitor.sh
```

---

## 📋 实施状态

- [x] SKILL.md 创建完成
- [ ] weekly-monitor.sh 创建
- [ ] Cron 任务创建
- [ ] 测试运行

---

**版本**：v1.0
**创建者**：Claw1号
**创建时间**：2026-03-06 09:48 GMT+8
