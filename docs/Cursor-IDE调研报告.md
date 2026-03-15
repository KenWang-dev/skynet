# Cursor IDE 调研结果

## 📊 基本信息

**名称**：Cursor AI
**类型**：AI 驱动的代码编辑器
**基于**：VS Code（fork）
**用户**：OpenAI、Perplexity 等公司工程师使用

**核心功能**：
- AI 辅助编码
- 智能代码建议
- 与各种开发工具集成
- AI 聊天功能
- 代码生成和调试

## 🔗 相关资源

### 高质量文档
1. **DataCamp 教程**（相关性 73%）
   - 包含实用示例
   - 初学者友好
   - 链接：https://www.datacamp.com/tutorial/cursor-ai-code-editor

2. **Monday 集成指南**（相关性 53%）
   - 2026 最新集成指南
   - 开发者工作流集成
   - 链接：https://monday.com/blog/rnd/cursor-ai-integration/

3. **Codecademy 完整指南**（相关性 53%）
   - 实用示例
   - 完整教程
   - 链接：https://www.codecademy.com/article/how-to-use-cursor-ai-a-complete-guide-with-practical-examples

### 视频教程
- YouTube 初学者教程（62% 相关性）
- 实操演示（51% 相关性）

## ✅ 可行性分析

### 优势
✅ **基于 VS Code**：我熟悉 VS Code 配置方法
✅ **生态成熟**：有大量配置示例可参考
✅ **用户群体大**：文档需求明确
✅ **技术栈清晰**：配置方法标准化

### 文档内容规划

#### 1. 环境准备
- 下载和安装 Cursor
- 系统要求
- 账号注册

#### 2. Aiberm API 配置
- 获取 API Key
- 配置环境变量
- 使用 .env 文件
- Cursor 设置

#### 3. 代码示例
- Python 示例
- JavaScript/TypeScript 示例
- REST Client 使用（Cursor 内置）

#### 4. AI 辅助功能
- 使用 Cursor AI 调用 Aiberm API
- 提示词工程
- 最佳实践

#### 5. 故障排除
- 常见问题
- 调试技巧
- 性能优化

## 📝 文档结构（符合项目要求）

### 英文版：`src/pages/en/ide-cursor.mdx`

```mdx
---
layout: ../../layouts/DocsLayout.astro
title: Cursor Integration Guide
lang: en
activeId: ide-cursor
---

import CodeExample from '../../components/CodeExample.tsx';
import Callout from '../../components/Callout.tsx';

# Cursor Integration Guide

## Introduction

Cursor is an AI-powered code editor based on VS Code. This guide shows you how to integrate Aiberm API into your Cursor workflow.

<Callout client:load type="tip" title="Prerequisites">
- Cursor installed
- Aiberm API key
- Basic knowledge of REST APIs
</Callout>

## Step 1: Get Your API Key

1. Visit https://aiberm.com
2. Sign up or log in
3. Navigate to **API Keys** section
4. Create a new API key
5. Copy the key (keep it secure!)

## Step 2: Configure Environment

### Option A: Environment Variable (Recommended)

<CodeExample
  client:load
  examples={[{
    key: 'bash',
    label: 'Bash/Zsh',
    code: `# Add to ~/.bashrc or ~/.zshrc
export AIBERM_API_KEY="your_api_key_here"

# Reload shell
source ~/.bashrc  # or source ~/.zshrc`
  }, {
    key: 'powershell',
    label: 'PowerShell',
    code: `# Add to $PROFILE
[System.Environment]::SetEnvironmentVariable('AIBERM_API_KEY', 'your_api_key_here', 'User')`
  }]}
/>

### Option B: .env File

<CodeExample
  client:load
  examples={[{
    key: 'plaintext',
    label: '.env',
    code: `AIBERM_API_KEY=your_api_key_here`
  }]}
/>

<Callout client:load type="warning" title="Security">
Never commit .env files to version control!
</Callout>

## Step 3: Test Your Setup

### Using REST Client Extension

1. Install REST Client extension in Cursor
2. Create a new file `test.http`
3. Add the following:

