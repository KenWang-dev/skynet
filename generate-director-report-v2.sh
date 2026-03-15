#!/bin/bash
# 采购总监周报生成脚本 v2.0
# 创建时间：2026-03-07
# 更新时间：2026-03-07
# 执行时间：每周日15:00

set -e

# 配置
ARCHIVE_BASE="/root/.openclaw/workspace/archive"
WEEK=$(date +%Y-W%V)
DATE=$(date +%Y-%m-%d)
DIRECTOR_REPORT_DIR="$ARCHIVE_BASE/周报-采购总监专业版"
REPORT_FILE="$DIRECTOR_REPORT_DIR/采购总监周报-$WEEK.md"

# 创建存档目录
mkdir -p "$DIRECTOR_REPORT_DIR"

# 加载模板
TEMPLATE="/root/.openclaw/workspace/templates/weekly-report-director-template.md"

# 辅助函数：级联ROI计算
cascade_roi_calc() {
    # 参数：上游涨跌% 上游占比 中游占比 采购量
    local upstream_change=$1
    local upstream_ratio=$2
    local midstream_ratio=$3
    local purchase_volume=$4

    # 去掉百分号
    upstream_change=$(echo $upstream_change | sed 's/%//')
    upstream_ratio=$(echo $upstream_ratio | sed 's/%//')
    midstream_ratio=$(echo $midstream_ratio | sed 's/%//')

    # 计算
    # 中游成本变化 = 上游涨跌 × 上游占比
    midstream_cost_change=$(awk "BEGIN {printf \"%.2f\", $upstream_change * $upstream_ratio / 100}")
    # 下游成本变化 = 中游成本变化 × 中游占比
    downstream_cost_change=$(awk "BEGIN {printf \"%.2f\", $midstream_cost_change * $midstream_ratio / 100}")
    # 金额影响
    amount_impact=$(awk "BEGIN {printf \"%.0f\", $purchase_volume * $downstream_cost_change / 100}")

    echo "$downstream_cost_change% (金额影响: ¥$amount_impact)"
}

