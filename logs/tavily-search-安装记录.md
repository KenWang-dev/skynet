# Tavily Search 技能安装记录

## 安装状态：✅ 成功

**安装时间**：2026-02-24 18:37
**来源**：https://github.com/openclaw/skills/tree/main/skills/arun-8687/tavily-search

## 技能信息

**名称**：Tavily Search
**功能**：AI 优化的网页搜索（通过 Tavily API）
**描述**：为 AI 代理设计，返回简洁、相关的搜索结果
**官网**：https://tavily.com

## 已安装文件

```
/root/.openclaw/workspace/skills/tavily-search/
├── SKILL.md              # 技能说明文档
└── scripts/
    ├── search.mjs        # 搜索脚本（2299 字节）
    └── extract.mjs       # 网页内容提取脚本（1336 字节）
```

## 功能特性

### 1. 网页搜索

```bash
node /root/.openclaw/workspace/skills/tavily-search/scripts/search.mjs "query"
node /root/.openclaw/workspace/skills/tavily-search/scripts/search.mjs "query" -n 10
node /root/.openclaw/workspace/skills/tavily-search/scripts/search.mjs "query" --deep
node /root/.openclaw/workspace/skills/tavily-search/scripts/search.mjs "query" --topic news
```

### 2. 参数选项

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `-n <count>` | 结果数量（最多 20） | 5 |
| `--deep` | 使用高级搜索（更深入、更慢） | 基础搜索 |
| `--topic <topic>` | 搜索主题（general/news） | general |
| `--days <n>` | 新闻搜索限制天数 | 7 |

### 3. 网页内容提取

```bash
node /root/.openclaw/workspace/skills/tavily-search/scripts/extract.mjs "https://example.com/article"
```

## 环境要求

### 必需

1. **Node.js**（已安装）
   - 脚本使用 `#!/usr/bin/env node` 运行

2. **TAVILY_API_KEY**（需要配置）
   - 获取地址：https://tavily.com
   - 需要设置环境变量才能使用

### 配置 API Key

#### 方法1：环境变量（推荐）
```bash
export TAVILY_API_KEY="your_api_key_here"
```

#### 方法2：在 .bashrc 或 .zshrc 中添加
```bash
echo 'export TAVILY_API_KEY="your_api_key_here"' >> ~/.bashrc
source ~/.bashrc
```

#### 方法3：在 Gateway 配置中设置
通过 `openclaw configure` 添加环境变量

## 使用示例

### 基础搜索
```bash
node /root/.openclaw/workspace/skills/tavily-search/scripts/search.mjs "人工智能最新进展"
```

### 高级搜索（深度研究）
```bash
node /root/.openclaw/workspace/skills/tavily-search/scripts/search.mjs "量子计算原理" --deep -n 10
```

### 新闻搜索
```bash
node /root/.openclaw/workspace/skills/tavily-search/scripts/search.mjs "深圳科技新闻" --topic news --days 7
```

### 网页内容提取
```bash
node /root/.openclaw/workspace/skills/tavily-search/scripts/extract.mjs "https://example.com/article"
```

## 优势

✅ **AI 优化**：专为 AI 代理设计，返回干净、相关的内容片段
✅ **深度搜索**：支持高级搜索模式，适用于复杂研究问题
✅ **新闻搜索**：可以搜索最新新闻和事件
✅ **内容提取**：可以从 URL 提取完整内容
✅ **灵活性**：支持多种参数配置

## 注意事项

⚠️ **API Key 必需**
- 必须从 https://tavily.com 获取 API key
- 可能需要注册账号
- 可能有使用限制（免费/付费计划）

⚠️ **网络访问**
- 需要能访问 Tavily API
- 搜索结果依赖于网络连接

⚠️ **使用限制**
- 免费计划可能有调用次数限制
- 结果数量有上限（最多 20 条）

## 下一步

1. **获取 API Key**
   - 访问 https://tavily.com
   - 注册账号
   - 获取 API key

2. **配置环境变量**
   - 设置 TAVILY_API_KEY

3. **测试搜索**
   ```bash
   node /root/.openclaw/workspace/skills/tavily-search/scripts/search.mjs "测试查询"
   ```

4. **集成到工作流**
   - 可以在其他脚本中调用
   - 可以作为独立的搜索工具使用

---

**安装完成！** 技能已成功安装到本地。

*需要 API Key 才能使用。请先到 https://tavily.com 获取。*
