# 飞书文档存储系统 - 完整指南

## 📋 概述

**存储策略：30天滚动窗口 + 飞书归档**

```
服务器（最近30天）  ←  双重备份  →  飞书（完整历史）
     ↓                              ↓
  快速访问                        永久保存
  脚本友好                        移动友好
  自动清理                        强大搜索
```

---

## 🚀 快速开始

### 第 1 步：在飞书中创建知识库

1. 打开飞书 → 知识库 → 新建知识库
2. 命名为：`监控报告中心`
3. 创建以下文件夹结构：

```
📁 监控报告中心
│
├─ 📁 Alpha系列 - AI技术前沿
│   └─ 存放：A1-Karpathy AI博客精选、Alpha2...
│
├─ 📁 Beta系列 - AI巨头动态
│   └─ 存放：B1-AI三巨头监控、Beta2...
│
├─ 📁 Gamma系列 - 资本风向
│   └─ 存放：Gamma1/2（日报/周报）
│
├─ 📁 Delta系列 - 政策推手
│   └─ 存放：Delta1/2（日报/周报）
│
├─ 📁 供应链监控
│   └─ 存放：C1/C2、D1/D2、E1/E2/E3
│
├─ 📁 宏观财务
│   └─ 存放：F1/F2（日报/周报）
│
├─ 📁 行业与政策
│   └─ 存放：E1/E2/E3、G2
│
└─ 📁 其他监控
    └─ 存放：H2、I2、J2、K2...
```

### 第 2 步：获取 Folder Token

1. 打开任意文件夹
2. 点击右上角 "..." → "复制链接"
3. 从链接中提取 `folder_token`

**示例链接：**
```
https://xxx.feishu.cn/wiki/wiki/xxxxxx?folder=boxxxxxx
                                              ^^^^^^^
                                          folder token
```

### 第 3 步：填写配置文件

编辑 `/root/.openclaw/workspace/scripts/feishu-config.sh`：

```bash
export FEISHU_FOLDER_ALPHA="boxxxxxx"  # ← 填写实际 token
export FEISHU_FOLDER_BETA="boxxxxxx"
export FEISHU_FOLDER_GAMMA="boxxxxxx"
# ... 填写所有文件夹 token
```

### 第 4 步：测试第一个任务

```bash
# 运行 A1 任务测试
/root/.openclaw/workspace/scripts/a1-karpathy-complete.sh
```

---

## 📂 文件结构

```
/root/.openclaw/workspace/
├─ scripts/
│  ├─ feishu-config.sh          # 飞书配置文件（需要填写）
│  ├─ feishu-uploader.sh         # 飞书上传函数库
│  ├─ a1-karpathy-complete.sh    # A1 完整示例脚本
│  └─ cleanup-old-reports.sh     # 清理旧报告脚本
│
└─ archive/
   └─ A1-Karpathy-AI博客精选/
      ├─ A1-2026-03-10.md  # 最近30天
      ├─ A1-2026-03-09.md
      └─ ...
```

---

## 🔧 修改现有监控任务

### 方法 1：使用函数库（推荐）

在你的监控脚本中添加：

```bash
#!/bin/bash

# 加载函数库
source /root/.openclaw/workspace/scripts/feishu-uploader.sh

# 加载配置
source /root/.openclaw/workspace/scripts/feishu-config.sh

# 生成报告
# ... 你的报告生成逻辑 ...

# 保存到服务器
REPORT_FILE="/root/.openclaw/workspace/archive/XXX/report-$(date +%Y-%m-%d).md"
mkdir -p "$(dirname "$REPORT_FILE")"
echo "$REPORT_CONTENT" > "$REPORT_FILE"

# 上传到飞书
upload_to_feishu "A1" "报告标题" "$REPORT_FILE"

# 清理旧文件（超过30天）
find "$(dirname "$REPORT_FILE")" -name "*.md" -mtime +30 -delete
```

### 方法 2：直接使用 feishu_doc 工具

在 cron 任务中：

```bash
# 创建飞书文档
feishu_doc action=create \
  title="A1-Karpathy AI博客精选 $(date +%Y-%m-%d)" \
  folder_token="$FEISHU_FOLDER_ALPHA" \
  content="$(cat "$REPORT_FILE")"
```

---

## 🗑️ 自动清理旧文件

### 手动清理

```bash
# 清理所有超过30天的报告
/root/.openclaw/workspace/scripts/cleanup-old-reports.sh
```

### 定时清理（添加到 cron）

```bash
# 每周日凌晨 3:00 清理
cron add schedule='0 3 * * 0' sessionTarget=main payload='{
  "kind": "systemEvent",
  "text": "⏰ 清理旧报告\n\n运行脚本：bash /root/.openclaw/workspace/scripts/cleanup-old-reports.sh"
}'
```

---

## 📊 监控任务映射表

| 代码 | 系列 | 文件夹 | 任务名称 |
|------|------|--------|----------|
| A1 | Alpha | FEISHU_FOLDER_ALPHA | Karpathy AI博客精选 |
| B1 | Beta | FEISHU_FOLDER_BETA | AI三巨头监控 |
| C1/C2 | 供应链 | FEISHU_FOLDER_SUPPLY | 电子供应链日报/周报 |
| D1/D2 | 供应链 | FEISHU_FOLDER_SUPPLY | 供应链风险日报/周报 |
| F1/F2 | 宏观 | FEISHU_FOLDER_MACRO | 宏观财务日报/周报 |
| Gamma1/2 | Gamma | FEISHU_FOLDER_GAMMA | 资本风向日报/周报 |
| Delta1/2 | Delta | FEISHU_FOLDER_DELTA | 政策推手日报/周报 |

---

## ✅ 验证清单

迁移完成后，检查以下内容：

- [ ] 飞书知识库已创建
- [ ] 所有文件夹已创建
- [ ] feishu-config.sh 已填写所有 folder token
- [ ] 测试任务成功运行
- [ ] 飞书文档成功创建
- [ ] 服务器文件正常保存
- [ ] 旧文件自动清理

---

## 🎯 下一步行动

1. **今天**：创建飞书知识库和文件夹
2. **今天**：获取 folder token 并填写配置
3. **今天**：测试 A1 任务
4. **明天**：批量迁移所有日报任务
5. **本周**：完成所有周报任务

---

## 📞 帮助

如果遇到问题：

1. **检查配置**：确认 feishu-config.sh 已正确填写
2. **检查权限**：确认飞书机器人有访问知识库的权限
3. **查看日志**：`/var/log/cleanup-reports.log`
4. **手动测试**：单独运行脚本查看错误信息

---

**创建时间**：2026-03-10
**维护者**：Claw1号
