#!/bin/bash
#
# A1 - Karpathy AI博客精选（含飞书文档上传）
# 示例：如何在现有监控任务中集成飞书文档上传
#

set -e

# ============ 配置区域 ============
WORKSPACE="/root/.openclaw/workspace"
AI_DIGEST_DIR="${WORKSPACE}/ai-daily-digest/ai-daily-digest"
ARCHIVE_DIR="${WORKSPACE}/archive/A1-Karpathy-AI博客精选"

# 飞书配置（你需要手动填写）
FEISHU_FOLDER_TOKEN=""  # 飞书文件夹 token（必填）
FEISHU_SPACE_ID=""       # 飞书知识库 ID（可选）

# OpenAI API 配置
export OPENAI_API_KEY="sk-MaotlYGe8iI54E3JJpECfK0aTk6gTQvt0NQ9aalnZ1GMvglp"
export OPENAI_API_BASE="https://aiberm.com/v1"
export OPENAI_MODEL="gemini-3-flash-preview"

# ============ 执行区域 ============

echo "=========================================="
echo "A1 - Karpathy AI博客精选"
echo "开始时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="
echo

# 1. 进入目录
cd "${AI_DIGEST_DIR}"
echo "✅ 已进入工作目录: ${AI_DIGEST_DIR}"

# 2. 运行脚本生成报告
echo
echo "📊 正在生成报告..."
npx -y bun scripts/digest.ts --hours 48 --top-n 10 --lang zh --output ./output/digest.md

if [[ ! -f "./output/digest.md" ]]; then
    echo "❌ 报告生成失败"
    exit 1
fi

echo "✅ 报告生成成功"

# 3. 保存到服务器（备份）
DATE=$(date +%Y-%m-%d)
mkdir -p "${ARCHIVE_DIR}"
cp ./output/digest.md "${ARCHIVE_DIR}/A1-${DATE}.md"
echo "✅ 报告已保存到服务器: ${ARCHIVE_DIR}/A1-${DATE}.md"

# 4. 上传到飞书文档（新增功能）
echo
echo "📤 准备上传到飞书..."

if [[ -n "$FEISHU_FOLDER_TOKEN" ]]; then
    # 读取报告内容
    REPORT_CONTENT=$(cat ./output/digest.md)

    # 使用 OpenClaw 的 feishu_doc 工具创建文档
    # 注意：这里需要在 OpenClaw 环境中执行
    echo "📝 标题: A1-Karpathy AI博客精选 ${DATE}"
    echo "📂 文件夹: ${FEISHU_FOLDER_TOKEN}"

    # 保存飞书上传任务到临时文件（供后续处理）
    cat > /tmp/feishu_upload_a1.json << EOF
{
  "action": "create",
  "title": "A1-Karpathy AI博客精选 ${DATE}",
  "content": $(echo "$REPORT_CONTENT" | jq -Rs .),
  "folder_token": "${FEISHU_FOLDER_TOKEN}",
  "space_id": "${FEISHU_SPACE_ID}",
  "timestamp": $(date +%s)
}
EOF

    echo "✅ 飞书上传任务已准备: /tmp/feishu_upload_a1.json"

    # TODO: 在 OpenClaw 环境中，你可以直接调用：
    # feishu_doc action=create title="A1-Karpathy AI博客精选 ${DATE}" \
    #   folder_token="${FEISHU_FOLDER_TOKEN}" \
    #   content="${REPORT_CONTENT}"

    echo
    echo "⚠️  提示：飞书文档创建需要在 OpenClaw 环境中完成"
    echo "      你可以在 cron 任务中直接使用 feishu_doc 工具"
else
    echo "⚠️  未配置 FEISHU_FOLDER_TOKEN，跳过飞书上传"
    echo "   请在脚本中填写 FEISHU_FOLDER_TOKEN 变量"
fi

# 5. 智能分批发送（防止飞书截断）
echo
echo "📬 准备发送飞书消息..."

if [[ -f "/root/.openclaw/workspace/ai-daily-digest/split-feishu-message.py" ]]; then
    python3 /root/.openclaw/workspace/ai-daily-digest/split-feishu-message.py \
        "${ARCHIVE_DIR}/A1-${DATE}.md" \
        ou_a7195bd3e0508f0e0d09f19ff12a8811
    echo "✅ 飞书消息已发送"
else
    echo "⚠️  分割脚本不存在，跳过自动发送"
fi

echo
echo "=========================================="
echo "✅ 任务完成"
echo "结束时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="
