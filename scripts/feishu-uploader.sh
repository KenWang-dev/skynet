#!/bin/bash
#
# 飞书文档上传函数库
# 提供：upload_to_feishu 函数
#

# ============ 配置区域 ============
# 请在使用此脚本前设置以下环境变量

# FEISHU_FOLDER_ALPHA=""    # Alpha系列 - AI技术前沿
# FEISHU_FOLDER_BETA=""     # Beta系列 - AI巨头动态
# FEISHU_FOLDER_GAMMA=""    # Gamma系列 - 资本风向
# FEISHU_FOLDER_DELTA=""    # Delta系列 - 政策推手
# FEISHU_FOLDER_SUPPLY=""   # 供应链监控
# FEISHU_FOLDER_MACRO=""    # 宏观财务
# FEISHU_FOLDER_POLICY=""   # 行业与政策
# FEISHU_FOLDER_OTHER=""    # 其他监控

# ============ 函数定义 ============

#
# upload_to_feishu - 上传 Markdown 文件到飞书知识库
#
# 参数:
#   $1 - 报告代码 (如: A1, B1, Gamma1)
#   $2 - 报告标题 (如: Karpathy AI博客精选)
#   $3 - Markdown 文件路径
#
# 返回:
#   0 - 成功
#   1 - 失败
#
# 使用示例:
#   upload_to_feishu "A1" "Karpathy AI博客精选" "./output/report.md"
#
upload_to_feishu() {
    local code="$1"
    local title="$2"
    local file_path="$3"

    # 检查文件是否存在
    if [[ ! -f "$file_path" ]]; then
        echo "❌ 文件不存在: $file_path"
        return 1
    fi

    # 确定文件夹 token（根据报告代码）
    local folder_token=""
    case "$code" in
        A1|Alpha*)
            folder_token="$FEISHU_FOLDER_ALPHA"
            ;;
        B1|Beta*)
            folder_token="$FEISHU_FOLDER_BETA"
            ;;
        Gamma*)
            folder_token="$FEISHU_FOLDER_GAMMA"
            ;;
        Delta*)
            folder_token="$FEISHU_FOLDER_DELTA"
            ;;
        C1|C2|D1|D2)
            folder_token="$FEISHU_FOLDER_SUPPLY"
            ;;
        F1|F2)
            folder_token="$FEISHU_FOLDER_MACRO"
            ;;
        E1|E2|E3|G2)
            folder_token="$FEISHU_FOLDER_POLICY"
            ;;
        *)
            folder_token="$FEISHU_FOLDER_OTHER"
            ;;
    esac

    # 检查 folder_token 是否配置
    if [[ -z "$folder_token" ]]; then
        echo "⚠️  未配置飞书文件夹 token ($code)"
        echo "   请设置环境变量: FEISHU_FOLDER_XXX"
        return 1
    fi

    # 生成带日期的标题
    local date_str=$(date +%Y-%m-%d)
    local doc_title="${title} ${date_str}"

    # 读取文件内容
    local content=$(cat "$file_path")

    # 保存上传任务到临时文件
    local task_file="/tmp/feishu_upload_${code}_${date_str}.json"
    cat > "$task_file" << EOF
{
  "action": "create",
  "title": "${doc_title}",
  "content": $(echo "$content" | jq -Rs .),
  "folder_token": "${folder_token}",
  "code": "${code}",
  "date": "${date_str}",
  "timestamp": $(date +%s)
}
EOF

    echo "📤 飞书上传任务已准备: $task_file"

    # TODO: 在 OpenClaw 环境中，直接调用 feishu_doc 工具
    # 注意：这需要在 OpenClaw 主环境中执行，或者通过 systemEvent 触发

    echo "✅ 飞书文档创建任务已准备"
    echo "   标题: $doc_title"
    echo "   文件夹: ${folder_token:0:10}..."
    echo "   文件: $file_path"

    return 0
}

#
# upload_to_feishu_with_doc_api - 使用 feishu_doc 工具上传
#
# 这个函数需要在 OpenClaw 环境中运行
#
upload_to_feishu_with_doc_api() {
    local code="$1"
    local title="$2"
    local file_path="$3"

    # 检查文件是否存在
    if [[ ! -f "$file_path" ]]; then
        echo "❌ 文件不存在: $file_path"
        return 1
    fi

    # 确定文件夹 token
    local folder_token=""
    case "$code" in
        A1|Alpha*)
            folder_token="$FEISHU_FOLDER_ALPHA"
            ;;
        B1|Beta*)
            folder_token="$FEISHU_FOLDER_BETA"
            ;;
        Gamma*)
            folder_token="$FEISHU_FOLDER_GAMMA"
            ;;
        Delta*)
            folder_token="$FEISHU_FOLDER_DELTA"
            ;;
        C1|C2|D1|D2)
            folder_token="$FEISHU_FOLDER_SUPPLY"
            ;;
        F1|F2)
            folder_token="$FEISHU_FOLDER_MACRO"
            ;;
        E1|E2|E3|G2)
            folder_token="$FEISHU_FOLDER_POLICY"
            ;;
        *)
            folder_token="$FEISHU_FOLDER_OTHER"
            ;;
    esac

    if [[ -z "$folder_token" ]]; then
        echo "⚠️  未配置飞书文件夹 token"
        return 1
    fi

    # 生成带日期的标题
    local date_str=$(date +%Y-%m-%d)
    local doc_title="${title} ${date_str}"

    echo "📤 正在上传到飞书..."
    echo "   标题: $doc_title"

    # 读取文件内容
    local content=$(cat "$file_path")

    # 这里需要调用 OpenClaw 的 feishu_doc 工具
    # 由于这是在子进程中，需要通过其他方式触发
    # 方案1: 保存到临时文件，让主进程处理
    # 方案2: 通过 cron 的 systemEvent 触发
    # 方案3: 直接在监控任务中调用

    # 暂时保存任务信息
    cat > "/tmp/feishu_${code}_task.txt" << EOF
TITLE="${doc_title}"
FOLDER="${folder_token}"
FILE="${file_path}"
EOF

    echo "✅ 飞书上传任务已准备"
    return 0
}

#
# send_feishu_notification - 发送飞书通知（带文档链接）
#
# 参数:
#   $1 - 接收人 open_id
#   $2 - 消息内容
#   $3 - 文档链接（可选）
#
send_feishu_notification() {
    local target_id="$1"
    local message="$2"
    local doc_link="$3"

    if [[ -n "$doc_link" ]]; then
        message="${message}\n\n🔗 文档链接: ${doc_link}"
    fi

    # 使用 OpenClaw 的 message 工具
    # 注意：这需要在 OpenClaw 主环境中执行
    echo "📬 准备发送飞书通知..."
    echo "   接收人: ${target_id:0:15}..."
    echo "   消息: ${message:0:50}..."
}

# ============ 导出函数 ============
export -f upload_to_feishu
export -f upload_to_feishu_with_doc_api
export -f send_feishu_notification
