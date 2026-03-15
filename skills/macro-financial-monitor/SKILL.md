---
name: macro-financial-monitor
version: 1.0.0
author: OpenClaw Agent
description: 宏观财务环境监控（价格/汇率/利率/信贷/政策）。监控 LME 铜价、汇率波动、LPR/MLF 利率、银行贷款政策等 5 大类指标，为采购决策提供宏观环境参考。日报快速扫描价格变化，周报深度分析政策影响。当用户请求"监控铜价"、"汇率走势"、"利率变化"、或"宏观环境分析"时使用此技能。
---

# 宏观财务监控技能

---

## 监控目标

监控宏观经济指标和财务环境变化，为采购决策提供宏观层面的参考依据。

version: 1.0.0
author: OpenClaw Agent
---

## 监控维度

### 1. 原材料价格监控（日报）
- **铜价**：LME铜期货价格、长江现货铜价
- **铝价**：LME铝期货价格、长江现货铝价
- **稀土价格**：氧化镨钕、氧化镝等关键稀土价格
- **钢铁价格**：螺纹钢、热轧卷板价格
- **原油价格**：WTI、布伦特原油期货价格
- **黄金价格**：伦敦现货黄金价格

### 2. 汇率监控（日报）
- **美元/人民币**：在岸人民币（CNY）、离岸人民币（CNH）
- **欧元/人民币**：EUR/CNY汇率
- **日元/人民币**：JPY/CNY汇率
- **汇率指数**：美元指数（DXY）

### 3. 利率监控（日报）
- **LPR**：1年期LPR、5年期以上LPR
- **美联储利率**：联邦基金利率目标区间
- **中国央行利率**：MLF利率、逆回购利率
- **国债收益率**：10年期国债收益率

### 4. 银行贷款政策（周报）
- **贷款利率**：企业贷款利率、个人住房贷款利率
- **贷款条件**：首付比例、贷款期限、担保要求
- **信贷政策**：定向降准、再贷款政策
- **监管政策**：MPA考核、宏观审慎政策

### 5. 利息变化（周报）
- **企业融资成本**：企业贷款加权平均利率
- **票据利率**：票据直贴利率、转贴利率
- **Shibor**：上海银行间同业拆放利率
- **DR007**：银行间存款类金融机构以利率债为质押的7天回购利率

---

## 数据来源

### 价格数据
- **LME（伦敦金属交易所）**：www.lme.com
- **上海期货交易所**：www.shfe.com.cn
- **上海有色网**：www.smm.cn
- **中国黄金协会**：www.cngold.org.cn

### 汇率数据
- **中国外汇交易中心**：www.chinamoney.com.cn
- **新浪财经**：finance.sina.com.cn

### 利率数据
- **中国人民银行**：www.pbc.gov.cn
- **中国货币网**：www.chinamoney.com.cn

### 政策数据
- **央行官网**：www.pbc.gov.cn
- **银保监会**：www.cbirc.gov.cn

---

## 使用Tavily搜索

### 日报搜索关键词（过去24小时）

**原材料价格**：
- "LME铜价 最新" 24小时
- "铝价 今日" 24小时
- "稀土价格 氧化镨钕" 24小时
- "螺纹钢价格 今日" 24小时
- "WTI原油 价格" 24小时
- "黄金价格 今日" 24小时

**汇率利率**：
- "美元人民币 汇率 最新" 24小时
- "人民币 中间价 今日" 24小时
- "LPR利率 最新" 24小时

### 周报搜索关键词（过去7天）

**贷款政策**：
- "银行贷款利率 最新" 7天
- "企业贷款利率 政策" 7天
- "首套房贷款利率" 7天
- "央行降准 政策" 7天

**利息变化**：
- "企业融资成本" 7天
- "Shibor 利率" 7天
- "DR007 利率" 7天

---

## 报告格式

### 日报格式

