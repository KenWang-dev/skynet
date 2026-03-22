---
name: supplier-ecosystem-monitor
version: 1.0.0
author: OpenClaw Agent
description: 供应商生态系统监控。监控供应商市场动态、兼并收购、产能扩张、技术突破、战略合作等信息，全方位监控供应商生态系统的变化。使用 Tavily 搜索行业新闻、企业公告、财报信息。当用户请求"监控供应商"、"供应商兼并"、"产能扩张"、或"供应商风险"时使用此技能。
---

# 供应商生态监控 Skill

## 🎯 监控目标

监控全球供应商生态，发现新供应商机会，预判供应能力变化，监控供应商风险。

---

## 📊 五维监控框架

### D1 供应商发现（Supplier Discovery）
- 新兴供应商（技术突破、细分专家）
- 区域供应商（近岸外包、本地化）
- 替代供应商（第二来源、去风险化）

### D2 供应商能力分析（Supplier Capability）
- 产能变化（扩产、减产、新工厂）
- 技术升级（新工艺、新材料）
- 质量表现（良率、缺陷）
- 交付能力（交期、物流）

### D3 供应商风险监控（Supplier Risk）
- 财务风险（亏损、债务、现金流）
- 合规风险（制裁、环保、劳工）
- 地缘风险（台海、贸易战）
- 供应中断（火灾、停电、疫情）

### D4 供应商生态（Supplier Ecosystem）
- 并购整合（收购、合并、分拆）
- 战略合作（联合研发、联盟）
- 竞争格局（新进入者、退出者）
- 产业链整合（纵向、横向）

### D5 价格与成本趋势（Price & Cost Trends）
- 原材料价格（铜、铝、稀土）
- 供应商涨价/降价
- 成本驱动因素（能源、人工）
- 供需关系（买方/卖方市场）

version: 1.0.0
author: OpenClaw Agent
---

## 🎯 重点关注品类

### 核心元器件
- 半导体（芯片、MCU、存储）
- 被动元件（电容、电感、电阻）
- 显示器件（LCD、OLED）

### 特种材料
- 稀土永磁（钕铁硼）
- 特种合金（钛合金）
- 复合材料（碳纤维）

### 关键零部件
- 连接器、电源管理、传感器

---

## 🌍 区域覆盖

- **中国**：制造中心（中芯国际、京东方）
- **欧美**：技术领先（Intel、博世）
- **日韩**：高端制造（三星、村田）
- **台湾**：代工枢纽（台积电、国巨）

---

## 📁 脚本文件

**run.sh**
- 数据收集脚本
- 27个定向搜索（D1-D5）
- 执行时间：约3-4分钟

**监控框架.md**
- 完整监控框架设计
- 搜索策略和指标体系

---

## 🚀 使用方法

```bash
# 数据收集
bash /root/.openclaw/workspace/skills/supplier-ecosystem-monitor/run.sh

# 查看结果
ls /tmp/supplier-ecosystem-monitor/*_${TIMESTAMP}.txt

# 保存存档（必须！）
ARCHIVE_DIR="/root/.openclaw/workspace/archive/K2-供应商生态系统监控周报"
mkdir -p "$ARCHIVE_DIR"
DATE=$(date +%Y-%m-%d)
WEEK=$(date +%Y-W%V)
# 合并所有搜索结果并保存为周报
cat /tmp/supplier-ecosystem-monitor/*_${TIMESTAMP}.txt > "$ARCHIVE_DIR/K2-周报-${WEEK}.md"
echo "✅ 已保存存档：$ARCHIVE_DIR/K2-周报-${WEEK}.md"
```

---

## 📅 监控频率

**建议**：
- 日报：紧急风险（供应中断、地缘风险）
- 周报：趋势分析（供应商发现、能力变化）
- 月报：深度洞察（价格趋势、生态分析）

---

_版本：v1.0_
_创建时间：2026-03-05_
_搜索数量：27个定向搜索_
