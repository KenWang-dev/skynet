# 统一监控执行器 - 自动存档版本

## 问题诊断

**用户反馈**："废话，要有存档机制啊，早就说了，你自己没有做而已"

**问题根源**：
- ✅ 已创建：archive目录结构、archive-functions.sh、ARCHIVE-STANDARD.md
- ❌ 未执行：16个监控任务**只发飞书，没有保存到archive**
- ❌ 缺失：没有在cron任务payload中集成存档步骤

## 解决方案

### 方案A：修改cron任务payload（推荐）

为每个监控任务的cron payload添加存档步骤：

**修改前**（当前）：
```json
{
  "message": "1. 运行脚本...\n2. 生成报告...\n3. 通过飞书发送..."
}
```

**修改后**（需要）：
```json
{
  "message": "1. 运行脚本...\n2. 生成报告...\n3. **保存到archive**（新增）\n4. 通过飞书发送..."
}
```

### 方案B：使用auto-archive-wrapper.sh

在生成报告后调用存档脚本：

```bash
# 保存报告到archive
bash /root/.openclaw/workspace/auto-archive-wrapper.sh \
  "B1" \
  "AI三巨头监控" \
  "日报" \
  "$REPORT_CONTENT"
```

## 立即行动清单

### 1. 修改16个监控任务的cron配置

需要修改的任务（按编码）：

**每日任务**：
- [ ] A1 - Karpathy AI博客精选
- [ ] B1 - AI三巨头监控
- [ ] C1 - 电子供应链每日情报简报
- [ ] D1 - 供应链风险日报
- [ ] E1 - 政策与法规监控日报
- [ ] F1 - 宏观财务日报

**周报任务**：
- [ ] C2 - 电子供应链周度战略情报
- [ ] D2 - 供应链风险监控周报
- [ ] E2 - 政策与法规监控周报
- [ ] F2 - 宏观财务监控周报
- [ ] G2 - 行业市场监控周报
- [ ] H2 - AI采购最佳实践周报
- [ ] I2 - 全球采购真实心声周报
- [ ] J2 - ESG绿色采购监控周报
- [ ] K2 - 供应商生态系统监控周报

**月报任务**：
- [ ] E3 - 政策与法规监控月报

### 2. 存档步骤模板（在每个任务的cron payload中添加）

```markdown
**步骤X：保存报告到archive**（必须！）
```bash
# 构建存档路径
CODE="B1"
NAME="AI三巨头监控"
DATE=$(date +%Y-%m-%d)
ARCHIVE_DIR="/root/.openclaw/workspace/archive/${CODE}-${NAME}"
FILENAME="${CODE}-${DATE}.md"

# 创建目录并保存报告
mkdir -p "$ARCHIVE_DIR"
echo -e "$REPORT_CONTENT" > "${ARCHIVE_DIR}/${FILENAME}"

# 验证存档
if [ -f "${ARCHIVE_DIR}/${FILENAME}" ]; then
  echo "✅ 报告已存档：${ARCHIVE_DIR}/${FILENAME}"
else
  echo "❌ 存档失败！"
fi
```
```

### 3. 快速批量修复脚本

创建脚本自动更新所有cron任务：

```bash
#!/bin/bash
# 批量添加存档步骤到所有监控任务

# TODO: 使用cron工具更新每个任务的payload
# 在"通过飞书发送"之前添加"保存到archive"步骤
```

## 验证清单

修复后，验证以下内容：

- [ ] 每个监控任务的archive目录中有报告文件（如 B1-2026-03-07.md）
- [ ] 报告文件内容完整（与飞书发送的一致）
- [ ] 索引文件（*-index.md）已更新
- [ ] 总索引（archive/README.md）已更新
- [ ] 周报生成脚本能够读取过去7天的存档报告

## 优先级

**P0（立即执行）**：
1. 修改B1（AI三巨头监控）- 最高频任务
2. 修改A1（Karpathy）- 每天运行
3. 修改C1（电子供应链日报）- 每天运行

**P1（本周完成）**：
4. 修改所有周报任务（C2-K2）

**P2（下周完成）**：
5. 修改月报任务（E3）

---

**创建时间**：2026-03-07 21:40
**状态**：待执行
**责任人**：Claw1号 🪭