```
📊 宏观财务日报 - 2026-03-05

## 🏆 核心变化（TOP 3）

1. **[维度]**：一句话洞察

2. **[维度]**：一句话洞察

3. **[维度]**：一句话洞察

---

## 📈 原材料价格

### 铜
- **LME铜**：$XXXX/吨，涨跌幅：+X.X%
- **长江现货**：￥XXXX/吨，涨跌幅：+X.X%

### 铝
- **LME铝**：$XXXX/吨，涨跌幅：+X.X%
- **长江现货**：￥XXXX/吨，涨跌幅：+X.X%

### 稀土
- **氧化镨钕**：￥XX万元/吨，涨跌幅：+X.X%

### 钢铁
- **螺纹钢**：￥XXXX/吨，涨跌幅：+X.X%

### 原油
- **WTI**：$XX/桶，涨跌幅：+X.X%

### 黄金
- **现货黄金**：$XXXX/盎司，涨跌幅：+X.X%

---

## 💱 汇率

### 美元/人民币
- **在岸CNY**：X.XXXX
- **离岸CNH**：X.XXXX
- **中间价**：X.XXXX

---

## 📉 利率

### LPR
- **1年期**：X.X%
- **5年期**：X.X%

---

生成时间：YYYY-MM-DD HH:MM
数据来源：Tavily搜索
```

### 周报格式

```
📊 宏观财务周报 - 2026-03-05

## 🏆 核心发现（TOP 5）

1. **[维度]**：一句话洞察

2. **[维度]**：一句话洞察

...

---

## 🏦 银行贷款政策

### 贷款利率
- **企业贷款利率**：X.X%
- **个人住房贷款利率**：X.X%

### 贷款条件
- **首付比例**：XX%
- **贷款期限**：最长XX年

### 信贷政策
- **政策变化**：[描述]

---

## 💰 利息变化

### 企业融资成本
- **企业贷款加权平均利率**：X.X%

### 票据利率
- **票据直贴利率**：X.X%
- **票据转贴利率**：X.X%

### 市场利率
- **Shibor隔夜**：X.X%
- **DR007**：X.X%

---

## 📊 趋势分析

- **利率趋势**：[描述]
- **汇率趋势**：[描述]
- **政策走向**：[描述]

---

生成时间：YYYY-MM-DD HH:MM
数据来源：Tavily搜索
```

---

## 执行脚本

### 日报执行

```bash
#!/bin/bash

# 宏观财务监控日报
# 使用Tavily搜索过去24小时的价格和利率数据

OUTPUT_DIR="/tmp/macro-financial-monitor"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p "$OUTPUT_DIR"

# 搜索原材料价格
echo "## 原材料价格" > "$OUTPUT_DIR/prices_${TIMESTAMP}.txt"
tavily search --query "LME铜价 最新" --topic news --days 1 --max-results 5 >> "$OUTPUT_DIR/prices_${TIMESTAMP}.txt"
tavily search --query "铝价 今日" --topic news --days 1 --max-results 5 >> "$OUTPUT_DIR/prices_${TIMESTAMP}.txt"
tavily search --query "稀土价格 氧化镨钕" --topic news --days 1 --max-results 5 >> "$OUTPUT_DIR/prices_${TIMESTAMP}.txt"
tavily search --query "螺纹钢价格 今日" --topic news --days 1 --max-results 5 >> "$OUTPUT_DIR/prices_${TIMESTAMP}.txt"
tavily search --query "WTI原油 价格" --topic news --days 1 --max-results 5 >> "$OUTPUT_DIR/prices_${TIMESTAMP}.txt"
tavily search --query "黄金价格 今日" --topic news --days 1 --max-results 5 >> "$OUTPUT_DIR/prices_${TIMESTAMP}.txt"

# 搜索汇率
echo "## 汇率" > "$OUTPUT_DIR/fx_${TIMESTAMP}.txt"
tavily search --query "美元人民币 汇率 最新" --topic news --days 1 --max-results 5 >> "$OUTPUT_DIR/fx_${TIMESTAMP}.txt"

# 搜索利率
echo "## 利率" > "$OUTPUT_DIR/rates_${TIMESTAMP}.txt"
tavily search --query "LPR利率 最新" --topic news --days 1 --max-results 5 >> "$OUTPUT_DIR/rates_${TIMESTAMP}.txt"

echo "✅ 宏观财务日报数据收集完成"
echo "📁 数据位置：$OUTPUT_DIR"
echo "⏰ 时间戳：$TIMESTAMP"

# 保存存档
ARCHIVE_DIR="/root/.openclaw/workspace/archive/F1-宏观财务日报"
mkdir -p "$ARCHIVE_DIR"
DATE=$(date +%Y-%m-%d)
cat "$OUTPUT_DIR/prices_${TIMESTAMP}.txt" "$OUTPUT_DIR/fx_${TIMESTAMP}.txt" "$OUTPUT_DIR/rates_${TIMESTAMP}.txt" > "$ARCHIVE_DIR/F1-$DATE.md"
echo "✅ 已保存存档：$ARCHIVE_DIR/F1-$DATE.md"
```

