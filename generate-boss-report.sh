#!/bin/bash
# 老板周报生成脚本
# 创建时间：2026-03-07
# 执行时间：每周日16:00

set -e

# 配置
ARCHIVE_BASE="/root/.openclaw/workspace/archive"
WEEK=$(date +%Y-W%V)
DATE=$(date +%Y-%m-%d)
BOSS_REPORT_DIR="$ARCHIVE_BASE/周报-老板简化版"
REPORT_FILE="$BOSS_REPORT_DIR/老板周报-$WEEK.md"

# 创建存档目录
mkdir -p "$BOSS_REPORT_DIR"

# 获取本月数据
MONTH_START=$(date -d "$(date +%Y-%m-01)" +%s)
MONTH_END=$(date +%s)
DAYS_IN_MONTH=$(( ($(date +%s) - MONTH_START) / 86400 + 1 ))

# 生成周报
cat > "$REPORT_FILE" << EOF
# 👔 老板周报

**报告周期**：$(date +Y年第%U周)
**报告时间**：$DATE
**数据来源**：采购总监周报 + 15个监控任务

---

## 🔢 本周3个关键数字

### 1. 💰 本月节省：¥[待手动填写]

**原因：**
- 抓住原材料降价机会
- 供应商谈判优化

**行动：**
- [ ] 具体行动1
- [ ] 具体行动2

### 2. ⚠️ 供应商风险：[待填写]家预警

**红灯预警：**
$(find $ARCHIVE_BASE/D1-供应链风险日报 -name "*.md" -mtime -7 -exec grep -E "红灯" {} \; 2>/dev/null | wc -l)家

**黄灯预警：**
$(find $ARCHIVE_BASE/D1-供应链风险日报 -name "*.md" -mtime -7 -exec grep -E "黄灯" {} \; 2>/dev/null | wc -l)家

**行动：**
- [ ] 审核红灯预警供应商
- [ ] 跟踪黄灯预警供应商

### 3. 🤖 AI技术趋势：[待填写]

**影响：**
- 采购自动化机会
- 竞争对手技术升级

**行动：**
- [ ] 3个月内评估AI工具

---

## 💡 1个建议

### 🎯 本周优先级：NO.1

**[待填写 - 最关键的事项]**

**为什么：**
- [原因分析]

**怎么做：**
- [ ] 步骤1
- [ ] 步骤2
- [ ] 步骤3

**预期结果：**
- [量化目标]

---

## 📊 ROI仪表盘（本月）

### 避免损失：¥[待填写]

- 提前预警供应商破产：[ ]家
- 避开原材料涨价：[ ]次

### 节省成本：¥[待填写]

- 抓住降价机会：[ ]次
- 谈判优化：[ ]家供应商

### 时间节省：[ ]小时

- 自动化信息收集：[ ]小时/周
- 减少人工搜索：[ ]小时/周

---

### 📈 本月总价值

| 项目 | 金额 |
|------|------|
| 避免损失 | ¥[待填写] |
| 节省成本 | ¥[待填写] |
| 时间价值（¥500/小时） | ¥[待填写] |
| **总价值** | **¥[待计算]** |
| 系统成本 | ¥3,000 |
| **ROI** | **[待计算]%** |

**注：** 本月已运行 $DAYS_IN_MONTH 天

---

## ⚡ 下周关注

1. **[待填写1]**
   - 影响：高/中/低
   - 时间：[具体时间]

2. **[待填写2]**
   - 影响：高/中/低

3. **[待填写3]**
   - 影响：高/中/低

---

## 📊 本周数据统计

- **监控任务运行**：15个
- **生成报告数量**：$(find $ARCHIVE_BASE -name "*.md" -mtime -7 ! -name "*-index.md" ! -name "README.md" | wc -l)份
- **供应商预警**：$(find $ARCHIVE_BASE/D1-供应链风险日报 -name "*.md" -mtime -7 -exec grep -E "红灯|黄灯" {} \; 2>/dev/null | wc -l)家
- **存档文件大小**：$(du -sh $ARCHIVE_BASE | cut -f1)

---

## 🔗 相关报告

- 📊 [采购总监周报](../周报-采购总监专业版/采购总监周报-$WEEK.md)（详细版）
- 📁 [存档总索引](../README.md)

---

**报告生成时间**：$(date)
**下次更新**：下周日16:00
**存档位置**：$REPORT_FILE

---

_本报告由天网监控系统自动生成_
_简化版：专为中小企业老板设计_
EOF

echo "✅ 老板周报已生成：$REPORT_FILE"
echo "📊 文件大小：$(ls -lh "$REPORT_FILE" | awk '{print $5}')"

# 更新索引
INDEX_FILE="$BOSS_REPORT_DIR/老板周报-index.md"
cat > "$INDEX_FILE" << EOF
# 老板周报（简化版）- 存档索引

**任务编码**：BOSS-WEEKLY
**更新时间**：$DATE

---

## 📊 报告列表

1. [老板周报-$WEEK.md](./老板周报-$WEEK.md) - $(date +%Y-%m-%d)

---

## 📈 统计信息

- **总报告数**：$(find $BOSS_REPORT_DIR -name "老板周报-*.md" ! -name "*-index.md" | wc -l)
- **最新报告**：老板周报-$WEEK.md
- **存档大小**：$(du -sh $BOSS_REPORT_DIR | cut -f1)

---
EOF

echo "✅ 索引文件已更新：$INDEX_FILE"

# 输出报告内容（用于飞书发送）
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "👔 老板周报内容预览"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
head -60 "$REPORT_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
