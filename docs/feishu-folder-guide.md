# 飞书知识库配置快速指南

## 📋 你的知识库信息

**知识库链接：** https://procurement-leap.feishu.cn/wiki/KvTgwudfqi3OcEke7qBc9Pkpn2d
**Space ID：** KvTgwudfqi3OcEke7qBc9Pkpn2d

---

## 🚀 配置步骤（5分钟）

### 第 1 步：创建文件夹结构

1. 打开你的知识库：https://procurement-leap.feishu.cn/wiki/KvTgwudfqi3OcEke7qBc9Pkpn2d

2. 点击"新建页面" → 选择"文件夹"

3. 创建以下 8 个文件夹：

   ```
   📁 Alpha系列 - AI技术前沿
   📁 Beta系列 - AI巨头动态
   📁 Gamma系列 - 资本风向
   📁 Delta系列 - 政策推手
   📁 供应链监控
   📁 宏观财务
   📁 行业与政策
   📁 其他监控
   ```

### 第 2 步：获取 Folder Token

1. 打开第一个文件夹（Alpha系列 - AI技术前沿）
2. 点击右上角 "..." → "复制链接"
3. 从链接中提取 token

**示例链接：**
```
https://procurement-leap.feishu.cn/wiki/KvTgwudfqi3OcEke7qBc9Pkpn2d?folder=boxxxxxxAbCdEf123456
                                                              ^^^^^^^^^^^^^^^^^^^^
                                                         folder token（复制这个）
```

### 第 3 步：填写配置文件

编辑文件：`/root/.openclaw/workspace/scripts/feishu-config.sh`

```bash
export FEISHU_FOLDER_ALPHA="boxxxxxxAbCdEf123456"  # ← 粘贴你的 token
export FEISHU_FOLDER_BETA="boxxxxxxAbCdEf123456"
export FEISHU_FOLDER_GAMMA="boxxxxxxAbCdEf123456"
# ... 填写所有 8 个文件夹的 token
```

### 第 4 步：添加应用权限

1. 访问飞书开放平台：https://open.feishu.cn/app
2. 找到 OpenClaw 应用
3. 添加以下权限：
   - `wiki:wiki:readonly`
   - `wiki:wiki:write`
   - `docx:document`
   - `drive:drive:readonly`
4. 发布应用

### 第 5 步：添加机器人到知识库

1. 打开知识库设置
2. 成员管理 → 添加应用
3. 选择 OpenClaw 应用
4. 授予"可编辑"权限

---

## ✅ 完成后

告诉我："配置完成"，我会：
1. 测试连接
2. 创建第一个飞书文档
3. 验证整个系统

---

## 📊 文件夹与任务映射

| 文件夹 | Token 变量 | 存放任务 |
|--------|-----------|----------|
| Alpha系列 - AI技术前沿 | FEISHU_FOLDER_ALPHA | A1-Karpathy AI博客精选 |
| Beta系列 - AI巨头动态 | FEISHU_FOLDER_BETA | B1-AI三巨头监控 |
| Gamma系列 - 资本风向 | FEISHU_FOLDER_GAMMA | Gamma1/2-资本风向监控 |
| Delta系列 - 政策推手 | FEISHU_FOLDER_DELTA | Delta1/2-政策推手监控 |
| 供应链监控 | FEISHU_FOLDER_SUPPLY | C1/C2, D1/D2, E1/E2 |
| 宏观财务 | FEISHU_FOLDER_MACRO | F1/F2-宏观财务监控 |
| 行业与政策 | FEISHU_FOLDER_POLICY | E1/E2/E3, G2 |
| 其他监控 | FEISHU_FOLDER_OTHER | H2, I2, J2, K2 |

---

## 💡 提示

- 所有文件夹 token 格式都是 `box` 开头
- Token 通常有 20-30 个字符
- 可以通过链接快速验证 token 是否正确

---

**创建时间：** 2026-03-10
**知识库：** 监控报告中心