### 周报执行

```bash
#!/bin/bash

# 宏观财务监控周报
# 使用Tavily搜索过去7天的贷款政策和利息变化

OUTPUT_DIR="/tmp/macro-financial-monitor"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p "$OUTPUT_DIR"

# 搜索贷款政策
echo "## 银行贷款政策" > "$OUTPUT_DIR/policy_${TIMESTAMP}.txt"
tavily search --query "银行贷款利率 最新" --topic news --days 7 --max-results 10 >> "$OUTPUT_DIR/policy_${TIMESTAMP}.txt"
tavily search --query "央行降准 政策" --topic news --days 7 --max-results 10 >> "$OUTPUT_DIR/policy_${TIMESTAMP}.txt"

# 搜索利息变化
echo "## 利息变化" > "$OUTPUT_DIR/interest_${TIMESTAMP}.txt"
tavily search --query "企业融资成本" --topic news --days 7 --max-results 10 >> "$OUTPUT_DIR/interest_${TIMESTAMP}.txt"
tavily search --query "Shibor 利率" --topic news --days 7 --max-results 10 >> "$OUTPUT_DIR/interest_${TIMESTAMP}.txt"
tavily search --query "DR007 利率" --topic news --days 7 --max-results 10 >> "$OUTPUT_DIR/interest_${TIMESTAMP}.txt"

echo "✅ 宏观财务周报数据收集完成"
echo "📁 数据位置：$OUTPUT_DIR"
echo "⏰ 时间戳：$TIMESTAMP"

# 保存存档
ARCHIVE_DIR="/root/.openclaw/workspace/archive/F2-宏观财务周报"
mkdir -p "$ARCHIVE_DIR"
WEEK=$(date +%Y-W%V)
cat "$OUTPUT_DIR/policy_${TIMESTAMP}.txt" "$OUTPUT_DIR/interest_${TIMESTAMP}.txt" > "$ARCHIVE_DIR/F2-周报-${WEEK}.md"
echo "✅ 已保存存档：$ARCHIVE_DIR/F2-周报-${WEEK}.md"
```

---

## 定时任务配置

### 日报（v2.0 - 2026-03-08 更新）
- **时间**：每天 12:00
- **内容**：原材料价格、汇率、利率
- **格式模板**：`FORMAT-v2.md`
- **关键修复**：
  - ✅ **所有标题必须加粗**（**【📈 原材料价格（6个品类）】**、**【💱 汇率（2个指标）】** 等）
  - ✅ **板块之间使用全角空格分隔**（　）
  - ✅ **结尾使用动态时间**："**明天见！**"（不写具体时间）

### 周报
- **时间**：每周五9:00
- **内容**：银行贷款政策、利息变化、趋势分析

---

## 报告格式（v2.0）

**格式模板文件：** `FORMAT-v2.md`

**核心规范：**
1. **标题加粗**：所有板块标题（【🎯 TOP 3 核心变化】、【📈 原材料价格】等）必须加粗
2. **全角空格分隔**：板块之间使用全角空格（　）分隔，避免飞书压缩
3. **动态时间**：结尾统一使用"**明天见！**"，不写具体时间

**报告结构：**
```
标题 → TOP 3 核心变化 → 原材料价格 → 汇率 → 利率 → 风险提示 → 数据来源 → 签名
```

---

**创建时间**：2026-03-05
**更新时间**：2026-03-08
**版本**：v2.0
**维护者**：Claw1号 🪭
