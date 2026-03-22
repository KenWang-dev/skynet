---
name: ai-giants-monitor
description: AI 三巨头（OpenAI、Anthropic、Google DeepMind）全维度监控。使用 Tavily 搜索最新动态，按照 6 大维度（技术底座、产品矩阵、商业博弈、组织脉络、官方宣发、外部生态）整理情报，生成结构化简报并通过飞书发送。当需要监控 AI 行业动态、分析巨头动向、或生成每日情报简报时使用此技能。
version: 1.0.0
author: OpenClaw Agent
---

# AI 三巨头监控

## 概述

监控 AI 行业三大顶级巨头——**OpenAI**、**Anthropic**、**Google DeepMind**——的最新动态，从 6 大维度全视角追踪技术迭代、产品发布、商业博弈、组织变动、官方宣发和外部生态反馈。

## 监控流程

### 步骤 1：数据采集

使用 **Tavily 搜索**（过去 24 小时新闻模式）收集三大巨头的最新动态：

```bash
# OpenAI
cd /root/.openclaw/workspace/skills/tavily-search
node scripts/search.mjs "OpenAI GPT ChatGPT Sam Altman" --topic news --days 1 -n 10

# Anthropic
node scripts/search.mjs "Anthropic Claude Dario Amodei" --topic news --days 1 -n 10

# Google DeepMind
node scripts/search.mjs "Google DeepMind Gemini" --topic news --days 1 -n 10
```

**或使用监控脚本**（自动化执行三次搜索）：
```bash
bash /root/.openclaw/workspace/skills/ai-giants-monitor/scripts/monitor.sh
```

### 步骤 2：情报整理

按照 [监控框架](references/monitoring-framework.md) 的 6 大维度分类整理信息：

#### 维度 1：技术底座 (Technology)
- 模型迭代（GPT、Claude、Gemini 版本更新）
- 研究输出（论文发布、技术突破）
- 技术活动（黑客松、开发者大会）

#### 维度 2：产品矩阵 (Product)
- 新品发布（全新产品线）
- 形态拓展（插件、工具、API）
- 版本更新（功能迭代）

#### 维度 3：商业博弈 (Business)
- 资本输血（融资、投资）
- 结盟合作（商业合作、战略伙伴）
- 摩擦纠纷（诉讼、监管、争议）

#### 维度 4：组织脉络 (Organization)
- 高管动态（行程、发言、任命）
- 人员流失（核心员工离职）
- 内部黑幕（离职爆料、管理问题）

#### 维度 5：官方宣发 (Official PR)
- 官网公告（Newsroom/Blog）
- 社媒发声（X/Twitter 推文）
- 视频宣发（YouTube 更新）

#### 维度 6：外部生态 (External Ecosystem)
- **顶层**：行业领袖/专家论断（马斯克、杨立昆等）
- **中层**：投资界/产业界研判（VC 分析、商业评价）
- **底层**：社区/用户口碑（Reddit、开发者论坛、C 端反馈）

### 步骤 3：生成报告

#### 报告结构

**顶部：Top 5 核心情报**
- 提炼最具影响力的 5 条动态
- 每条包含：**事件 + 关键细节**（不重复标注时间）
- 按重要性降序排列

**中部：维度结构化详述**
- 按 6 大维度分组
- 每个维度：**事实 + 交叉验证 + 趋势点**
- 简洁明了，便于扫读

**底部：数据溯源**
- 附带原始链接（官网、新闻源）
- 供深挖时点对点跳转

#### 输出格式要求

- **语言**：简体中文
- **术语**：核心缩写保留英文（如 RLHF、MoE），首现加注中文
- **排版**：
  - 关键信息**加粗**
  - 段落间空行分隔
  - 多级缩进显示层级
  - 使用符号标注趋势（↑提升、↓下降、→持平）
- **长度控制**：宁缺毋滥，无重大动态时明确说明

### 步骤 4：发送报告

通过 **Feishu** 发送给 Ken（ou_a7195bd3e0508f0e0d09f19ff12a8811）：

```javascript
message({
  action: "send",
  channel: "feishu",
  target: "ou_a7195bd3e0508f0e0d09f19ff12a8811",
  message: "报告内容..."
});
```

## 监控频率

- **实时触发**：官网、X 推文（通过 Webhook）
- **周期扫描**：Reddit、YouTube、GitHub（每 3-6 小时）
- **每日简报**：全部 6 维度汇总（每天上午 8:00）

## 资源

### scripts/monitor.sh
自动化监控脚本，执行三次 Tavily 搜索并保存结果到 `/tmp/`。

### references/monitoring-framework.md
完整监控框架文档，包含：
- 6 大监控维度详细说明
- 15 个监控渠道覆盖
- 情报处理逻辑（价值过滤、事实校验、趋势对比）
- 情报交付标准（金字塔结构、高信噪比、扫描式阅读）

## 示例：完整监控任务执行

**场景**：每天上午 8:00 自动执行监控

1. **执行搜索**：
   ```bash
   bash /root/.openclaw/workspace/skills/ai-giants-monitor/scripts/monitor.sh
   ```

2. **分析结果**：
   - 阅读 `/tmp/openai-news.txt`、`/tmp/anthropic-news.txt`、`/tmp/google-news.txt`
   - 按 6 大维度分类整理

3. **生成报告**：
   - 提炼 Top 5 核心情报
   - 按维度分组详述
   - 添加趋势分析

4. **保存存档**（必须！）：
   ```bash
   # 保存到 archive 目录
   date=$(date +%Y-%m-%d)
   report_content="# 📊 AI三巨头监控日报\n\n..."
   echo -e "$report_content" > "/root/.openclaw/workspace/archive/B1-AI三巨头监控/B1-$date.md"
   ```

5. **同步到飞书知识库**（必须！）：
   - 使用 `feishu_wiki` 工具创建新文档
   - Space ID: `7615440793062394844`
   - Parent Node Token: `HQSkwMzj7iI42pkpFikc1ai8n4d`（Beta 系列 - AI巨头动态）
   - 文档标题格式：`B1-AI三巨头监控 YYYY-MM-DD`
   ```javascript
   feishu_wiki({
     action: "create",
     space_id: "7615440793062394844",
     parent_node_token: "HQSkwMzj7iI42pkpFikc1ai8n4d",
     obj_type: "docx",
     title: "B1-AI三巨头监控 2026-03-13",
     // 创建后使用返回的 obj_token 写入内容
   });
   
   // 然后使用 feishu_doc 写入内容
   feishu_doc({
     action: "write",
     doc_token: "返回的 obj_token",
     content: "报告内容（Markdown格式）"
   });
   ```

6. **发送飞书消息**：
   - 通过 `message` 工具发送报告给 Ken
   - **只发送监控日报内容，不发送中间过程消息**

## 无重大动态处理

如果当天无重大新闻，明确说明：
```
📊 **今日暂无重大动态**

三大巨头在过去 24 小时内无重大新闻发布。
持续监控中...
```

**不要**为了凑数强行推送次要信息。
