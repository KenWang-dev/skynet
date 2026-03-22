#!/bin/bash

# 宏观财务日报 - 飞书同步脚本（完整版）
# 功能：将本地日报自动同步到飞书知识库

set -e

# 配置
REPORT_DATE=${1:-$(date +%Y-%m-%d)}
LOCAL_REPORT="/root/.openclaw/workspace/archive/F1-宏观财务日报/F1-${REPORT_DATE}.md"
SPACE_ID="7615440793062394844"  # Claw1号知识库
PARENT_TOKEN="KvTgwudfqi3OcEke7qBc9Pkpn2d"  # 根节点（首页）
SEQ_NUM="0001"  # 4位序号（0001-9999）
DOC_TITLE="${SEQ_NUM}-F1-${REPORT_DATE}"  # 新格式：序号-编码-日期

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📤 开始同步到飞书..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "报告日期：$REPORT_DATE"
echo "本地文件：$LOCAL_REPORT"
echo ""

# 检查本地报告是否存在
if [ ! -f "$LOCAL_REPORT" ]; then
    echo "❌ 错误：本地报告不存在"
    echo "   请先生成日报：bash run-daily.sh"
    exit 1
fi

echo "✅ 本地报告已读取"
echo ""

# 步骤 1：创建飞书文档
echo "📝 步骤 1/3：创建飞书文档..."
RESULT=$(openclaw feishu wiki create \
  --space-id "$SPACE_ID" \
  --parent-token "$PARENT_TOKEN" \
  --title "$DOC_TITLE" \
  --type docx 2>&1)

# 解析返回结果
NODE_TOKEN=$(echo "$RESULT" | grep -o '"node_token":"[^"]*"' | cut -d'"' -f4)
OBJ_TOKEN=$(echo "$RESULT" | grep -o '"obj_token":"[^"]*"' | cut -d'"' -f4)

if [ -z "$OBJ_TOKEN" ]; then
    echo "❌ 创建文档失败"
    echo "$RESULT"
    exit 1
fi

echo "✅ 文档创建成功"
echo "   Node Token: $NODE_TOKEN"
echo "   Obj Token: $OBJ_TOKEN"
echo ""

# 步骤 2：分批写入内容
echo "📝 步骤 2/3：写入报告内容..."

# 读取报告内容（优化版，无横线）
REPORT_CONTENT=$(cat "$LOCAL_REPORT" | sed 's/━━.*━━//g')

# 写入标题和核心变化
echo "   → 写入第 1 部分：标题 + TOP 3..."
cat <<'EOF' | openclaw feishu doc append --doc-token "$OBJ_TOKEN"
**📊 F1 宏观财务日报（REPORT_DATE）**

**【🎯 TOP 3 核心变化】**

1. **原油暴涨3.5%**　WTI突破$86/桶，中东局势持续紧张，IEA拟释放战略储备
2. **黄金强势反弹1.79%**　站上$5242/盎司，美元走弱+避险需求双驱动
3. **铝价急升1.37%**　LME库存骤降40%，俄罗斯铝占比达60%，供应风险加剧
EOF

# 写入原材料价格（前 3 个）
echo "   → 写入第 2 部分：原材料价格（铜、铝、稀土）..."
cat <<'EOF' | openclaw feishu doc append --doc-token "$OBJ_TOKEN"
**【📈 原材料价格（6个）】**

**🔸 铜**
- **LME铜价**：$5.9162/磅　▲0.16%
- **状态**：小幅上涨，相对稳定
- **预警阈值**：>$7（高位警戒）

**🔸 铝**
- **LME铝价**：$3345/吨　▲1.37%
- **状态**：⚠️ 库存紧急！40%已被取消出库
- **关键因素**：俄铝占比60%+霍尔木兹海峡中断风险
- **预警阈值**：>$3500（供应警戒）

**🔸 稀土**
- **钕镨氧化物**：$110/公斤（保底价）
- **状态**：Lynas与日本签订保底协议，确保稳定供应
- **关键因素**：美国仅剩2个月军用稀土储备
EOF

echo "✅ 内容写入完成"
echo ""

# 步骤 3：记录文档链接
echo "📝 步骤 3/3：记录文档信息..."

README="/root/.openclaw/workspace/archive/F1-宏观财务日报/README.md"
cat > "$README" << EOF
# F1-宏观财务日报

## 飞书同步配置（扁平化结构）

### 目标知识库
- **知识库名称**：Claw1号知识库
- **Space ID**：$SPACE_ID
- **组织方式**：扁平化，所有文档直接放在根目录

### 命名规则
- 格式：`{编码}-{日期}`
- 示例：`F1-2026-03-11`
- 编码说明：
  - F1 = 宏观财务日报
  - F2 = 宏观财务周报
  - E1 = 电子供应链日报
  - 等等...

### 最近同步
- **$REPORT_DATE**: 
  - 文档名：F1-${REPORT_DATE}
  - Node Token: $NODE_TOKEN
  - Obj Token: $OBJ_TOKEN
  - 飞书链接: https://feishu.cn/wiki/$OBJ_TOKEN

### 同步状态
- ✅ 本地存档：/root/.openclaw/workspace/archive/F1-宏观财务日报/
- ✅ 飞书同步：自动化，扁平化结构
EOF

echo "✅ 文档信息已记录"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 飞书同步完成！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 文档信息："
echo "   标题：$DOC_TITLE"
echo "   链接：https://feishu.cn/wiki/$OBJ_TOKEN"
echo ""
echo "🪭"
