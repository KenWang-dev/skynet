# API 集成快速参考

## ✅ 已完成（立即可用）

### 4个免费 API 已集成并测试通过

| API | 用途 | 测试状态 |
|-----|------|----------|
| **GDELT** | 政策监控、舆情分析 | ✅ 通过 |
| **Reddit** | 采购心声监控 | ✅ 通过 |
| **GitHub** | 技术底座监控 | ✅ 通过 |
| **USGS** | 供应链风险监控 | ✅ 通过 |

---

## 🚀 快速开始

### 测试所有 API
```bash
bash /root/.openclaw/workspace/scripts/test-apis.sh
```

### 运行演示
```bash
bash /root/.openclaw/workspace/scripts/api-demo.sh
```

### 在脚本中使用
```bash
source /root/.openclaw/workspace/scripts/api-functions.sh
gdelt_search "AI policy" 50
reddit_fetch "procurement" 25
github_search "LLM"
usgs_earthquakes 4.5 10
```

---

## 📁 创建的文件

| 文件 | 用途 |
|------|------|
| `.env.api-keys` | API Keys 配置文件 |
| `scripts/api-functions.sh` | API 函数库 |
| `scripts/test-apis.sh` | 测试脚本 |
| `scripts/api-demo.sh` | 演示脚本 |
| `docs/api-integration-guide.md` | 完整指南 |
| `docs/api-integration-report.md` | 完成报告 |
| `api-integration-plan.md` | 集成计划 |

---

## ⚠️ 可选：注册更多 API

需要更强的能力？注册这3个：

### Tushare（强烈推荐）
- **用途：** A股、VC投资监控
- **申请：** https://tushare.pro/register
- **时间：** 5-10 分钟

### News API（推荐）
- **用途：** 新闻聚合
- **申请：** https://newsapi.org/register
- **时间：** 2 分钟

### Trading Economics（可选）
- **用途：** 经济数据
- **申请：** https://tradingeconomics.com/api/
- **时间：** 3 分钟

---

## 📖 文档

- **快速参考：** 本文档
- **完整指南：** `docs/api-integration-guide.md`
- **完成报告：** `docs/api-integration-report.md`
- **集成计划：** `api-integration-plan.md`

---

**完成时间：** 2026-03-10
**状态：** ✅ 4个 API 已可用，3个待注册
