#!/bin/bash

# 分析 skills 目录中所有 SKILL.md 文件的脚本

SKILLS_DIR="/root/.openclaw/workspace/skills"
OUTPUT_FILE="/tmp/skills_analysis.txt"

echo "# Skills 审计分析" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "生成时间: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

for skill_dir in "$SKILLS_DIR"/*/; do
    skill_name=$(basename "$skill_dir")
    skill_file="$skill_dir/SKILL.md"

    if [ ! -f "$skill_file" ]; then
        continue
    fi

    echo "## $skill_name" >> "$OUTPUT_FILE"

    # 统计行数
    lines=$(wc -l < "$skill_file")

    # 提取 name
    name=$(grep -E "^name:" "$skill_file" | head -1 | cut -d':' -f2- | sed 's/^[ \t]*//')

    # 提取 description
    desc=$(awk '/^description:/,/^[^ \t]/' "$skill_file" | tail -n +2 | head -n -1 | sed 's/^[ \t]*//')
    if [ -z "$desc" ]; then
        desc=$(grep "^description:" "$skill_file" | head -1 | cut -d':' -f2- | sed 's/^[ \t]*//')
    fi

    # 检查是否有 version
    has_version=$(grep -q "^version:" "$skill_file" && echo "Yes" || echo "No")

    # 检查是否有 author
    has_author=$(grep -q "^author:" "$skill_file" && echo "Yes" || echo "No")

    # 检查是否有示例（查找包含 "example" 或 "示例" 的部分）
    has_examples=$(grep -qi "example\|示例\|Example" "$skill_file" && echo "Yes" || echo "No")

    # 检查子目录
    has_scripts=$( [ -d "$skill_dir/scripts" ] && echo "Yes" || echo "No" )
    has_references=$( [ -d "$skill_dir/references" ] && echo "Yes" || echo "No" )
    has_assets=$( [ -d "$skill_dir/assets" ] && echo "Yes" || echo "No" )
    has_evals=$( [ -d "$skill_dir/evals" ] && echo "Yes" || echo "No" )

    # 检查是否有 FORMAT.md 或 README.md
    has_format=$( [ -f "$skill_dir/FORMAT.md" ] && echo "Yes" || echo "No" )
    has_readme=$( [ -f "$skill_dir/README.md" ] && echo "Yes" || echo "No" )

    echo "- **文件行数**: $lines" >> "$OUTPUT_FILE"
    echo "- **Name**: $name" >> "$OUTPUT_FILE"
    echo "- **Description**: ${desc:0:100}..." >> "$OUTPUT_FILE"
    echo "- **有版本信息**: $has_version" >> "$OUTPUT_FILE"
    echo "- **有作者信息**: $has_author" >> "$OUTPUT_FILE"
    echo "- **有示例**: $has_examples" >> "$OUTPUT_FILE"
    echo "- **子目录结构**:" >> "$OUTPUT_FILE"
    echo "  - scripts/: $has_scripts" >> "$OUTPUT_FILE"
    echo "  - references/: $has_references" >> "$OUTPUT_FILE"
    echo "  - assets/: $has_assets" >> "$OUTPUT_FILE"
    echo "  - evals/: $has_evals" >> "$OUTPUT_FILE"
    echo "- **辅助文档**:" >> "$OUTPUT_FILE"
    echo "  - FORMAT.md: $has_format" >> "$OUTPUT_FILE"
    echo "  - README.md: $has_readme" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
done

cat "$OUTPUT_FILE"
