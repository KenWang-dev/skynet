#!/usr/bin/env python3
"""
智能分割飞书长消息
在语义块边界（## 标题、--- 分隔线）断开，避免截断

⚠️ 飞书格式要点（已固化）：
1. 加粗：飞书普通文本不支持 Markdown 加粗，必须用卡片模式
2. 卡片模式触发：消息末尾添加 ``` 代码块
3. 空行：使用全角空格 `　` 作为段落分隔
"""
import sys
import subprocess
import re

MAX_LENGTH = 4096  # 飞书消息长度限制
FEISHU_TARGET = "ou_a7195bd3e0508f0e0d09f19ff12a8811"

# 卡片模式触发器（放在消息末尾，触发飞书卡片渲染，使 Markdown 加粗生效）
CARD_TRIGGER = "\n```\n🪭\n```"

def send_feishu_message(content: str, target: str = FEISHU_TARGET, dry_run: bool = False):
    """发送飞书消息"""
    if dry_run:
        return True  # 测试模式，不实际发送

    cmd = [
        "/root/.nvm/versions/node/v22.22.0/bin/node",
        "/root/.nvm/versions/node/v22.22.0/lib/node_modules/openclaw/dist/index.js",
        "message", "send",
        "--channel", "feishu",
        "--target", target,
        "--message", content
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
        # ⚠️ 添加卡片触发器，使 Markdown 加粗生效
        content_with_card = content + CARD_TRIGGER
        success = send_feishu_message(content_with_card, target)
        if success:
            print("✅ 发送成功（卡片模式，加粗已生效）")
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

        # ⚠️ 添加卡片触发器，使 Markdown 加粗生效
        part = part + CARD_TRIGGER

        if dry_run:
            print(f"🧪 [测试模式] 第 {i} 部分不会实际发送")
            print(f"   前 100 字符预览: {part[:100]}...")
        else:
            success = send_feishu_message(part, target, dry_run=False)
            if not success:
                print(f"❌ 第 {i} 部分发送失败")
                sys.exit(1)

            print(f"✅ 第 {i} 部分发送成功（卡片模式）")

            # 如果不是最后部分，等待一下避免频率限制
            if i < len(parts):
                import time
                time.sleep(1)

    print(f"\n✅ 全部发送完成，共 {len(parts)} 部分（卡片模式，加粗已生效）")

if __name__ == '__main__':
    main()
