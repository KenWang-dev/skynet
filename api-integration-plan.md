# API 集成计划

## 目标
为 OpenClaw 集成 7 个免费 API，扩展监控和数据获取能力

---

## 第一批：无需注册（立即可用）

### 1. GDELT - 全球事件数据库
- **用途**：政策推手监控、全球舆情分析
- **状态**：⏳ 待集成
- **文档**：https://www.gdeltproject.org/data.html

### 2. Reddit - 社交媒体（公开数据）
- **用途**：全球采购从业者心声监控
- **状态**：⏳ 待集成
- **文档**：https://www.reddit.com/dev/api/

### 3. GitHub - 代码与开发（公开数据）
- **用途**：AI 技术底座监控、开源项目追踪
- **状态**：⏳ 待集成
- **文档**：https://docs.github.com/en/rest

### 4. USGS - 美国地质调查局
- **用途**：原材料监控、矿产数据
- **状态**：⏳ 待集成
- **文档**：https://www.usgs.gov/products/web-tools/apis

---

## 第二批：需要注册（等待 API Key）

### 5. Tushare - A股数据
- **用途**：红杉中国、IDG 等投资动态监控
- **状态**：⏸️ 等待用户注册
- **申请入口**：https://tushare.pro/register
- **所需信息**：API Token

### 6. News API - 新闻聚合
- **用途**：快速新闻扫描、行业动态
- **状态**：⏸️ 等待用户注册
- **申请入口**：https://newsapi.org/register
- **所需信息**：API Key

### 7. Trading Economics - 经济数据
- **用途**：宏观经济、商品价格
- **状态**：⏸️ 等待用户注册
- **申请入口**：https://tradingeconomics.com/api/
- **所需信息**：API Key

---

## 配置文件

### API 凭证存储
- **路径**：`/root/.openclaw/.env.api-keys`
- **权限**：600（仅所有者可读写）
- **格式**：`KEY_NAME=api_key_value`

### 示例
```bash
# API Keys for Third-Party Services
TUSHARE_API_TOKEN=your_token_here
NEWS_API_KEY=your_key_here
TRADING_ECONOMICS_KEY=your_key_here
```

---

## 集成脚本

### 通用函数库
- **路径**：`/root/.openclaw/workspace/scripts/api-functions.sh`
- **功能**：统一的 API 调用函数

### 各 API 集成脚本
- `gdlet-fetch.sh` - GDELT 数据获取
- `reddit-fetch.sh` - Reddit 数据获取
- `github-fetch.sh` - GitHub 数据获取
- `usgs-fetch.sh` - USGS 数据获取

---

## 优先级

### 高优先级（立即集成）
1. **GDELT** → 政策推手监控（补充 Delta1）
2. **Reddit** → 采购心声监控（补充 Theta1）
3. **GitHub** → 技术底座监控（补充 Alpha1）

### 中优先级（等待凭证）
4. **Tushare** → VC 投资监控（补充 Gamma1）
5. **News API** → 快速新闻扫描

### 低优先级（可选）
6. **Trading Economics** → 经济数据
7. **USGS** → 原材料数据

---

## 进度追踪

- [x] API 调研完成
- [x] 权威性验证
- [ ] 第一批 API 集成（无需注册）
- [ ] 第二批 API 集成（等待凭证）
- [ ] 测试所有 API 连接
- [ ] 编写使用文档

---

**创建时间**：2026-03-10
**负责人**：Claw1号 🪭
