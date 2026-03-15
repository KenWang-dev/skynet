#!/bin/bash
# 批量添加存档步骤到监控任务 SKILL.md

echo "开始批量添加存档步骤..."

# 定义任务列表
declare -A tasks=(
  ["A1"]="Karpathy-AI博客精选"
  ["E1"]="政策与法规监控日报"
  ["E2"]="政策与法规监控周报"
  ["E3"]="政策与法规监控月报"
  ["F1"]="宏观财务日报"
  ["F2"]="宏观财务周报"
  ["G2"]="行业市场监控周报"
  ["H2"]="AI采购最佳实践周报"
  ["I2"]="采购心声监控周报"
  ["K2"]="供应商生态系统监控周报"
)

# 为每个任务添加存档说明
for code in "${!tasks[@]}"; do
  name="${tasks[$code]}"
  echo "处理 $code - $name..."

  # 在 SKILL.md 顶部添加存档要求说明
  skill_file="/root/.openclaw/workspace/skills/*${code}*/SKILL.md"

  # 找到实际的文件路径
  for f in $skill_file; do
    if [ -f "$f" ]; then
      # 检查是否已经有存档说明
      if ! grep -q "## 存档要求" "$f"; then
        # 在文件开头插入存档要求
        sed -i "1i\\## 📋 存档要求\\n\\n**重要：** 每次生成报告后必须先保存到本地，再发送飞书！\\n\\n### 存档步骤\\n\\n1. **保存到 archive 目录**：\\n   \\`\\`\\`bash\\n   date=$(date +%Y-%m-%d)\\n   echo -e \\\"$report_content\\\" > \\\"/root/.openclaw/workspace/archive/${code}-${name}/${code}-\\${date}.md\\\"\\n   \\`\\`\\`\\n\\n2. **发送飞书**：\\n   \\`\\`\\`javascript\\n   message({ action: \\\"send\\\", channel: \\\"feishu\\\", target: \\\"ou_a7195bd3e0508f0e0d09f19ff12a8811\\\", message: report_content });\\n   \\`\\`\\`\\n\\n---\\n" "$f"
        echo "  ✅ 已添加存档说明到 $f"
      else
        echo "  ⏭️  已有存档说明，跳过"
      fi
    fi
  done
done

echo ""
echo "✅ 批量添加完成！"
echo ""
echo "📊 已处理的任务："
for code in "${!tasks[@]}"; do
  echo "  - $code: ${tasks[$code]}"
done
