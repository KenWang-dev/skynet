#!/bin/bash
# 存档辅助函数 - 保存监控报告到 archive 目录

# 使用方法：
# source /root/.openclaw/workspace/archive/archive-functions.sh
# archive_report "B1" "AI三巨头监控" "日报" "$report_content"

archive_report() {
    local code="$1"           # 任务编码（如 B1）
    local name="$2"           # 任务名称（如 AI三巨头监控）
    local type="$3"           # 报告类型（日报/周报/月报）
    local content="$4"        # 报告内容（Markdown 格式）

    # 构建路径
    local archive_dir="/root/.openclaw/workspace/archive/${code}-${name}"
    local date=$(date +%Y-%m-%d)
    local filename="${code}-${date}.md"
    local filepath="${archive_dir}/${filename}"

    # 创建目录（如果不存在）
    mkdir -p "$archive_dir"

    # 保存报告
    echo -e "$content" > "$filepath"

    # 更新索引
    update_index "$code" "$name" "$filename" "$date" "$type"

    echo "✅ 报告已存档：$filepath"
}

update_index() {
    local code="$1"
    local name="$2"
    local filename="$3"
    local date="$4"
    local type="$5"

    local index_file="/root/.openclaw/workspace/archive/${code}-${name}/${code}-index.md"

    # 如果索引不存在，创建新索引
    if [ ! -f "$index_file" ]; then
        cat > "$index_file" << EOF
# ${name} - 存档索引

**任务编码**：${code}
**任务类型**：${type}
**创建时间**：${date}

---

## 📊 报告列表

| 日期 | 文件 | 类型 |
|------|------|------|
| ${date} | [${filename}](./${filename}) | ${type} |

---

## 📈 统计信息

- **总报告数**：1
- **最早报告**：${date}
- **最新报告**：${date}
- **存档大小**：$(du -h "$archive_dir" | cut -f1)

---

**最后更新**：${date}
EOF
    else
        # 更新现有索引
        # 在表格前添加新行
        sed -i "/| 日期 | 文件 | 类型 |/a| ${date} | [${filename}](./${filename}) | ${type} |" "$index_file"

        # 更新统计信息（这里简化处理，实际可以用更复杂的逻辑）
        echo "✅ 索引已更新：$index_file"
    fi
}
