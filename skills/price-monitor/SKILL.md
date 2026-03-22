---
name: price-monitor
description: "元器件价格监控 Skill。维护一个 MPN 监控清单（最多 10 个），支持添加/删除/查询价格。当用户提到元器件价格、MPN、料号监控、价格查询时使用此技能。"
metadata:
  {
    "version": "1.0.0",
    "clawdbot": { "emoji": "💰" }
  }
---

# Price Monitor - 元器件价格监控

## 🎯 功能

- ✅ 维护一个 MPN 监控清单（最多 10 个）
- ✅ 添加/删除/查看清单
- ✅ 即时查询价格（Mouser API）
- ✅ 定时监控（每 4 小时）

---

## 📋 监控清单

**存储位置**：`/root/.openclaw/workspace/skills/price-monitor/data/watchlist.json`

**格式**：
```json
{
  "items": [
    {
      "mpn": "STM32F103C8T6",
      "description": "STM32 32位微控制器",
      "added_at": "2026-03-16T21:00:00Z",
      "enabled": true
    }
  ],
  "max_items": 10
}
```

---

## 🛠️ 操作指令

### 添加 MPN

用户说：`添加 MPN STM32F103C8T6` 或 `监控 STM32F103C8T6`

**操作**：
1. 读取 watchlist.json
2. 检查是否已满（10 个）
3. 如果已满，问用户要删除哪个
4. 添加新 MPN 到清单
5. 保存 watchlist.json
6. 立即查询一次价格

### 删除 MPN

用户说：`删除 MPN STM32F103C8T6` 或 `取消监控 STM32F103C8T6`

**操作**：
1. 读取 watchlist.json
2. 删除指定 MPN
3. 保存 watchlist.json
4. 确认删除

### 查看清单

用户说：`查看监控清单` 或 `监控列表`

**操作**：
1. 读取 watchlist.json
2. 显示所有 MPN 及其当前价格

### 查询价格

用户说：`查询价格` 或 `查价 STM32F103C8T6`

**操作**：
1. 读取 watchlist.json
2. 调用 Mouser API 批量查询
3. 显示价格和库存

---

## 🔄 批量处理逻辑

**添加 MPN 时**：
```javascript
if (watchlist.items.length >= 10) {
  // 问用户要删除哪个
  return "监控清单已满（10/10），请选择要删除的 MPN：\n" + 
    watchlist.items.map((item, i) => `${i+1}. ${item.mpn}`).join('\n');
}
```

**批量查询**：
- 一次可查询多个料号（用 `|` 分隔）
- Mouser API 限制：每个 Key 每天 1000 次请求
- 监控清单限制 10 个，一次可全部查完

---

## 📁 文件结构

```
/root/.openclaw/workspace/skills/price-monitor/
├── SKILL.md                 # 本文件
├── data/
│   └── watchlist.json       # 监控清单
└── scripts/
    ├── query-price.js       # 查询价格
    └── manage-list.js       # 管理清单
```

---

## 🔧 依赖

- **Mouser API Key**：`4fe47ba4-9c76-4e20-9443-08e82f79ad33`
- **Node.js**：v22.22.0
- **现有脚本**：`/root/.openclaw/workspace/purclaw/scripts/fetch-mouser-api.js`

---

## 🚀 快速开始

1. **初始化清单**：`node scripts/manage-list.js init`
2. **添加 MPN**：`node scripts/manage-list.js add STM32F103C8T6`
3. **查询价格**：`node scripts/query-price.js`

---

## 📊 价格数据

**数据源**：Mouser 官方 API

**显示信息**：
- 料号（MPN）
- 批量价格（最高阶梯）
- 含税价格（13%）
- 库存数量
- 交期

**历史记录**：`/root/.openclaw/workspace/purclaw/data/history/`

---

## ⏰ 定时监控

**Cron 任务**：每 4 小时自动运行

**触发方式**：`bash /root/.openclaw/workspace/purclaw/run-monitor.sh`

**监控范围**：从 watchlist.json 读取 MPN 清单

---

## 💡 使用示例

**用户**：添加 MPN STM32F103C8T6
**AI**：
1. 检查清单（当前 3/10）
2. 添加成功
3. 立即查询价格：
   ```
   ✅ STM32F103C8T6 已添加到监控清单
   
   📊 价格查询：
   - 批量价格：¥24.38（1500+片）
   - 含税价格：¥27.55
   - 库存：8300
   ```

**用户**：监控清单已满，要删除哪个？
**AI**：
```
当前监控清单（10/10）：
1. STM32F103C8T6
2. ESP32-S3-WROOM-1
3. CH340G
...
10. LM7805

请回复要删除的序号。
```

---

**版本**：v1.0.0
**创建时间**：2026-03-16
**创建者**：Claw1号