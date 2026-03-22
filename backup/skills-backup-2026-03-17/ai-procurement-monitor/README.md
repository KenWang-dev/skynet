# AI采购最佳实践监控 - 快速开始

## ✅ 已完成配置

### 1. Skill文件结构
```
/root/.openclaw/workspace/skills/ai-procurement-monitor/
├── SKILL.md              # 技能说明文档（7维×3指标框架）
├── run.sh                # 数据收集脚本（Tavily Deep搜索）
├── cron-setup.json       # Cron配置参考
└── README.md            # 本文件
```

### 2. Cron定时任务
- **任务名称**: AI采购最佳实践周报
- **执行时间**: 每周五 14:00 (Asia/Shanghai)
- **Job ID**: 37c6d64d-a7ba-4fc6-b398-8e6f2ba95020
- **状态**: ✅ 已启用

### 3. 下次执行
根据当前时间计算，下一个周五14:00会自动执行。

## 🧪 手动测试

### 测试数据收集
```bash
bash /root/.openclaw/workspace/skills/ai-procurement-monitor/run.sh
```

输出将保存在 `/tmp/ai-procurement-monitor/` 目录。

### 查看搜索结果
```bash
# 查看最新生成的文件
ls -lh /tmp/ai-procurement-monitor/*_*.txt

# 查看某个维度的搜索结果
cat /tmp/ai-procurement-monitor/dim1_global_*.txt
```

## 📊 监控框架

### 7个监控维度

| 维度 | 监控内容 | 搜索关键词示例 |
|-----|---------|--------------|
| **维度一** | 全球AI采购全景扫描 | market size, Gartner McKinsey, adoption rate |
| **维度二** | 三类标杆企业实践 | HP Dell Siemens, SAP Ariba Oracle, case study |
| **维度三** | AI能力成熟度分级 | automation, Copilot, agent, autonomous |
| **维度四** | 价值量化与ROI | ROI, cost savings, efficiency, benchmark |
| **维度五** | 风险管控与合规 | data security, compliance, GDPR, privacy |
| **维度六** | 组织与人才转型 | training, transformation, change management |
| **维度七** | 经验教训与避坑 | failure, lessons learned, challenges |

### 数据源
- **默认**: Tavily Deep 模式
- **搜索范围**: 过去7天
- **每个维度**: 最多10条结果

## 📝 报告格式

自动生成的周报将包含：

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🤖 AI采购最佳实践 - 周报
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📅 2026年第X周 | 2026-03-XX

【Top 5 核心发现】
1. ...
2. ...
...

【维度一】全球AI采购全景扫描
🔍 搜索关键词：...
✓ 核心发现
✓ 趋势分析
✓ 对标启示

...（其他6个维度）

📊 本周关键洞察
• 核心发现1
• 核心发现2

⚠️ 风险预警
• 风险点1

💡 行动建议
• 建议1
• 建议2

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 🛠️ 管理 Cron 任务

### 查看所有任务
在 OpenClaw 中发送：
```
使用 cron 工具的 list 动作
```

### 查看执行历史
```bash
# 查看特定任务的运行历史
cron action=runs jobId=37c6d64d-a7ba-4fc6-b398-8e6f2ba95020
```

### 临时禁用/启用
```bash
# 禁用任务
cron action=update jobId=37c6d64d-a7ba-4fc6-b398-8e6f2ba95020 patch='{"enabled":false}'

# 启用任务
cron action=update jobId=37c6d64d-a7ba-4fc6-b398-8e6f2ba95020 patch='{"enabled":true}'
```

### 删除任务
```bash
cron action=remove jobId=37c6d64d-a7ba-4fc6-b398-8e6f2ba95020
```

## 📤 自动发送

报告将自动通过飞书发送给：
- **接收人**: Ken (ou_a7195bd3e0508f0e0d09f19ff12a8811)
- **发送时间**: 每周五 14:00左右
- **发送方式**: 独立会话执行（不影响主会话）

## 🔄 更新 Skill

如需修改监控内容，直接编辑以下文件：
- **SKILL.md**: 修改监控框架和维度说明
- **run.sh**: 修改搜索关键词或参数

修改后无需重新设置 cron，下次执行会自动使用最新版本。

## 📚 相关文档

- **原始框架**: `/root/.openclaw/media/inbound/ai_procurement_framework.docx---*`
- **Tavily搜索**: `/root/.openclaw/workspace/skills/tavily-search/SKILL.md`
- **参考监控**: `/root/.openclaw/workspace/skills/ai-giants-monitor/SKILL.md`

---

**创建时间**: 2026-03-04
**版本**: v1.0
**状态**: ✅ 已配置并启用
