---
name: electronics-supply-chain-daily
description: 电子供应链每日情报简报。使用 Tavily Deep 模式搜索过去 24 小时动态，快速扫描红灯事件和核心品类趋势，每天早上 8:00 推送。确保新鲜度，为供应链总监提供当日决策参考。
version: 1.0.0
author: OpenClaw Agent
---

# 电子供应链每日情报简报

## 📋 概述

**频率**：每天早上 8:00
**时间范围**：过去 24 小时
**阅读时长**：< 2 分钟
**目标**：快速扫描 + 红灯预警，不错过任何重要动态

**核心方法论**：基于 `/root/.openclaw/workspace/skills/electronics-supply-chain-monitor/references/methodology-deep-research.md`

---

## 🎯 监控范围（剪枝版）

### ✅ **保留模块**

#### 1. 红灯事件验证（最高优先级）
- 停产/火灾/停电
- 涨价函/调价通知
- 断供/配给限制
- 重大并购/重组

#### 2. 核心品类快速扫描（Pareto 80/20）
- **半导体**：MCU、功率器件、存储 (DRAM/NAND)
- **被动元件**：MLCC、连接器头部厂商 (TE/Molex/Murata)

#### 3. 今日关键指标（一行带过）
- LME 铜/金：收盘价 + 日环比
- USD/CNY：汇率走势
- 重要指数：PMI、SCFI（如有更新）

### ❌ **简化/移除模块**
- ~~详细的宏观环境分析~~（留给周报）
- ~~战略决策建议~~（周一早会才需要）
- ~~完整的原材料监测~~（只保留最核心的）

---

## 🔍 搜索策略

### 时间锚定
```bash
# 获取当前时间和 24 小时前
CURRENT_DATE=$(date +"%Y-%m-%d")
DATE_START=$(date -d "24 hours ago" +"%Y-%m-%d")
```

### 关键词矩阵（精简版）

#### **Group A：红灯事件扫描**
```bash
# 英文
"semiconductor" "fire" "shutdown" "disruption" after:${DATE_START}
"price increase" "notification" "electronic components" after:${DATE_START}
"allocation" "supply shortage" "lead time" after:${DATE_START}

# 中文
"半导体" "停产" "火灾" "停电" after:${DATE_START}
"涨价函" "调价通知" "电子元器件" after:${DATE_START}
"配给" "断供" "交期延长" after:${DATE_START}
```

#### **Group B：核心品类趋势**
```bash
# 半导体
"MCU" "inventory" "price" "trend" after:${DATE_START}
"DRAM" "NAND" "contract price" after:${DATE_START}
"MOSFET" "lead time" "shortage" after:${DATE_START}

# 被动元件
"MLCC" "price" "capacity" after:${DATE_START}
"connector" "TE" "Molex" "lead time" after:${DATE_START}
```

#### **Group C：关键指标**
```bash
# LME 金属
"LME Copper" "price" "daily" after:${DATE_START}
"LME Gold" "price" "daily" after:${DATE_START}

# 汇率
"USD CNY" "exchange rate" "forecast" after:${DATE_START}
```

---

## 📊 日报结构

### **顶部：红灯事件预警**（如果有）

如果有红灯事件，用表格展示：

| 事件 (Event) | 真相 (Status) | 影响 (Impact) | 紧急度 |
|-------------|--------------|--------------|--------|
| [简述] | [已证实/传闻] | [交期+X周/价格+Y%] | [🔴高/🟡中/🟢低] |

**如果无红灯事件**：
```
✅ 今日无红灯事件

过去 24 小时内未发现停产、涨价、断供等突发事件。
持续监控中...
```

### **中部：核心品类动态**

#### 半导体（精简版）
- **存储 (DRAM/NAND)**：[↑/↓/→] 简要描述
- **MCU/功率器件**：[↑/↓/→] 简要描述

#### 被动元件（精简版）
- **MLCC/连接器**：[↑/↓/→] 简要描述

### **底部：今日关键指标**

```
💰 LME 铜：$XXX (+/-X%) | 金：$XXX (+/-X%)
💱 USD/CNY：X.XXXX (+/-X%)
📊 PMI/SCFI：如有更新则标注
```

---

## 🛠️ 技术实现

### 使用 Tavily Deep 模式

```bash
# 进入 Tavily 技能目录
cd /root/.openclaw/workspace/skills/tavily-search

# Deep 模式搜索（多轮验证 + 深度分析）
node scripts/search.mjs "semiconductor fire disruption" \
  --topic news \
  --days 1 \
  --deep \
  -n 10
```

