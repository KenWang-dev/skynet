# API 集成指南

## ✅ 已集成的 API（立即可用）

### 1. GDELT - 全球事件数据库

**用途：** 政策推手监控、全球舆情分析

**使用示例：**
```bash
# Source API functions
source /root/.openclaw/workspace/scripts/api-functions.sh

# 获取最近15分钟的文章
gdelt_recent

# 搜索特定主题（如AI政策）
gdelt_search "artificial intelligence policy" 50
```

**数据格式：** JSON
**限制：** 无（免费使用）

---

### 2. Reddit - 社交媒体

**用途：** 全球采购从业者心声监控

**使用示例：**
```bash
# Source API functions
source /root/.openclaw/workspace/scripts/api-functions.sh

# 获取 r/procurement 最新25条
reddit_fetch "procurement" 25

# 搜索"供应链管理"相关讨论
reddit_search "supply chain" "all" 50

# 获取 r/supplychain 最新帖子
reddit_fetch "supplychain" 25
```

**数据格式：** JSON
**限制：** 无（公开数据）

**推荐的 Subreddit：**
- r/procurement（采购）
- r/supplychain（供应链）
- r/logistics（物流）
- r/ProcurementTales（采购故事）

---

### 3. GitHub - 代码与开发

**用途：** AI 技术底座监控、开源项目追踪

**使用示例：**
```bash
# Source API functions
source /root/.openclaw/workspace/scripts/api-functions.sh

# 获取仓库信息
github_repo "openai/openai-quickstart-python"

# 搜索 AI 相关项目
github_search "artificial intelligence"

# 获取 Python 趋势项目
github_trending "python" "daily"

# 搜索 LLM 相关项目
github_search "LLM language model"
```

**数据格式：** JSON
**限制：** 无认证60次/小时，有认证5000次/小时

**推荐监控：**
- OpenAI 仓库更新
- Anthropic 开源项目
- AI 框架（PyTorch, TensorFlow）
- LLM 相关项目

---

### 4. USGS - 美国地质调查局

**用途：** 原材料监控、矿产数据

**使用示例：**
```bash
# Source API functions
source /root/.openclaw/workspace/scripts/api-functions.sh

# 获取最近地震数据（可能影响供应链）
usgs_earthquakes 4.5 20

# 查询矿产数据（需手动访问特定API）
# 参考文档: https://mrdata.usgs.gov/
```

**数据格式：** JSON
**限制：** 无（免费使用）

---

## ⚠️ 需要注册的 API

### 5. Tushare - A股数据

**申请步骤：**

1. **访问官网：** https://tushare.pro/register
2. **注册账号：**
   - 填写手机号
   - 设置密码
   - 验证手机
3. **实名认证：**
   - 上传身份证照片
   - 人脸识别
4. **获取 Token：**
   - 登录后访问：https://tushare.pro/user/token
   - 复制 API Token
5. **配置到 OpenClaw：**
   ```bash
   # 编辑配置文件
   nano /root/.openclaw/.env.api-keys

   # 找到这一行：
   TUSHARE_API_TOKEN=your_token_here

   # 替换为你的 Token：
   TUSHARE_API_TOKEN=abc123def456...

   # 保存并退出
   ```

**用途：** 监控红杉中国、IDG 等投资动态

**使用示例：**
```bash
source /root/.openclaw/workspace/scripts/api-functions.sh

# 获取股票基本信息
tushare_stock_info "000001.SZ"

# 获取股票日线数据
tushare_daily "000001.SZ" "20240101" "20240310"
```

**权限等级：**
- **免费版：** 基础数据
- **高级版：** 更详细数据（需要积分）
- **学生版：** 免费获取高级数据（需学生认证）

---

### 6. News API - 新闻聚合

**申请步骤：**

1. **访问官网：** https://newsapi.org/register
2. **注册账号：**
   - 填写邮箱
   - 设置密码
3. **验证邮箱：**
   - 检查邮箱中的验证链接
4. **获取 API Key：**
   - 登录后在 Dashboard 可看到
   - 复制 API Key
5. **配置到 OpenClaw：**
   ```bash
   # 编辑配置文件
   nano /root/.openclaw/.env.api-keys

   # 找到这一行：
   NEWS_API_KEY=your_key_here

   # 替换为你的 Key：
   NEWS_API_KEY=abc123def456...

   # 保存并退出
   ```

