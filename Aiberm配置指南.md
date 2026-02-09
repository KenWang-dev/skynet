# Aiberm API 配置指南

## 文档来源
https://aiberm.com/docs/en/openclaw/

## 快速配置步骤

### 1. 安装 Aiberm 插件
```bash
openclaw plugins install openclaw-aiberm
openclaw plugins enable openclaw-aiberm
openclaw gateway restart
```

### 2. 认证（两种方式）

**方式 A：交互式认证**
```bash
openclaw models auth login --provider aiberm --set-default
# 然后粘贴 API key
```

**方式 B：环境变量**
```bash
export AIBERM_API_KEY=sk-your-api-key
```

### 3. 可用模型（部分）

**Claude 系列：**
- `aiberm/anthropic/claude-sonnet-4.5` ← 你要换的
- `aiberm/anthropic/claude-opus-4.5`
- `aiberm/anthropic/claude-haiku-4.5`
- `aiberm/anthropic/claude-sonnet-4.5:thinking`

**GPT 系列：**
- `aiberm/openai/gpt-4o`
- `aiberm/openai/gpt-4o-mini`
- `aiberm/openai/gpt-4.1`

**其他：**
- `aiberm/google/gemini-2.5-pro`
- `aiberm/deepseek/deepseek-r1`
- `aiberm/x-ai/grok-4.1-fast`

### 4. 查看所有可用模型
```bash
openclaw models list | grep aiberm
```

## Base URL
- 自动配置为：https://aiberm.com/v1（无需手动设置）

## 获取 API Key
访问：https://aiberm.com/console/token

## 故障排查

### "No provider plugins found" 错误
```bash
# 检查插件状态
openclaw plugins list

# 重新启用
openclaw plugins enable openclaw-aiberm
openclaw gateway restart
```

### 401/403 错误
- 401：API key 未设置或无效
- 403：权限不足或 key 过期
- 检查：https://aiberm.com/console/token

## 优势
✅ 一个 API key 访问所有模型
✅ 动态加载最新模型（无需更新插件）
✅ 支持 GPT、Claude、Gemini、DeepSeek、Grok 等

## 完整文档
https://aiberm.com/docs/en/openclaw/
