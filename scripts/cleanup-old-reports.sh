#!/bin/bash
#
# 服务器报告清理脚本
# 自动删除超过30天的报告，只保留最近30天在服务器
# 所有历史报告都保存在飞书
#

set -e

# 配置
ARCHIVE_BASE="/root/.openclaw/workspace/archive"
RETENTION_DAYS=30
LOG_FILE="/var/log/cleanup-reports.log"

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

# 清理函数
cleanup_directory() {
    local dir="$1"
    local dir_name=$(basename "$dir")

    if [[ ! -d "$dir" ]]; then
        return
    fi

    log_info "检查目录: $dir_name"

    # 查找超过30天的文件
    local old_files=$(find "$dir" -name "*.md" -type f -mtime +$RETENTION_DAYS)

    if [[ -z "$old_files" ]]; then
        log_info "  ✓ 没有需要清理的文件"
        return
    fi

    # 统计文件数量和总大小
    local file_count=$(echo "$old_files" | wc -l)
    local total_size=$(echo "$old_files" | xargs du -ch | tail -1 | cut -f1)

    log_warn "  发现 $file_count 个旧文件（总计 $total_size）"

    # 列出要删除的文件
    echo "$old_files" | while read -r file; do
        local file_date=$(basename "$file" .md | grep -oP '\d{4}-\d{2}-\d{2}' || echo "未知日期")
        log_info "  - $(basename "$file") ($file_date)"
    done

    # 删除文件
    echo "$old_files" | while read -r file; do
        rm -f "$file"
        log_success "  ✓ 已删除: $(basename "$file")"
    done

    log_success "✓ 清理完成: $dir_name"
}

# 主函数
main() {
    log "=========================================="
    log "开始清理旧报告"
    log "保留天数: $RETENTION_DAYS 天"
    log "=========================================="
    echo

    # 检查基础目录是否存在
    if [[ ! -d "$ARCHIVE_BASE" ]]; then
        log_error "归档目录不存在: $ARCHIVE_BASE"
        exit 1
    fi

    # 统计清理前的状态
    local total_before=$(find "$ARCHIVE_BASE" -name "*.md" -type f | wc -l)
    local size_before=$(du -sh "$ARCHIVE_BASE" | cut -f1)
    log_info "清理前: $total_before 个文件，总大小 $size_before"
    echo

    # 遍历所有子目录并清理
    local dir_count=0
    find "$ARCHIVE_BASE" -maxdepth 1 -type d | while read -r dir; do
        if [[ "$dir" != "$ARCHIVE_BASE" ]]; then
            cleanup_directory "$dir"
            ((dir_count++))
        fi
    done

    echo
    # 统计清理后的状态
    local total_after=$(find "$ARCHIVE_BASE" -name "*.md" -type f | wc -l)
    local size_after=$(du -sh "$ARCHIVE_BASE" | cut -f1)
    local deleted_count=$((total_before - total_after))

    log_success "=========================================="
    log_success "清理完成"
    log_success "删除文件: $deleted_count 个"
    log_success "剩余文件: $total_after 个"
    log_success "当前大小: $size_after（之前: $size_before）"
    log_success "=========================================="

    # 发送飞书通知（可选）
    if command -v feishu &> /dev/null; then
        feishu message send \
            --target="ou_a7195bd3e0508f0e0d09f19ff12a8811" \
            --message="🧹 服务器报告清理完成\n\n删除: $deleted_count 个文件\n剩余: $total_after 个文件（最近30天）\n完整历史已保存在飞书" \
            2>/dev/null || true
    fi
}

# 执行主函数
main "$@"
