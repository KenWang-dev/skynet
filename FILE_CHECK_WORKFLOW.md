# 文件安检工作流程

## 🛡️ 为什么需要安检

**问题**：Context Overflow 导致当机
- 对话历史累积 + 大文件读取 = 超过模型 token 限制
- 症状：`Context overflow: prompt too large for the model`
- 后果：会话中断，需要重启

**解决**：文件安检系统 + 智能读取策略

---

## 📋 安检脚本

**位置**：`/root/.openclaw/workspace/file-check.sh`

**功能**：
- 检查文件大小（字节/KB）
- 预估 token 数量
- 风险分级（安全/警告/危险）

**风险阈值**：
- **< 50KB** ✅ 安全，直接读取
- **50-100KB** ⚠️ 警告，确认后读取
- **> 100KB** ⛔ 危险，必须分段或用子会话

---

## 🔧 使用方法

### 1. 读取文件前的标准流程

```bash
# Step 1: 安检
bash /root/.openclaw/workspace/file-check.sh /path/to/file

# Step 2: 根据结果决定
# - 安全 → 直接读取
# - 警告 → 提醒用户，确认后读取
# - 危险 → 使用 offset/limit 或启动子会话
```

### 2. 大文件处理策略

**策略 A：分段读取**
```python
# 使用 offset/limit 参数
read(
  path="/path/to/large/file",
  offset=1,      # 从第 1 行开始
  limit=1000     # 只读 1000 行
)
```

**策略 B：子会话处理**
```python
# 启动独立子会话处理大文件
sessions_spawn(
  task="读取并分析 /path/to/large/file，生成摘要报告",
  cleanup="delete"  # 完成后删除子会话
)
```

**策略 C：搜索定位**
```python
# 只读取包含关键词的部分
# 使用 memory_search 或 grep 定位
```

---

## 📊 实际案例

### 案例 1：MEMORY.md（安全）
```
📄 文件安检报告
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂 文件: /root/.openclaw/workspace/MEMORY.md
📊 大小: 18 KB (18934 字节)
🔢 预估 token: ~6311
✅ 危险级别: 安全
💡 可以直接读取
```
**行动**：直接读取 ✅

### 案例 2：SOUL.md（安全）
```
📄 文件安检报告
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂 文件: /root/.openclaw/workspace/SOUL.md
📊 大小: 1 KB (1673 字节)
🔢 预估 token: ~557
✅ 危险级别: 安全
💡 可以直接读取
```
**行动**：直接读取 ✅

---

## ✅ 检查清单

读取文件前，必须：

- [ ] 运行安检脚本
- [ ] 检查文件大小
- [ ] 评估 token 数量
- [ ] 确认风险级别
- [ ] 选择合适的读取策略

---

**配置日期**：2026-02-21
**状态**：已激活 ✅
**记录位置**：MEMORY.md > 系统限制 > 文件安检系统
