# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.

## 飞书知识库配置

### 核心配置文件
- **位置**：`/root/.openclaw/workspace/scripts/feishu-config.sh`
- **Space ID**：`7615440793062394844`
- **知识库名称**：Claw1号知识库
- **Wiki URL**：https://procurement-leap.feishu.cn/wiki/KvTgwudfqi3OcEke7qBc9Pkpn2d

### 文件夹映射（监控任务 → 飞书文件夹）

| 任务代码 | 任务名称 | 飞书文件夹 | Parent Node Token |
|---------|---------|-----------|-------------------|
| A1 | Karpathy AI博客精选 | Alpha 系列 - AI技术前沿 | `IICqwHgTliX60VkrvlmcYFa5nDf` |
| B1 | AI三巨头监控 | Beta 系列 - AI巨头动态 | `HQSkwMzj7iI42pkpFikc1ai8n4d` |
| Gamma1/2 | 资本风向日报/周报 | Gamma 系列 - 资本风向 | `R9XTwwpCyiSKIVksAoBc9lFsnkr` |
| Delta1/2 | 政策推手日报/周报 | Delta 系列 - 政策推手 | `EeMxwc2IVixEH9kHQUycc1kfnOc` |
| C1/C2/D1/D2 | 供应链监控 | 供应链监控 | `KXgzwwqbii0BQmke1ArcGRZ8n3c` |
| F1/F2 | 宏观财务日报/周报 | 宏观财务 | `CxL9wx41XifAkYkMUIkchgSYnsc` |
| E1/E2/E3/G2 | 行业与政策 | 行业与政策 | `TZ70wI9JGiAByak112kcb7kenec` |
| 其他 | 其他监控任务 | 其他监控 | `S6pSwUGbCie1lwkyu6gcXxncnBe` |

### 使用方法

**创建新文档到知识库**：
```javascript
// 步骤1：创建文档节点
feishu_wiki({
  action: "create",
  space_id: "7615440793062394844",
  parent_node_token: "HQSkwMzj7iI42pkpFikc1ai8n4d", // 根据任务选择
  obj_type: "docx",
  title: "B1-AI三巨头监控 2026-03-13"
});

// 步骤2：写入内容
feishu_doc({
  action: "write",
  doc_token: "返回的 obj_token",
  content: "报告内容（Markdown格式）"
});
```

**快速查找配置**：
- 所有 folder token 都在 `feishu-config.sh` 中
- 完整指南：`/root/.openclaw/workspace/docs/feishu-storage-guide.md`

---

## 搜索引擎配置

### 存储位置
- **Tavily Key 池**：`/root/.openclaw/workspace/tavily-key-pool.json`
- **Tavily 管理脚本**：`/root/.openclaw/workspace/tavily-pool.py`
- **Brave API Key**：`/root/.openclaw/.env` 和 `openclaw.json`

### 优先级策略（2026-03-15 更新）

| 场景 | 使用引擎 | 模式 | 说明 |
|------|----------|------|------|
| 日常监控任务 | **Tavily** | 普通模式 | 快速、AI 优化 |
| 重要监控任务 | **Tavily** | **Deep 模式** | 多源验证、深度分析 |
| 特殊/关键任务 | **Brave Search** | 标准 | 快速、稳定、无配额限制 |
| Tavily 配额用尽 | Brave Search | 标准 | 自动降级 |

### 1. Tavily Search（首选）
- **工具**：`tavily`（技能）
- **API Key 轮换池**：6 个 Key，共 **6000 次/月**
- **管理脚本**：`python3 /root/.openclaw/workspace/tavily-pool.py`
- **模式**：
  - **普通模式**：快速搜索，适合日常监控
  - **Deep 模式**：多源验证，适合重要任务
- **特点**：
  - AI 优化，专为 AI 代理设计
  - 支持多 Key 自动轮换（用量 > 90% 自动切换）
  - 每月 1 日自动重置配额

### 2. Brave Search（备用/关键任务）
- **工具**：`web_search`
- **特点**：
  - 快速搜索（约1秒）
  - 无配额限制
  - 支持区域/时间过滤

### 轮换池命令
```bash
# 查看状态
python3 /root/.openclaw/workspace/tavily-pool.py status

# 获取当前可用 Key
python3 /root/.openclaw/workspace/tavily-pool.py get

# 添加新 Key
python3 /root/.openclaw/workspace/tavily-pool.py add "tvly-dev-xxx..." "备注"

# 每月重置（cron 自动执行）
python3 /root/.openclaw/workspace/tavily-pool.py reset
```

**配置时间**：2026-03-15
**状态**：✅ Tavily 轮换池已配置（6 Key, 6000 次/月）

## 外部文档引用

### Claude Code 使用技巧
- **文档**：`Claude Code Tips.md`
- **内容**：模型切换、/insights 命令、交互优化
- **用途**：提升 Claude Code 使用效率
- **更新时间**：2026-02-06
