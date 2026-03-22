#!/usr/bin/env python3
"""
智能分割飞书长消息 + 富文本加粗支持

⚠️ 飞书格式要点（已固化）：
1. 加粗：使用飞书富文本格式，把 **文本** 转换为 {"tag":"text","text":"文本","style":["bold"]}
2. 空行：使用全角空格 `　` 作为段落分隔
3. 链接：支持 [显示文本](URL) 格式
"""
import sys
import subprocess
import re
import json

MAX_LENGTH = 4096  # 飞书消息长度限制
FEISHU_TARGET = "ou_a7195bd3e0508f0e0d09f19ff12a8811"


def parse_markdown_to_feishu_rich_text(text: str) -> list:
    """
    把 Markdown 文本转换为飞书富文本元素列表
    
    支持：
    - **加粗** → {"tag":"text","text":"加粗","style":["bold"]}
    - [链接](URL) → {"tag":"a","href":"URL","text":"链接"}
    - 普通文本 → {"tag":"text","text":"文本"}
    """
    elements = []
    pos = 0
    
    # 正则匹配 **加粗** 和 [链接](URL)
    bold_pattern = re.compile(r'\*\*([^*]+)\*\*')
    link_pattern = re.compile(r'\[([^\]]+)\]\(([^)]+)\)')
    
    while pos < len(text):
        # 找最近的匹配
        bold_match = bold_pattern.search(text, pos)
        link_match = link_pattern.search(text, pos)
        
        # 确定下一个匹配
        next_match = None
        match_type = None
        
        if bold_match and link_match:
            if bold_match.start() < link_match.start():
                next_match = bold_match
                match_type = 'bold'
            else:
                next_match = link_match
                match_type = 'link'
        elif bold_match:
            next_match = bold_match
            match_type = 'bold'
        elif link_match:
            next_match = link_match
            match_type = 'link'
        
        if next_match:
            # 添加匹配前的普通文本
            if next_match.start() > pos:
                plain_text = text[pos:next_match.start()]
                if plain_text:
                    elements.append({"tag": "text", "text": plain_text, "style": []})
            
            # 添加匹配的元素
            if match_type == 'bold':
                elements.append({"tag": "text", "text": next_match.group(1), "style": ["bold"]})
            elif match_type == 'link':
                elements.append({"tag": "a", "href": next_match.group(2), "text": next_match.group(1)})
            
            pos = next_match.end()
        else:
            # 没有更多匹配，添加剩余文本
            if pos < len(text):
                plain_text = text[pos:]
                if plain_text:
                    elements.append({"tag": "text", "text": plain_text, "style": []})
            break
    
    return elements


def build_feishu_post_message(content: str) -> str:
    """
    构建飞书富文本消息 JSON
    
    格式：
    {
      "zh_cn": {
        "content": [
          [{"tag":"text","text":"标题","style":["bold"]}],
          [{"tag":"text","text":"正文","style":[]}]
        ]
      }
    }
    """
    lines = content.split('\n')
    content_elements = []
    
    for line in lines:
        if line.strip():
            # 把每行转换成富文本元素
            elements = parse_markdown_to_feishu_rich_text(line)
            if elements:
                content_elements.append(elements)
        else:
            # 空行用全角空格
            content_elements.append([{"tag": "text", "text": "　", "style": []}])
    
    post_message = {
        "zh_cn": {
            "content": content_elements
        }
    }
    
    return json.dumps(post_message, ensure_ascii=False)


def send_feishu_message(content: str, target: str = FEISHU_TARGET, dry_run: bool = False):
    """发送飞书消息（富文本格式）"""
    if dry_run:
        return True  # 测试模式，不实际发送

    # 构建富文本消息
    post_content = build_feishu_post_message(content)
    
    cmd = [
        "/root/.nvm/versions/node/v22.22.0/bin/node",
        "/root/.nvm/versions/node/v22.22.0/lib/node_modules/openclaw/dist/index.js",
        "message", "send",
        "--channel", "feishu",
        "--target", target,
        "--message", post_content,
        "--content-type", "post"
    ]

    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.returncode == 0