<CodeExample
  client:load
  examples={[{
    key: 'http',
    label: 'test.http',
    code: `### Test Aiberm API
GET https://api.aiberm.com/v1/chat
Authorization: Bearer {{AIBERM_API_KEY}}
Content-Type: application/json

{
  "model": "aiberm-1",
  "messages": [
    {
      "role": "user",
      "content": "Hello, Aiberm!"
    }
  ]
}`
  }]}
/>

## Usage Examples

### Python Example

<CodeExample
  client:load
  examples={[{
    key: 'python',
    label: 'Python',
    code: `import os
import requests

api_key = os.getenv('AIBERM_API_KEY')

response = requests.post(
    'https://api.aiberm.com/v1/chat',
    headers={
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json'
    },
    json={
        'model': 'aiberm-1',
        'messages': [
            {'role': 'user', 'content': 'Hello!'}
        ]
    }
)

print(response.json())`
  }]}
/>

### TypeScript Example

<CodeExample
  client:load
  examples={[{
    key: 'typescript',
    label: 'TypeScript',
    code: `const apiKey = process.env.AIBERM_API_KEY;

const response = await fetch('https://api.aiberm.com/v1/chat', {
  method: 'POST',
  headers: {
    'Authorization': \`Bearer \${apiKey}\`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    model: 'aiberm-1',
    messages: [
      { role: 'user', content: 'Hello!' }
    ]
  })
});

const data = await response.json();
console.log(data);`
  }]}
/>

## Using Cursor AI

<Callout client:load type="info" title="Pro Tip">
Cursor AI can help you write Aiberm API calls! Try prompting:
"Write a Python function to call Aiberm chat API with error handling"
</Callout>

## Troubleshooting

### Issue: "API key not found"
- **Solution**: Check environment variables are set correctly
- Restart Cursor after adding new variables

### Issue: "401 Unauthorized"
- **Solution**: Verify API key is valid and not expired
- Check for extra spaces in the key

### Issue: Rate limiting
- **Solution**: Implement exponential backoff
- Check your usage limits

## Next Steps

- Explore [Aiberm API Reference](/docs/en/api/chat)
- Learn [Authentication](/docs/en/authentication)
- View [More Examples](/docs/en/examples)

---

## 中文版：`src/pages/zh/ide-cursor.mdx`

```mdx
---
layout: ../../layouts/DocsLayout.astro
title: Cursor 集成指南
lang: zh
activeId: ide-cursor
---

import CodeExample from '../../components/CodeExample.tsx';
import Callout from '../../components/Callout.tsx';

# Cursor 集成指南

## 简介

Cursor 是一款基于 VS Code 的 AI 驱动代码编辑器。本指南将向你展示如何将 Aiberm API 集成到 Cursor 工作流中。

<Callout client:load type="tip" title="前置要求">
- 已安装 Cursor
- Aiberm API 密钥
- 了解 REST API 基础知识
</Callout>

## 步骤 1：获取 API 密钥

1. 访问 https://aiberm.com
2. 注册或登录
3. 导航到 **API Keys** 部分
4. 创建新的 API 密钥
5. 复制密钥（妥善保管！）

## 步骤 2：配置环境

### 选项 A：环境变量（推荐）

<CodeExample
  client:load
  examples={[{
    key: 'bash',
    label: 'Bash/Zsh',
    code: `# 添加到 ~/.bashrc 或 ~/.zshrc
export AIBERM_API_KEY="your_api_key_here"

# 重新加载 shell
source ~/.bashrc  # 或 source ~/.zshrc`
  }, {
    key: 'powershell',
    label: 'PowerShell',
    code: `# 添加到 $PROFILE
[System.Environment]::SetEnvironmentVariable('AIBERM_API_KEY', 'your_api_key_here', 'User')`
  }]}
/>

### 选项 B：.env 文件

<CodeExample
  client:load
  examples={[{
    key: 'plaintext',
    label: '.env',
    code: `AIBERM_API_KEY=your_api_key_here`
  }]}
/>

<Callout client:load type="warning" title="安全提示">
切勿将 .env 文件提交到版本控制系统！
</Callout>