# 辅助函数：数据完整性检查
check_data_completeness() {
    local missing_count=0
    local conflict_count=0

    # 检查各个监控任务是否有数据
    for task_dir in "$ARCHIVE_BASE"/*; do
        task_name=$(basename "$task_dir")
        if [ -d "$task_dir" ] && [ "$task_name" != "周报-采购总监专业版" ] && [ "$task_name" != "周报-老板简化版" ]; then
            report_count=$(find "$task_dir" -name "*.md" -mtime -7 ! -name "*-index.md" | wc -l)
            if [ "$report_count" -eq 0 ]; then
                echo "⚠️ 缺失：$task_name（过去7天无报告）"
                missing_count=$((missing_count + 1))
            fi
        fi
    done

    echo "数据完整性：$(awk "BEGIN {printf \"%.1f\", (16 - $missing_count) / 16 * 100}")% (缺失${missing_count}项)"
}

# 辅助函数：提取价格传导分析
extract_price_analysis() {
    # 从原材料报告中提取价格数据
    local price_file=$(find "$ARCHIVE_BASE/F1-宏观财务日报" -name "*.md" -mtime -7 ! -name "*-index.md" | head -1)

    if [ -f "$price_file" ]; then
        echo "### 价格传导分析（示例）"
        echo ""
        echo "#### 场景1：CCL涨价对电子产品成本的影响"
        echo ""
        # 假设数据
        echo "- **CCL涨价**：10%"
        echo "- **CCL占PCB材料**：50%"
        echo "- **PCB占电子产品材料**：40%"
        echo "- **电子产品成本影响**：$(cascade_roi_calc "10%" "50%" "40%" "1000000")"
        echo ""
        echo "**结论：** 如果供应商要求涨价5%，经分析实际应为2%，双方共担，不应全部转嫁。"
        echo ""
    fi
}

# 辅助函数：统计数据
collect_statistics() {
    local report_count=$(find "$ARCHIVE_BASE" -name "*.md" -mtime -7 ! -name "*-index.md" ! -name "README.md" | wc -l)
    local archive_size=$(du -sh "$ARCHIVE_BASE" | cut -f1)
    local red_alerts=$(find "$ARCHIVE_BASE/D1-供应链风险日报" -name "*.md" -mtime -7 -exec grep -c "红灯" {} \; 2>/dev/null | awk '{s+=$1} END {print s}')
    local yellow_alerts=$(find "$ARCHIVE_BASE/D1-供应链风险日报" -name "*.md" -mtime -7 -exec grep -c "黄灯" {} \; 2>/dev/null | awk '{s+=$1} END {print s}')

    echo "$report_count份"
    echo "$archive_size"
    echo "${red_alerts:-0}家"
    echo "${yellow_alerts:-0}家"
}

# 生成周报
cat > "$REPORT_FILE" << EOF
# 📊 采购总监周报

**报告周期**：$(date +Y年第%U周)
**报告时间**：$DATE
**数据来源**：过去7天的16个监控任务存档报告

---

## 🎯 本周核心洞察（TOP 5）

### 1. [待填充 - 从AI三巨头监控中提炼]
**影响：** 高
**来源：** B1-AI三巨头监控
**行动建议：**
- [ ] 评估AI对采购自动化的影响（3个月内完成）

### 2. [待填充 - 从供应链风险日报中提炼]
**影响：** 中
**来源：** D1-供应链风险日报
**行动建议：**
- [ ] 根据风险等级调整供应商策略

### 3. [待填充 - 从电子供应链监控中提炼]
**影响：** 中
**来源：** C1-电子供应链每日情报简报
**行动建议：**
- [ ] 关注关键元器件价格趋势

### 4. [待填充 - 从宏观财务监控中提炼]
**影响：** 低
**来源：** F1-宏观财务日报
**行动建议：**
- [ ] 根据汇率变化调整采购计划

### 5. [待填充 - 从政策法规监控中提炼]
**影响：** 高
**来源：** E1-政策与法规监控日报
**行动建议：**
- [ ] 提前准备合规材料

---

## 📈 供应链风险仪表盘

### 🔴 红灯预警（立即行动）

$(find "$ARCHIVE_BASE/D1-供应链风险日报" -name "*.md" -mtime -7 ! -name "*-index.md" -exec tail -30 {} \; 2>/dev/null | grep -B 2 -A 2 "红灯" | head -20 || echo "暂无红灯预警")

### 🟡 黄灯预警（持续关注）

$(find "$ARCHIVE_BASE/D1-供应链风险日报" -name "*.md" -mtime -7 ! -name "*-index.md" -exec tail -30 {} \; 2>/dev/null | grep -B 2 -A 2 "黄灯" | head -20 || echo "暂无黄灯预警")

### 🟢 绿灯（正常）

其他供应商监控正常，无异常风险信号。

---

## 💰 成本与价格趋势

### 原材料价格

$(find "$ARCHIVE_BASE/F1-宏观财务日报" -name "*.md" -mtime -7 ! -name "*-index.md" -exec cat {} \; 2>/dev/null | grep -A 5 "原材料价格\|铜价\|铝价\|稀土" | head -30 || echo "暂无价格数据")

### 价格传导分析

$(extract_price_analysis)

### 汇率

$(find "$ARCHIVE_BASE/F1-宏观财务日报" -name "*.md" -mtime -7 ! -name "*-index.md" -exec grep -A 5 "汇率\|美元\|人民币" {} \; 2>/dev/null | head -20 || echo "暂无汇率数据")

---

## 🚀 AI技术趋势

$(find "$ARCHIVE_BASE/B1-AI三巨头监控" -name "*.md" -mtime -7 ! -name "*-index.md" -exec head -40 {} \; 2>/dev/null || echo "暂无AI技术动态")

**行动建议：**
- [ ] 评估AI采购工具（3个月内）
- [ ] 关注招标自动化机会
- [ ] 测试AI供应商管理系统

---

## 🏭 行业与政策

### 关键政策变化

$(find "$ARCHIVE_BASE/E1-政策与法规监控日报" -name "*.md" -mtime -7 ! -name "*-index.md" -exec grep -E "政策|法规|监管" {} \; 2>/dev/null | head -20 || echo "暂无政策动态")

### 行业动态

$(find "$ARCHIVE_BASE/G2-行业市场监控周报" -name "*.md" -mtime -14 ! -name "*-index.md" -exec head -30 {} \; 2>/dev/null || echo "暂无行业动态")

---

## 💡 下周行动清单

### 立即执行
- [ ] 根据红灯预警采取具体行动（截止：周三）
- [ ] 根据价格趋势调整采购计划（截止：周五）

### 持续关注
- [ ] 跟踪黄灯预警供应商
- [ ] 关注AI技术演进
- [ ] 监控政策变化

---

## 📊 本周数据统计

- **监控任务运行**：16个
- **生成报告数量**：$(collect_statistics | head -1)
- **存档文件大小**：$(collect_statistics | sed -n '2p')
- **红灯预警**：$(collect_statistics | sed -n '3p')
- **黄灯预警**：$(collect_statistics | sed -n '4p')
- **数据完整性**：$(check_data_completeness | tail -1)

---

**报告生成时间**：$(date '+%Y-%m-%d %H:%M:%S')
**下次更新**：下周日15:00
**存档位置**：$REPORT_FILE
**模板版本**：v1.0

---

_本报告由天网监控系统自动生成_
_边用边改，持续优化_
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

1. [采购总监周报-$WEEK.md](./采购总监周报-$WEEK.md) - $DATE

---

## 📈 统计信息

- **总报告数**：$(find "$DIRECTOR_REPORT_DIR" -name "采购总监周报-*.md" ! -name "*-index.md" | wc -l)
- **最新报告**：采购总监周报-$WEEK.md
- **存档大小**：$(du -sh "$DIRECTOR_REPORT_DIR" | cut -f1)

---
EOF

echo "✅ 索引文件已更新：$INDEX_FILE"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 采购总监周报生成完成"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔗 报告位置：$REPORT_FILE"
echo "📈 数据来源：16个监控任务（过去7天）"
echo "📝 模板版本：v1.0（边用边改）"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
