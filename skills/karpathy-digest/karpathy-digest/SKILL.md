---
name: karpathy-digest
description: "运行 Karpathy 同款 AI 博客每日精选。来源：90 个顶级技术博客，AI 评分筛选，生成结构化摘要。使用 ai-daily-digest 脚本。触发：digest、博客、每日简报、tech digest、Karpathy"
---

# Karpathy 同款 AI 博客

每天自动抓取 Karpathy 推荐的 90 个顶级技术博客，AI 评分筛选生成每日精选。

## 命令

### /digest

运行每日精选生成器。

---

## 环境要求

- bun 运行时
- Aiberm API（已配置）
- 网络访问

---

## 执行脚本

```bash
# 配置
export OPENAI_API_KEY="sk-MaotlYGe8iI54E3JJpECfK0aTk6gTQvt0NQ9aalnZ1GMvglp"
export OPENAI_API_BASE="https://aiberm.com/v1"
export OPENAI_MODEL="gemini-3-flash-preview"

# 运行
cd /root/.openclaw/workspace/ai-daily-digest
npx -y bun scripts/digest.ts \
  --hours 48 \
  --top-n 10 \
  --lang zh \
  --output ./output/digest.md
```

---

## 输出格式

生成后提取关键信息，格式如下：

🏆 今日 TOP10（From Karpathy - 90 个顶级技术博客）：

1. 标题 | 分类 | 分数
摘要内容
　

2. ...

---

## 发送给用户

执行完成后：
1. 读取生成的 ./output/digest.md
2. 整理成简洁的 TOP10 格式（直接发给我）
3. **保存存档**（必须！）：
   ```bash
   date=$(date +%Y-%m-%d)
   cp ./output/digest.md "/root/.openclaw/workspace/archive/A1-Karpathy-AI博客精选/A1-$date.md"
   ```
4. 通过飞书发送给 Ken
5. 飞书 target ID: ou_a7195bd3e0508f0e0d09f19ff12a8811（Ken 的 open_id）
6. 格式：
   - **加粗文字**
   - 条目之间用全角空格 `　` 空行
   - 格式：编号. **标题** | 分类 | ⭐分数
   - 描述内容
