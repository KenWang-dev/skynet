# 📋 存档步骤模板

**适用于所有监控任务**

## 日报存档模板

```bash
# 保存存档
ARCHIVE_DIR="/root/.openclaw/workspace/archive/[代码]-[任务名称]"
mkdir -p "$ARCHIVE_DIR"
DATE=$(date +%Y-%m-%d)
echo "$report_content" > "$ARCHIVE_DIR/[代码]-$DATE.md"
echo "✅ 已保存存档：$ARCHIVE_DIR/[代码]-$DATE.md"
```

## 周报存档模板

```bash
# 保存存档
ARCHIVE_DIR="/root/.openclaw/workspace/archive/[代码]-[任务名称]"
mkdir -p "$ARCHIVE_DIR"
WEEK=$(date +%Y-W%V)
echo "$report_content" > "$ARCHIVE_DIR/[代码]-周报-${WEEK}.md"
echo "✅ 已保存存档：$ARCHIVE_DIR/[代码]-周报-${WEEK}.md"
```

## 月报存档模板

```bash
# 保存存档
ARCHIVE_DIR="/root/.openclaw/workspace/archive/[代码]-[任务名称]"
mkdir -p "$ARCHIVE_DIR"
MONTH=$(date +%Y-%m)
echo "$report_content" > "$ARCHIVE_DIR/[代码]-月报-${MONTH}.md"
echo "✅ 已保存存档：$ARCHIVE_DIR/[代码]-月报-${MONTH}.md"
```

---

## 任务代码对照表

| 代码 | 任务名称 | 类型 | 存档路径 |
|------|---------|------|----------|
| E2 | 政策与法规监控周报 | 周报 | `E2-政策与法规监控周报/E2-周报-YYYY-Www.md` |
| E3 | 政策与法规监控月报 | 月报 | `E3-政策与法规监控月报/E3-月报-YYYY-MM.md` |
| H2 | AI采购最佳实践周报 | 周报 | `H2-AI采购最佳实践周报/H2-周报-YYYY-Www.md` |
| I2 | 采购心声监控周报 | 周报 | `I2-采购心声监控周报/I2-周报-YYYY-Www.md` |
| K2 | 供应商生态系统监控周报 | 周报 | `K2-供应商生态系统监控周报/K2-周报-YYYY-Www.md` |

---

**使用方法：** 将对应的模板复制到监控任务的 SKILL.md 或脚本中。