## 步骤 3：测试配置

### 使用 REST Client 扩展

1. 在 Cursor 中安装 REST Client 扩展
2. 创建新文件 `test.http`
3. 添加以下内容：

<CodeExample
  client:load
  examples={[{
    key: 'http',
    label: 'test.http',
    code: `### 测试 Aiberm API
GET https://api.aiberm.com/v1/chat
Authorization: Bearer {{AIBERM_API_KEY}}
Content-Type: application/json

{
  "model": "aiberm-1",
  "messages": [
    {
      "role": "user",
      "content": "你好，Aiberm！"
    }
  ]
}`
  }]}
/>

## 使用示例

### Python 示例

<CodeExample
  client:load
  examples={[{
    key: 'python',
    label: 'Python',
    code: `import os
import requests

api_key = os.getenv('AIBERM_API_KEY')

response = requests.post(
    'https://api.aiberm.com/v1/chat',
    headers={
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json'
    },
    json={
        'model': 'aiberm-1',
        'messages': [
            {'role': 'user', 'content': '你好！'}
        ]
    }
)

print(response.json())`
  }]}
/>

### TypeScript 示例

<CodeExample
  client:load
  examples={[{
    key: 'typescript',
    label: 'TypeScript',
    code: `const apiKey = process.env.AIBERM_API_KEY;

const response = await fetch('https://api.aiberm.com/v1/chat', {
  method: 'POST',
  headers: {
    'Authorization': \`Bearer \${apiKey}\`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    model: 'aiberm-1',
    messages: [
      { role: 'user', content: '你好！' }
    ]
  })
});

const data = await response.json();
console.log(data);`
  }]}
/>

## 使用 Cursor AI

<Callout client:load type="info" title="专业提示">
Cursor AI 可以帮你编写 Aiberm API 调用！试试提示：
"写一个 Python 函数调用 Aiberm 聊天 API，包含错误处理"
</Callout>

## 故障排除

### 问题："找不到 API 密钥"
- **解决方案**：检查环境变量是否正确设置
- 添加新变量后重启 Cursor

### 问题："401 未授权"
- **解决方案**：验证 API 密钥有效且未过期
- 检查密钥中是否有额外空格

### 问题：速率限制
- **解决方案**：实现指数退避
- 检查你的使用限制

## 下一步

- 探索 [Aiberm API 参考](/docs/zh/api/chat)
- 了解[身份验证](/docs/zh/authentication)
- 查看[更多示例](/docs/zh/examples)

---

## 📋 提交前检查清单

### 内容完整性
- [ ] 前置要求说明
- [ ] API Key 获取步骤
- [ ] 环境配置方法
- [ ] 代码示例（Python、TypeScript）
- [ ] REST Client 使用
- [ ] Cursor AI 集成提示
- [ ] 故障排除指南

### 格式规范
- [ ] MDX 格式正确
- [ ] 使用正确的 React 组件
- [ ] 代码语法高亮正确
- [ ] 中英文内容对应

### 项目集成
- [ ] 更新 `src/config/navigation.ts`
- [ ] 放置在正确的语言目录
- [ ] 本地构建测试通过

## 🎯 导航配置更新

需要在 `src/config/navigation.ts` 中添加：

```typescript
{
  id: 'ide-cursor',
  title: {
    en: 'Cursor Integration',
    zh: 'Cursor 集成'
  },
  icon: 'code-2'
}
```

## ⏱️ 时间估算

- 调研：30 分钟 ✅（已完成）
- 编写文档：1.5 小时
- 校对和调整：30 分钟
- 提交 PR：15 分钟
- **总计**：约 2-2.5 小时

## 🎁 预期奖励

- 文档贡献：**10 刀 credit**
- 可能发现疏漏：**2-4 刀 credit**
- **总计**：12-14 刀 credit

---

**状态**：✅ 调研完成，文档草稿已准备

**下一步**：需要你的 GitHub 账号来提交 PR

需要我：
1. **继续搜索其他 IDE（Trae、Antigravity）**？
2. **立即开始提交 Cursor 文档**？
3. **其他行动**？

告诉我你的决定！🚀🪭
