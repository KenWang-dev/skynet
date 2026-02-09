# Claude Code Tips.md

## 模型切换

### 可用模型
- **Haiku** - 极速、轻量（简单任务、快速查询）⚡⚡⚡
- **Sonnet 4.5** - 平衡（日常编程、分析）⚡⚡
- **Opus 4.6** - 最强推理（复杂架构、深度思考）⚡

### 切换方法
```bash
# 退出当前会话
exit

# 启动指定模型
claude --model opus

# 验证是否成功
# 启动后检查环境信息显示的 Model ID
```

### 模型 ID
- Haiku: `claude-haiku-4.x`
- Sonnet 4.5: `claude-sonnet-4.5`
- Opus 4.6: `claude-opus-4.6-xxxxxx`

### 使用建议
- 日常对话和简单任务：Haiku 或 Sonnet
- 复杂分析和编程：Sonnet 4.5
- 深度思考和复杂架构：Opus 4.6

---

## /insights 命令

### 功能
分析过往一个月的交互情况，生成可分享的洞察报告

### 使用方法
```bash
/insights
```

### 报告位置
- **Windows**: `file://C:\Users\用户名\.claude\usage-data\report.html`
- 在浏览器中打开可查看详细分析

### 应用价值
1. **识别重复出现的问题** - 发现反复遇到的技术障碍
2. **发现知识盲区** - 识别需要补充的知识点
3. **系统性优化** - 将重复问题整理到 Claude.md/TOOLS.md
4. **避免重复犯错** - 形成经验积累闭环

### 建议使用频率
- **每周一次** - 快速迭代期
- **每月一次** - 稳定运行期

### 使用流程
```
运行 /insights 
    ↓
查看报告（浏览器打开 report.html）
    ↓
识别重复问题 Top 3-5
    ↓
整理到 Claude.md/TOOLS.md
    ↓
下次遇到直接查阅
```

---

*创建时间：2026-02-06*
*最后更新：2026-02-06*
