#!/bin/bash
#
# 飞书配置文件
# Claw1号知识库配置
#

# ============ 知识库信息 ============
export FEISHU_SPACE_ID="7615440793062394844"
export FEISHU_SPACE_NAME="Claw1号知识库"
export FEISHU_WIKI_URL="https://procurement-leap.feishu.cn/wiki/KvTgwudfqi3OcEke7qBc9Pkpn2d"

# ============ 根节点 ============
export FEISHU_ROOT_NODE="KvTgwudfqi3OcEke7qBc9Pkpn2d"

# ============ 文件夹 Token（已配置）============

# ============ Alpha 系列 - AI技术前沿 ============
export FEISHU_FOLDER_ALPHA="IICqwHgTliX60VkrvlmcYFa5nDf"

# ============ Beta 系列 - AI巨头动态 ============
export FEISHU_FOLDER_BETA="HQSkwMzj7iI42pkpFikc1ai8n4d"

# ============ Gamma 系列 - 资本风向 ============
export FEISHU_FOLDER_GAMMA="R9XTwwpCyiSKIVksAoBc9lFsnkr"

# ============ Delta 系列 - 政策推手 ============
export FEISHU_FOLDER_DELTA="EeMxwc2IVixEH9kHQUycc1kfnOc"

# ============ 供应链监控 ============
export FEISHU_FOLDER_SUPPLY="KXgzwwqbii0BQmke1ArcGRZ8n3c"

# ============ 宏观财务 ============
export FEISHU_FOLDER_MACRO="CxL9wx41XifAkYkMUIkchgSYnsc"

# ============ 行业与政策 ============
export FEISHU_FOLDER_POLICY="TZ70wI9JGiAByak112kcb7kenec"

# ============ 其他监控 ============
export FEISHU_FOLDER_OTHER="S6pSwUGbCie1lwkyu6gcXxncnBe"

# ============ 使用说明 ============
#
# 在监控脚本中加载此配置：
# source /root/.openclaw/workspace/scripts/feishu-config.sh
#
# 使用函数上传文档：
# upload_to_feishu "A1" "报告标题" "$REPORT_FILE"
#
# 或者直接使用 feishu_doc 工具：
# feishu_doc action=create \
#   title="报告标题" \
#   folder_token="$FEISHU_FOLDER_ALPHA" \
#   content="$(cat report.md)"
#