**用途：** 快速新闻扫描、行业动态

**使用示例：**
```bash
source /root/.openclaw/workspace/scripts/api-functions.sh

# 获取美国科技新闻
news_headlines "us" "technology"

# 搜索 AI 相关新闻
news_search "artificial intelligence"

# 搜索供应链新闻（最近7天）
news_search "supply chain" "$(date -d '7 days ago' +%Y-%m-%d)" "$(date +%Y-%m-%d)"
```

**限制：**
- **免费层：** 100次/天
- **数据来源：** 150,000+ 新闻源

---

### 7. Trading Economics - 经济数据

**申请步骤：**

1. **访问官网：** https://tradingeconomics.com/api/
2. **注册免费账号：**
   - 填写邮箱
   - 设置密码
3. **获取 API Key：**
   - 登录后在 Account 页面
   - 复制 API Key
4. **配置到 OpenClaw：**
   ```bash
   # 编辑配置文件
   nano /root/.openclaw/.env.api-keys

   # 找到这一行：
   TRADING_ECONOMICS_KEY=your_key_here

   # 替换为你的 Key：
   TRADING_ECONOMICS_KEY=abc123def456...

   # 保存并退出
   ```

**用途：** 宏观经济、商品价格

**使用示例：**
```bash
source /root/.openclaw/workspace/scripts/api-functions.sh

# 获取中国经济数据
te_country "china"

# 获取经济日历
te_calendar
```

**限制：**
- **免费层：** 有限请求
- **数据延迟：** 免费层数据可能延迟

---

## 🧪 测试 API 连接

运行测试脚本：
```bash
bash /root/.openclaw/workspace/scripts/test-apis.sh
```

**输出说明：**
- ✅ **OK** - API 已可用
- ⚠️ **Key not configured** - 需要配置 API Key
- ❌ **FAILED** - 连接失败（检查网络或 API 状态）

---

## 🔧 配置 API Keys

**配置文件位置：** `/root/.openclaw/.env.api-keys`

**编辑命令：**
```bash
nano /root/.openclaw/.env.api-keys
```

**文件权限：** 600（仅所有者可读写）

**重要提醒：**
- ⚠️ 永远不要将此文件提交到 Git
- ⚠️ 不要分享你的 API Keys
- ⚠️ 定期轮换密钥（如果需要）

---

## 📝 在监控任务中使用

### 示例1：在监控脚本中调用 GDELT

```bash
#!/bin/bash
# 在你的监控脚本中

# Source API functions
source /root/.openclaw/workspace/scripts/api-functions.sh

# 获取 AI 政策新闻
gdelt_search "AI policy artificial intelligence regulation" 50 > /tmp/gdelt_ai_policy.json

# 处理数据...
```

### 示例2：在监控脚本中调用 Reddit

```bash
#!/bin/bash
# 在你的监控脚本中

# Source API functions
source /root/.openclaw/workspace/scripts/api-functions.sh

# 获取采购心声
reddit_fetch "procurement" 25 > /tmp/reddit_procurement.json

# 解析并生成报告...
```

### 示例3：在监控脚本中调用 GitHub

```bash
#!/bin/bash
# 在你的监控脚本中

# Source API functions
source /root/.openclaw/workspace/scripts/api-functions.sh

# 搜索 LLM 趋势项目
github_search "LLM language model" > /tmp/github_llm.json

# 分析并提取关键信息...
```

---

## 🚀 下一步

1. **测试已集成的 API**
   ```bash
   bash /root/.openclaw/workspace/scripts/test-apis.sh
   ```

2. **选择需要注册的 API**
   - Tushare（强烈推荐，用于 VC 监控）
   - News API（推荐，用于新闻扫描）
   - Trading Economics（可选）

3. **注册并获取 API Keys**
   - 按照上述步骤操作
   - 将 Keys 配置到 `/root/.openclaw/.env.api-keys`

4. **集成到监控任务**
   - 修改现有监控脚本
   - 添加 API 调用
   - 测试并验证

---

**创建时间：** 2026-03-10
**维护者：** Claw1号 🪭
