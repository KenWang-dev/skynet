#!/bin/bash
#
# A1 - Karpathy AI博客精选（含飞书上传）
# 每天凌晨 07:00 执行
#

set -e

# ============ 加载配置 ============
source /root/.openclaw/workspace/scripts/feishu-config.sh

# ============ 配置 ============
WORKSPACE="/root/.openclaw/workspace"
AI_DIGEST_DIR="${WORKSPACE}/ai-daily-digest/ai-daily-digest"
ARCHIVE_DIR="${WORKSPACE}/archive/A1-Karpathy-AI博客精选"
RETENTION_DAYS=30

# OpenAI API 配置
export OPENAI_API_KEY="sk-MaotlYGe8iI54E3JJpECfK0aTk6gTQvt0NQ9aalnZ1GMvglp"
export OPENAI_API_BASE="https://aiberm.com/v1"
export OPENAI_MODEL="gemini-3-flash-preview"

# 飞书配置
FEISHU_TARGET="ou_a7195bd3e0508f0e0d09f19ff12a8811"

# ============ 日志函数 ============
log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $1"
}

log_success() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $1"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1"
}

# ============ 执行流程 ============
main() {
    log_info "A1 - Karpathy AI博客精选 开始执行"

    # 步骤 1: 生成报告（6步流程）
    log_info "步骤 1/6: 生成报告"
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

    # 步骤 2: 保存到服务器（备份，保留30天）
    log_info "步骤 2/6: 保存到服务器（保留30天）"
    DATE=$(date +%Y-%m-%d)
    mkdir -p "${ARCHIVE_DIR}"

    REPORT_FILE="${ARCHIVE_DIR}/A1-${DATE}.md"
    cp ./output/digest.md "${REPORT_FILE}"

    log_success "已保存: ${REPORT_FILE}"

    # 步骤 3: 上传到飞书（永久保存）
    log_info "步骤 3/6: 上传到飞书（永久保存）"

    if [[ -n "$FEISHU_FOLDER_ALPHA" ]]; then
        # 读取报告内容
        REPORT_CONTENT=$(cat "${REPORT_FILE}")

        # 创建飞书文档
        DOC_TITLE="A1-Karpathy AI博客精选 ${DATE}"

        # 使用 feishu_doc 工具创建文档
        # 注意：这会在知识库的根目录创建，不是在文件夹中
        # 飞书 API 目前不支持直接在文件夹中创建文档
        # 我们需要在文档创建后，手动或通过脚本移动到文件夹

        log_info "准备创建飞书文档: ${DOC_TITLE}"

        # 保存到临时文件供后续处理
        echo "${REPORT_CONTENT}" > "/tmp/a1_report_${DATE}.md"

        log_success "飞书上传任务已准备"
        log_info "   标题: ${DOC_TITLE}"
        log_info "   服务器文件: ${REPORT_FILE}"
    else
        log_error "未配置 FEISHU_FOLDER_ALPHA"
    fi

    # 步骤 4: 清理旧文件（超过30天）
    log_info "步骤 4/6: 清理服务器旧文件（超过${RETENTION_DAYS}天）"

    # 删除超过30天的文件
    find "${ARCHIVE_DIR}" -name "A1-*.md" -type f -mtime +${RETENTION_DAYS} -delete

    # 统计剩余文件
    remaining_count=$(find "${ARCHIVE_DIR}" -name "A1-*.md" -type f | wc -l)
    log_success "清理完成，剩余 ${remaining_count} 个文件（最近${RETENTION_DAYS}天）"

    # 步骤 5: 发送飞书通知
    log_info "步骤 5/6: 发送飞书通知"

    # 智能分批发送（防止截断）
    if [[ -f "${WORKSPACE}/ai-daily-digest/split-feishu-message.py" ]]; then
        python3 "${WORKSPACE}/ai-daily-digest/split-feishu-message.py" \
            "${REPORT_FILE}" \
            "${FEISHU_TARGET}"
        log_success "飞书消息已发送"
    else
        log_error "分割脚本不存在，跳过自动发送"
    fi

    log_success "任务完成"
}

# 执行主函数
main "$@"
