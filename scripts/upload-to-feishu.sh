#!/bin/bash
#
# 飞书文档上传脚本
# 将 Markdown 文件上传到飞书知识库
#
# 使用方法：
#   ./upload-to-feishu.sh --file "报告.md" --folder "folder_token" --title "文档标题"
#

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 帮助信息
show_help() {
    cat << EOF
飞书文档上传脚本

使用方法：
    $0 --file <文件路径> --folder <文件夹token> [--title <标题>]

参数说明：
    --file      Markdown 文件路径（必需）
    --folder    飞书文件夹 token（必需）
    --title     文档标题（可选，默认使用文件名）

示例：
    $0 --file "report.md" --folder "boxxxxxx"
    $0 --file "A1-2026-03-10.md" --folder "boxxxxxx" --title "A1-Karpathy AI博客精选"

EOF
}

# 解析参数
FILE=""
FOLDER_TOKEN=""
TITLE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --file)
            FILE="$2"
            shift 2
            ;;
        --folder)
            FOLDER_TOKEN="$2"
            shift 2
            ;;
        --title)
            TITLE="$2"
            shift 2
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            log_error "未知参数: $1"
            show_help
            exit 1
            ;;
    esac
done

# 检查必需参数
if [[ -z "$FILE" ]]; then
    log_error "缺少 --file 参数"
    show_help
    exit 1
fi

if [[ -z "$FOLDER_TOKEN" ]]; then
    log_error "缺少 --folder 参数"
    show_help
    exit 1
fi

# 检查文件是否存在
if [[ ! -f "$FILE" ]]; then
    log_error "文件不存在: $FILE"
    exit 1
fi

# 如果没有指定标题，使用文件名
if [[ -z "$TITLE" ]]; then
    TITLE=$(basename "$FILE" .md)
fi

log_info "准备上传文档到飞书..."
log_info "文件: $FILE"
log_info "标题: $TITLE"
log_info "文件夹: $FOLDER_TOKEN"

# 读取文件内容
CONTENT=$(cat "$FILE")

# 使用 feishu_doc 工具创建文档
log_info "正在创建飞书文档..."

# 这里我们需要使用 Node.js 脚本，因为 Bash 无法直接调用 OpenClaw 的 API
# 所以创建一个临时的 Node.js 脚本来执行上传

cat > /tmp/upload_feishu.js << 'EOFSCRIPT'
const fs = require('fs');
const path = require('path');

// 读取参数
const args = process.argv.slice(2);
const file = args[0];
const folderToken = args[1];
const title = args[2] || path.basename(file, '.md');

console.log(`\n📄 准备上传: ${title}`);
console.log(`📁 文件: ${file}`);
console.log(`📂 文件夹: ${folderToken}`);

// 读取 Markdown 内容
const content = fs.readFileSync(file, 'utf-8');

// 由于 OpenClaw 的 API 需要在内部环境中调用，
// 我们将任务保存到临时文件，让 OpenClaw 主进程来处理
const taskFile = `/tmp/feishu_upload_${Date.now()}.json`;
fs.writeFileSync(taskFile, JSON.stringify({
    action: 'create',
    folderToken: folderToken,
    title: title,
    content: content,
    timestamp: Date.now()
}, null, 2));

console.log(`\n✅ 任务已保存: ${taskFile}`);
console.log(`\n⚠️  请在 OpenClaw 中使用以下命令完成上传：`);
console.log(`\n   feishu_doc action=create title="${title}" folder_token="${folderToken}" content="${content}"`);
EOFSCRIPT

# 执行 Node.js 脚本
node /tmp/upload_feishu.js "$FILE" "$FOLDER_TOKEN" "$TITLE"

# 清理临时文件
rm -f /tmp/upload_feishu.js

log_success "\n✅ 上传任务已准备完成"
log_info "\n提示：由于飞书 API 需要在 OpenClaw 环境中调用，"
log_info "      请使用 OpenClaw 的 feishu_doc 工具完成上传。"
log_info "\n      或直接在监控脚本中使用 feishu_doc 工具。"
