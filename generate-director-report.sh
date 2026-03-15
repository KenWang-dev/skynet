#!/bin/bash
# 采购总监周报生成脚本（v2.0）
# 创建时间：2026-03-07
# 更新时间：2026-03-08
# 执行时间：每周日15:00

# ⚠️ 关键约束（v2.0）：
# 1. 核心洞察必须按影响级别从高到低排序（高→中→低）
# 2. 板块之间使用全角空格分隔（　）
# 3. 禁止发送任何执行过程、思考步骤、调试信息
# 4. 只发送最终报告内容（从标题到签名）

set -e

# 配置
ARCHIVE_BASE="/root/.openclaw/workspace/archive"
WEEK=$(date +%Y-W%V)
DATE=$(date +%Y-%m-%d)
DIRECTOR_REPORT_DIR="$ARCHIVE_BASE/周报-采购总监专业版"
REPORT_FILE="$DIRECTOR_REPORT_DIR/采购总监周报-$WEEK.md"
TEMPLATE="/root/.openclaw/workspace/templates/weekly-report-director-template-v2.md"

# 创建存档目录
mkdir -p "$DIRECTOR_REPORT_DIR"

# 生成周报
cat > "$REPORT_FILE" << EOF
# 📊 采购总监周报

**报告周期**：$(date +Y年第%U周)
**报告时间**：$DATE
**数据来源**：15个监控任务存档报告

---

## 🎯 本周核心洞察（TOP 5）

### 1. [待填充 - 核心发现1]
**影响：** 高/中/低
**来源：** [监控任务名称]
**行动建议：**
- [ ] 具体行动步骤1
- [ ] 具体行动步骤2

### 2. [待填充 - 核心发现2]
**影响：** 高/中/低
**来源：** [监控任务名称]
**行动建议：**
- [ ] 具体行动步骤

### 3. [待填充 - 核心发现3]
**影响：** 高/中/低
**来源：** [监控任务名称]

### 4. [待填充 - 核心发现4]
**影响：** 高/中/低
**来源：** [监控任务名称]

### 5. [待填充 - 核心发现5]
**影响：** 高/中/低
**来源：** [监控任务名称]

---

## 📈 供应链风险仪表盘

### 🔴 红灯预警（立即行动）

$(find $ARCHIVE_BASE/D1-供应链风险日报 -name "*.md" -mtime -7 -exec tail -20 {} \; 2>/dev/null | grep -E "红灯|风险" | head -5 || echo "暂无红灯预警")

### 🟡 黄灯预警（持续关注）

$(find $ARCHIVE_BASE/D1-供应链风险日报 -name "*.md" -mtime -7 -exec tail -20 {} \; 2>/dev/null | grep -E "黄灯|预警" | head -5 || echo "暂无黄灯预警")

### 🟢 绿灯（正常）

其他供应商监控正常

---

## 💰 成本与价格趋势

### 原材料价格

$(find $ARCHIVE_BASE/F1-宏观财务日报 -name "*.md" -mtime -7 -exec tail -30 {} \; 2>/dev/null | grep -E "铜价|铝价|稀土" | head -10 || echo "暂无价格数据")

**行动建议：**
- 根据价格趋势制定采购策略
- 关注关键原材料价格波动

### 汇率

$(find $ARCHIVE_BASE/F1-宏观财务日报 -name "*.md" -mtime -7 -exec grep -A 5 "汇率" {} \; 2>/dev/null | head -10 || echo "暂无汇率数据")

---

## 🚀 AI技术趋势

$(find $ARCHIVE_BASE/B1-AI三巨头监控 -name "*.md" -mtime -7 -exec cat {} \; 2>/dev/null | head -30 || echo "暂无AI技术动态")

**行动建议：**
- 评估AI技术对采购的影响
- 关注AI采购工具机会

---

## 🏭 行业与政策

### 关键政策变化

$(find $ARCHIVE_BASE/E1-政策与法规监控日报 -name "*.md" -mtime -7 -exec grep -E "政策|法规|监管" {} \; 2>/dev/null | head -20 || echo "暂无政策动态")

### 行业动态

$(find $ARCHIVE_BASE/G2-行业市场监控周报 -name "*.md" -mtime -14 -exec cat {} \; 2>/dev/null | head -30 || echo "暂无行业动态")

---

## 💡 下周行动清单

### 立即执行
- [ ] 根据红灯预警采取行动
- [ ] 根据价格趋势调整采购计划

### 持续关注
- [ ] 跟踪黄灯预警供应商
- [ ] 关注AI技术演进

---

## 📊 本周数据统计

- **监控任务运行**：15个
- **生成报告数量**：$(find $ARCHIVE_BASE -name "*.md" -mtime -7 ! -name "*-index.md" ! -name "README.md" | wc -l)份
- **存档文件大小**：$(du -sh $ARCHIVE_BASE | cut -f1)

---

**报告生成时间**：$(date)
**下次更新**：下周日15:00
**存档位置**：$REPORT_FILE

---

_本报告由天网监控系统自动生成_
EOF

echo "✅ 采购总监周报已生成：$REPORT_FILE"
echo "📊 文件大小：$(ls -lh "$REPORT_FILE" | awk '{print $5}')"

# 更新索引
INDEX_FILE="$DIRECTOR_REPORT_DIR/采购总监周报-index.md"
cat > "$INDEX_FILE" << EOF
# 采购总监周报（专业版）- 存档索引

**任务编码**：DIRECTOR-WEEKLY
**更新时间**：$DATE

---

## 📊 报告列表

1. [采购总监周报-$WEEK.md](./采购总监周报-$WEEK.md) - $(date +%Y-%m-%d)

---

## 📈 统计信息

- **总报告数**：$(find $DIRECTOR_REPORT_DIR -name "采购总监周报-*.md" ! -name "*-index.md" | wc -l)
- **最新报告**：采购总监周报-$WEEK.md
- **存档大小**：$(du -sh $DIRECTOR_REPORT_DIR | cut -f1)

---
EOF

echo "✅ 索引文件已更新：$INDEX_FILE"

# 输出报告内容（用于飞书发送）
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 采购总监周报内容预览"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
head -50 "$REPORT_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