def split_message_by_blocks(content: str, max_length: int = MAX_LENGTH):
    """
    按照语义块分割消息
    
    简单策略：
    1. 如果总长度 ≤ 4096，一次发送
    2. 如果总长度 > 4096，按语义块分割：
       - 在累积到 3800 字符左右时，主动在语义边界断开
       - 优先在 ## 标题 和 --- 分隔线处断开
    """
    total_length = len(content)
    
    # 如果不超过限制，直接返回
    if total_length <= max_length:
        return [content]
    
    lines = content.split('\n')
    parts = []
    current_part = []
    current_length = 0
    
    # 预警阈值：3800 字符
    WARNING_THRESHOLD = int(max_length * 0.93)
    
    for line in lines:
        line_length = len(line) + 1  # +1 for newline
        
        # 检查是否是语义边界
        is_boundary = line.startswith('## ') or line.strip() == '---'
        
        # 如果添加这行会超过预警阈值，且当前部分已经有足够内容
        if current_length + line_length > WARNING_THRESHOLD and current_length > 1000:
            # 如果是语义边界，在这里断开
            if is_boundary:
                # 保存当前部分
                parts.append('\n'.join(current_part))
                current_part = [line]
                current_length = line_length
                continue
            else:
                # 不是边界，继续累积，但检查是否硬性超限
                if current_length + line_length > max_length:
                    # 必须断开了
                    parts.append('\n'.join(current_part))
                    current_part = [line]
                    current_length = line_length
                    continue
        
        # 累积内容
        current_part.append(line)
        current_length += line_length
    
    # 添加最后部分
    if current_part:
        parts.append('\n'.join(current_part))
    
    return parts


def main():
    # 支持三种输入方式：
    # 1. 文件路径：python3 split-feishu-message.py <markdown文件> [target_id]
    # 2. 管道输入：cat content.md | python3 split-feishu-message.py [target_id]
    # 3. 测试模式：python3 split-feishu-message.py --test <markdown文件>

    dry_run = '--test' in sys.argv or '--dry-run' in sys.argv

    # 移除 --test 和 --dry-run 参数
    args = [arg for arg in sys.argv[1:] if arg not in ['--test', '--dry-run']]

    target = FEISHU_TARGET

    if len(args) < 1:
        # 从 stdin 读取
        content = sys.stdin.read()
    else:
        input_file = args[0]
        target = args[1] if len(args) > 1 else FEISHU_TARGET

        # 读取文件
        try:
            with open(input_file, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            print(f"❌ 读取文件失败: {e}")
            sys.exit(1)

    total_length = len(content)
    print(f"📄 原文长度: {total_length} 字符")
    print(f"📏 飞书限制: {MAX_LENGTH} 字符")

    # 检查是否需要分割
    if total_length <= MAX_LENGTH:
        print("✅ 消息长度在限制内，一次发送")
        success = send_feishu_message(content, target, dry_run)
        if success:
            if dry_run:
                print("🧪 [测试模式] 发送成功（富文本格式，加粗已生效）")
                # 打印富文本 JSON 预览
                post_content = build_feishu_post_message(content)
                print(f"\n📝 富文本 JSON 预览（前 500 字符）:\n{post_content[:500]}...")
            else:
                print("✅ 发送成功（富文本格式，加粗已生效）")
        else:
            print("❌ 发送失败")
        sys.exit(0 if success else 1)

    # 需要分割
    print(f"⚠️ 消息过长，需要分批发送")

    parts = split_message_by_blocks(content)
    print(f"📦 分割成 {len(parts)} 部分")

    # 发送各部分
    for i, part in enumerate(parts, 1):
        part_length = len(part)
        print(f"\n📤 发送第 {i}/{len(parts)} 部分，长度: {part_length} 字符")

        # 添加分页标识（序号放在底部）
        if len(parts) > 1:
            suffix = f"\n\n（{i}/{len(parts)}）" if i < len(parts) else "\n\n（完）"
            part = part + suffix

        if dry_run:
            print(f"🧪 [测试模式] 第 {i} 部分不会实际发送")
            # 打印富文本 JSON 预览
            post_content = build_feishu_post_message(part)
            print(f"   富文本 JSON 预览（前 200 字符）: {post_content[:200]}...")
        else:
            success = send_feishu_message(part, target, dry_run=False)
            if not success:
                print(f"❌ 第 {i} 部分发送失败")
                sys.exit(1)

            print(f"✅ 第 {i} 部分发送成功（富文本格式）")

            # 如果不是最后部分，等待一下避免频率限制
            if i < len(parts):
                import time
                time.sleep(1)

    print(f"\n✅ 全部发送完成，共 {len(parts)} 部分（富文本格式，加粗已生效）")

if __name__ == '__main__':
    main()