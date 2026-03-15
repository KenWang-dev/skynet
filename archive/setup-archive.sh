#!/bin/bash
# 批量修复监控任务存档机制

echo "开始批量修复监控任务存档机制..."

# 创建所有存档目录
mkdir -p /root/.openclaw/workspace/archive/{A1-Karpathy-AI博客精选,B1-AI三巨头监控,C1-电子供应链每日情报简报,C2-电子供应链周度战略情报,D1-供应链风险日报,D2-供应链风险监控周报,E1-政策与法规监控日报,E2-政策与法规监控周报,E3-政策与法规监控月报,F1-宏观财务日报,F2-宏观财务周报,G2-行业市场监控周报,H2-AI采购最佳实践周报,I2-采购心声监控周报,J2-ESG绿色采购监控周报,K2-供应商生态系统监控周报}

echo "✅ 存档目录已创建"

# 创建索引文件
for dir in /root/.openclaw/workspace/archive/*/; do
  code=$(basename "$dir" | cut -d'-' -f1)
  name=$(basename "$dir" | cut -d'-' -f2-)
  index_file="$dir/${code}-index.md"

  if [ ! -f "$index_file" ]; then
    cat > "$index_file" << EOF
# ${name} - 存档索引

**任务编码**：${code}
**创建时间**：$(date +%Y-%m-%d)

---

## 📊 报告列表

暂无报告

---

## 📈 统计信息

- **总报告数**：0
- **最早报告**：-
- **最新报告**：-

---
EOF
  fi
done

echo "✅ 索引文件已创建"

# 更新总索引
cat > /root/.openclaw/workspace/archive/README.md << 'EOF'
# 天网监控系统 - 存档总索引

**SkyNet Monitoring System**
**Archive System v3.0**

**更新时间**：2026-03-07

---

## 📊 任务概览

### AI类（2个）
- [A1 - Karpathy AI博客精选](./A1-Karpathy-AI博客精选/A1-index.md)
- [B1 - AI三巨头监控](./B1-AI三巨头监控/B1-index.md)

### 采购类-活下去（7个）
- [C1 - 电子供应链每日情报简报](./C1-电子供应链每日情报简报/C1-index.md)
- [C2 - 电子供应链周度战略情报](./C2-电子供应链周度战略情报/C2-index.md)
- [D1 - 供应链风险日报](./D1-供应链风险日报/D1-index.md)
- [D2 - 供应链风险监控周报](./D2-供应链风险监控周报/D2-index.md)
- [E1 - 政策与法规监控日报](./E1-政策与法规监控日报/E1-index.md)
- [E2 - 政策与法规监控周报](./E2-政策与法规监控周报/E2-index.md)
- [E3 - 政策与法规监控月报](./E3-政策与法规监控月报/E3-index.md)

### 采购类-活得好（2个）
- [H2 - AI采购最佳实践周报](./H2-AI采购最佳实践周报/H2-index.md)
- [I2 - 采购心声监控周报](./I2-采购心声监控周报/I2-index.md)

### 采购类-活得久（5个）
- [F1 - 宏观财务日报](./F1-宏观财务日报/F1-index.md)
- [F2 - 宏观财务周报](./F2-宏观财务周报/F2-index.md)
- [G2 - 行业市场监控周报](./G2-行业市场监控周报/G2-index.md)
- [J2 - ESG绿色采购监控周报](./J2-ESG绿色采购监控周报/J2-index.md)
- [K2 - 供应商生态系统监控周报](./K2-供应商生态系统监控周报/K2-index.md)

---

## 📈 总体统计

**总任务数**：16个
**总报告数**：0（存档系统刚建立）
**存档大小**：0 KB

---

## 🎯 存档规范

**命名格式**：`[代码]-YYYY-MM-DD.md`（日报）、`[代码]-周报-YYYY-Www.md`（周报）
**存档位置**：`/root/.openclaw/archive/[代码]-[任务名称]/`
**更新时间**：2026-03-07
**维护者**：Claw1号 🪭
EOF

echo "✅ 总索引已更新"
echo ""
echo "🎉 存档系统初始化完成！"
echo ""
echo "📁 存档目录结构："
ls -1 /root/.openclaw/workspace/archive/ | grep -E "^[A-Z]"