**Deep 模式优势**：
- ✅ 自动多源验证（避免假新闻）
- ✅ 访问多个来源交叉对比
- ✅ 生成更深入的分析结论
- ✅ 特别适合"红灯事件验证"

### 监控脚本

`/root/.openclaw/workspace/skills/electronics-supply-chain-daily/scripts/daily-monitor.sh`

```bash
#!/bin/bash
# 电子供应链每日情报监控脚本

set -e

OUTPUT_DIR="/tmp/electronics-supply-daily"
mkdir -p "$OUTPUT_DIR"

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
DATE_START=$(date -d "24 hours ago" +"%Y-%m-%d")

echo "🔍 电子供应链每日情报监控"
echo "⏰ 时间：$TIMESTAMP"
echo "📅 范围：过去 24 小时（$DATE_START 至今）"
echo ""

# TODO: 实现 Tavily Deep 搜索
# Group A: 红灯事件扫描
# Group B: 核心品类趋势
# Group C: 关键指标

echo "✅ 搜索完成"
echo "📁 结果保存到：$OUTPUT_DIR"
```

---

## ⚠️ 核心约束

### 1. 严格时间锚定
- **只关注过去 24 小时**
- 超出时间窗口的信息不作为"今日动态"
- 昨天的新闻不重复推送（除非有重大进展）

### 2. 信源白名单
- **Tier 1（优先）**：TrendForce、DigiTimes、财报
- **Tier 2（可用）**：原厂官网、头部代理商
- **Tier 3（验证）**：集微网等，标注为"传闻"

### 3. 噪音过滤
- **排除**：股票投资分析、理财建议
- **排除**：个人博客、未验证社媒
- **聚焦**：供应链相关、价格/交期/产能

---

## 📤 发送格式

通过 **Feishu** 发送给 Ken（ou_a7195bd3e0508f0e0d09f19ff12a8811）：

```javascript
message({
  action: "send",
  channel: "feishu",
  target: "ou_a7195bd3e0508f0e0d09f19ff12a8811",
  message: `日报内容...`
});
```

### 报告格式示例

```markdown
📊 **电子供应链每日情报简报**

**📅 2026-03-03（周一）**　**⏰ 搜索范围：过去 24 小时**　**🔍 搜索深度：Tavily Deep 模式**

　　

【🔴 红灯事件预警】

**台积电某厂停电**

**真相**：✅ 已证实（台积电官方）　**影响**：部分产能受影响　**紧急度**：🟡中

台积电新竹某晶圆厂因电力故障短暂停产，影响部分先进制程产能，预计2-3天内恢复。

　　

【💼 核心品类动态】

**半导体**

**【存储 (DRAM/NAND)】** → 持平

合约价持平，现货小幅反弹。

　　

**【MCU/功率器件】** ↓ 下跌

渠道去库存继续，价格承压。

　　

**【MLCC/连接器】** → 稳定

交期稳定，无重大变化。

　　

【💰 今日关键指标】

💰 **LME 铜**：$9,200 (+1.2%)　|　金：$2,050 (+0.8%)
💱 **USD/CNY**：7.2500 (+0.1%)

---
*数据来源：Tavily Deep Research | 信源层级：Tier 1（Reuters/CNBC/TrendForce）、Tier 2（原厂公告）、Tier 3（行业资讯）*
*报告生成时间：2026-03-03 01:00 UTC+8*
```

---

## 📅 定时任务配置

```bash
# 通过 OpenClaw cron 配置
# 每天 8:00 执行
{
  "name": "电子供应链每日简报",
  "schedule": {
    "kind": "cron",
    "expr": "0 8 * * *",
    "tz": "Asia/Shanghai"
  },
  "payload": {
    "kind": "agentTurn",
    "message": "生成电子供应链每日情报简报，保存到 /root/.openclaw/workspace/archive/C1-电子供应链每日情报简报/C1-YYYY-MM-DD.md，然后发送给ou_a7195bd3e0508f0e0d09f19ff12a8811。要求：只发送最终报告，不包含任何执行过程、思考步骤、调试信息。",
  },
  "sessionTarget": "isolated"
}
```

---

## 🚀 下一步

1. ✅ 方法论已存档
2. ⏳ 创建日报监控脚本
3. ⏳ 测试 Tavily Deep 模式
4. ⏳ 配置 cron 定时任务（每天 8:00）
5. ⏳ 试运行 3 天，验证效果
6. ⏳ 创建周报技能（基于日报逻辑扩展）

---

_版本：v0.1_
_创建时间：2026-03-03_
_创建者：Claw1号 🪭_
_方法论来源：Ken 提供的 Deep Research 框架_
