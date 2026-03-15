# 飞书智能分批发送 - 通用规则

## 核心逻辑

```python
if total_length <= 4096:
    直接发送（1 条消息）
else:  # total_length > 4096
    分批发送（在 3800~3900 字符主动断开）
```

## 使用方法

### 方式 1：Bash 包装器（推荐）

```bash
# 发送文件内容
bash /root/.openclaw/workspace/send-feishu-with-split.sh "$CONTENT" "$TARGET_ID"

# 或管道方式
echo "$CONTENT" | bash /root/.openclaw/workspace/send-feishu-with-split.sh - "$TARGET_ID"
```

### 方式 2：Python 脚本

```bash
# 从文件
python3 /root/.openclaw/workspace/ai-daily-digest/split-feishu-message.py "$FILE" "$TARGET_ID"

# 从 stdin
echo "$CONTENT" | python3 /root/.openclaw/workspace/ai-daily-digest/split-feishu-message.py - "$TARGET_ID"
```

### 方式 3：在 Python 代码中

```python
import subprocess

content = "你的长消息..."
target = "ou_a7195bd3e0508f0e0d09f19ff12a8811"

result = subprocess.run([
    "bash", "/root/.openclaw/workspace/send-feishu-with-split.sh",
    content, target
], capture_output=True, text=True)
```

## Cron 任务模板

在所有日报任务的 agentTurn 消息中，添加以下步骤：

```bash
# 生成报告后...

**智能分批发送**（防止飞书截断）：
```bash
echo "$REPORT_CONTENT" | bash /root/.openclaw/workspace/send-feishu-with-split.sh - ou_a7195bd3e0508f0e0d09f19ff12a8811
```

# 或者如果是文件
bash /root/.openclaw/workspace/send-feishu-with-split.sh "$(cat $REPORT_FILE)" ou_a7195bd3e0508f0e0d09f19ff12a8811
```

## 已配置的任务

- ✅ Alpha1 - Karpathy AI博客精选
- ⏳ Beta1 - AI三巨头监控
- ⏳ A1 - 电子供应链每日情报简报
- ⏳ B1 - 供应链风险日报
- ⏳ C1 - 政策与法规监控日报
- ⏳ D1 - 宏观财务日报

## 分割策略

1. **优先级 1**：在 `##` 标题处断开
2. **优先级 2**：在 `---` 分隔线处断开
3. **硬性限制**：单行超过 4096 字符强制截断
4. **安全缓冲**：在 3800~3900 字符时主动断开（预留 ~200 字符缓冲）

## 测试

```bash
# 测试短消息（< 4096）
echo "测试" | bash /root/.openclaw/workspace/send-feishu-with-split.sh - ou_a7195bd3e0508f0e0d09f19ff12a8811

# 测试长消息（> 4096）
cat /root/.openclaw/workspace/archive/A1-Karpathy-AI博客精选/A1-2026-03-08.md | bash /root/.openclaw/workspace/send-feishu-with-split.sh - ou_a7195bd3e0508f0e0d09f19ff12a8811
```

---

**创建时间**：2026-03-08
**适用范围**：所有日报、周报、月报任务
