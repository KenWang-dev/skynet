#!/bin/bash
#
# A1 - Karpathy AI博客精选（完整版）
# 包含：生成报告 + 服务器备份 + 飞书上传 + 消息通知
#
# 存储策略：
# - 服务器：保留最近30天
# - 飞书：永久保存完整历史
#

set -e

# ============ 加载函数库 ============
source /root/.openclaw/workspace/scripts/feishu-uploader.sh

# ============ 配置区域 ============
WORKSPACE="/root/.openclaw/workspace"
AI_DIGEST_DIR="${WORKSPACE}/ai-daily-digest/ai-daily-digest"
ARCHIVE_DIR="${WORKSPACE}/archive/A1-Karpathy-AI博客精选"
RETENTION_DAYS=30

# OpenAI API 配置
export OPENAI_API_KEY="sk-MaotlYGe8iI54E3JJpECfK0aTk6gTQvt0NQ9aalnZ1GMvglp"
export OPENAI_API_BASE="https://aiberm.com/v1"
export OPENAI_MODEL="gemini-3-flash-preview"

# 飞书配置（请填写你的 folder token）
export FEISHU_FOLDER_ALPHA=""  # ← 请填写 Alpha 系列的文件夹 token

# 飞书接收人
FEISHU_TARGET="ou_a7195bd3e0508f0e0d09f19ff12a8811"

# ============ 辅助函数 ============
log_info() {
    echo -e "\033[0;34m[INFO]\033[0m $1"
}

log_success() {
    echo -e "\033[0;32m[SUCCESS]\033[0m $1"
}

log_error() {
    echo -e "\033[0;31m[ERROR]\033[0m $1"
}

# ============ 执行流程 ============
main() {
    echo "=========================================="
    echo "A1 - Karpathy AI博客精选"
    echo "开始时间: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "=========================================="
    echo

    # 步骤 1: 生成报告
    log_info "步骤 1/5: 生成报告"
    cd "${AI_DIGEST_DIR}"

    npx -y bun scripts/digest.ts \
        --hours 48 \
        --top-n 10 \
        --lang zh \
        --output ./output/digest.md

    if [[ ! -f "./output/digest.md" ]]; then
        log_error "报告生成失败"
        exit 1
    fi

    log_success "报告生成成功"
    echo

    # 步骤 2: 保存到服务器（备份，保留30天）
    log_info "步骤 2/5: 保存到服务器（保留30天）"
    DATE=$(date +%Y-%m-%d)
    mkdir -p "${ARCHIVE_DIR}"

    REPORT_FILE="${ARCHIVE_DIR}/A1-${DATE}.md"
    cp ./output/digest.md "${REPORT_FILE}"

    log_success "已保存: ${REPORT_FILE}"
    echo

    # 步骤 3: 上传到飞书（永久保存）
    log_info "步骤 3/5: 上传到飞书（永久保存）"

    if [[ -n "$FEISHU_FOLDER_ALPHA" ]]; then
        # 方法 1: 使用函数库（推荐）
        upload_to_feishu "A1" "A1-Karpathy AI博客精选" "${REPORT_FILE}"

        # TODO: 方法 2: 直接在 OpenClaw 环境中调用 feishu_doc
        # 如果在 cron 任务中，可以直接使用：
        #
        # feishu_doc action=create \
        #   title="A1-Karpathy AI博客精选 ${DATE}" \
        #   folder_token="$FEISHU_FOLDER_ALPHA" \
        # content="$(cat "${REPORT_FILE}")"
        #
        # 这样会直接创建飞书文档并返回文档链接

        echo
        log_success "飞书上传任务已准备"
    else
        log_error "未配置 FEISHU_FOLDER_ALPHA 环境变量"
        echo "   请在脚本中填写飞书文件夹 token"
        echo "   export FEISHU_FOLDER_ALPHA=\"your_folder_token\""
    fi
    echo

    # 步骤 4: 清理旧文件（超过30天）
    log_info "步骤 4/5: 清理服务器旧文件（超过${RETENTION_DAYS}天）"

    # 删除超过30天的文件
    find "${ARCHIVE_DIR}" -name "A1-*.md" -type f -mtime +${RETENTION_DAYS} -delete

    # 统计剩余文件
    remaining_count=$(find "${ARCHIVE_DIR}" -name "A1-*.md" -type f | wc -l)
    log_success "清理完成，剩余 ${remaining_count} 个文件（最近${RETENTION_DAYS}天）"
    echo

    # 步骤 5: 发送飞书通知
    log_info "步骤 5/5: 发送飞书通知"

    # 智能分批发送（防止截断）
    if [[ -f "${WORKSPACE}/ai-daily-digest/split-feishu-message.py" ]]; then
        python3 "${WORKSPACE}/ai-daily-digest/split-feishu-message.py" \
            "${REPORT_FILE}" \
            "${FEISHU_TARGET}"
        log_success "飞书消息已发送"
    else
        log_error "分割脚本不存在"
    fi
    echo

    # 完成
    echo "=========================================="
    log_success "✅ 任务完成"
    echo "结束时间: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "=========================================="
    echo
    echo "📊 存储位置:"
    echo "   • 服务器: ${REPORT_FILE}（保留${RETENTION_DAYS}天）"
    echo "   • 飞书: 完整历史已保存"
    echo
}

# 执行主函数
main "$@"
