# 存档要求

**重要：** 每次生成报告后必须先保存到本地，再发送飞书！

## 存档步骤

### 根据报告类型选择对应的存档模板：

**日报：**
```bash
ARCHIVE_DIR="/root/.openclaw/workspace/archive/[代码]-[任务名称]"
mkdir -p "$ARCHIVE_DIR"
DATE=$(date +%Y-%m-%d)
echo "$report_content" > "$ARCHIVE_DIR/[代码]-$DATE.md"
echo "✅ 已保存存档：$ARCHIVE_DIR/[代码]-$DATE.md"
```

**周报：**
```bash
ARCHIVE_DIR="/root/.openclaw/workspace/archive/[代码]-[任务名称]"
mkdir -p "$ARCHIVE_DIR"
WEEK=$(date +%Y-W%V)
echo "$report_content" > "$ARCHIVE_DIR/[代码]-周报-${WEEK}.md"
echo "✅ 已保存存档：$ARCHIVE_DIR/[代码]-周报-${WEEK}.md"
```

**月报：**
```bash
ARCHIVE_DIR="/root/.openclaw/workspace/archive/[代码]-[任务名称]"
mkdir -p "$ARCHIVE_DIR"
MONTH=$(date +%Y-%m)
echo "$report_content" > "$ARCHIVE_DIR/[代码]-月报-${MONTH}.md"
echo "✅ 已保存存档：$ARCHIVE_DIR/[代码]-月报-${MONTH}.md"
```

---

## 验证存档

```bash
# 检查文件是否存在
ls -lh /root/.openclaw/workspace/archive/[代码]-[任务名称]/ | tail -5

# 检查文件内容
head -20 /root/.openclaw/workspace/archive/[代码]-[任务名称]/[代码]-YYYY-MM-DD.md
```

---

## 任务代码对照

| 代码 | 任务名称 | 类型 | 文件格式 |
|------|---------|------|----------|
| E2 | 政策与法规监控周报 | 周报 | E2-周报-YYYY-Www.md |
| E3 | 政策与法规监控月报 | 月报 | E3-月报-YYYY-MM.md |
| H2 | AI采购最佳实践周报 | 周报 | H2-周报-YYYY-Www.md |
| I2 | 采购心声监控周报 | 周报 | I2-周报-YYYY-Www.md |
| K2 | 供应商生态系统监控周报 | 周报 | K2-周报-YYYY-Www.md |

---

**记住：先保存本地，再发送飞书！** 🪭
