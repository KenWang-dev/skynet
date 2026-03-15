#!/usr/bin/env python3
"""
飞书文档上传脚本
将Markdown文件上传到飞书知识库，保留格式和排版
"""

import os
import sys
import argparse
from pathlib import Path

# 添加 Feishu 扩展路径
sys.path.insert(0, '/root/.openclaw/extensions/feishu/lib')

try:
    from feishu_lib import FeishuClient
except ImportError:
    print("❌ 错误：无法导入 feishu_lib")
    print("请确保 Feishu 扩展已正确安装")
    sys.exit(1)


def markdown_to_feishu_content(markdown_text):
    """
    将 Markdown 转换为飞书文档内容格式

    飞书文档 API 接受的结构化格式：
    {
        "children": [
            {
                "type": "paragraph",
                "paragraph": {
                    "elements": [...]
                }
            }
        ]
    }
    """
    lines = markdown_text.split('\n')
    content_blocks = []

    for line in lines:
        if not line.strip():
            # 空行
            continue

        # 标题处理
        if line.startswith('# '):
            text = line[2:].strip()
            content_blocks.append({
                "type": "heading",
                "heading": {
                    "level": 1,
                    "style": "HEADING_1",
                    "children": [{"type": "textRun", "textRun": {"text": text}}]
                }
            })
        elif line.startswith('## '):
            text = line[3:].strip()
            content_blocks.append({
                "type": "heading",
                "heading": {
                    "level": 2,
                    "style": "HEADING_2",
                    "children": [{"type": "textRun", "textRun": {"text": text}}]
                }
            })
        elif line.startswith('### '):
            text = line[4:].strip()
            content_blocks.append({
                "type": "heading",
                "heading": {
                    "level": 3,
                    "style": "HEADING_3",
                    "children": [{"type": "textRun", "textRun": {"text": text}}]
                }
            })
        # 列表处理
        elif line.startswith('- '):
            text = line[2:].strip()
            content_blocks.append({
                "type": "bullet",
                "bullet": {
                    "level": 1,
                    "children": [{"type": "textRun", "textRun": {"text": text}}]
                }
            })
        # 加粗文本处理
        elif '**' in line:
            # 简单处理：将整个段落作为文本块
            content_blocks.append({
                "type": "paragraph",
                "paragraph": {
                    "elements": [{
                        "type": "textRun",
                        "textRun": {
                            "text": line.replace('**', ''),
                            "textStyle": {"bold": True}
                        }
                    }]
                }
            })
        # 普通段落
        else:
            content_blocks.append({
                "type": "paragraph",
                "paragraph": {
                    "elements": [{
                        "type": "textRun",
                        "textRun": {"text": line}
                    }]
                }
            })

    return {"children": content_blocks}


def upload_to_feishu(
    file_path: str,
    folder_token: str,
    title: str = None,
    space_id: str = None
):
    """
    上传 Markdown 文件到飞书知识库

    Args:
        file_path: Markdown 文件路径
        folder_token: 飞书文件夹 token
        title: 文档标题（可选，默认使用文件名）
        space_id: 知识库 ID（可选）

    Returns:
        doc_token: 飞书文档 token
        doc_url: 飞书文档 URL
    """
    # 读取 Markdown 文件
    with open(file_path, 'r', encoding='utf-8') as f:
        markdown_content = f.read()

    # 如果没有指定标题，使用文件名
    if title is None:
        title = Path(file_path).stem

    print(f"📄 准备上传：{title}")
    print(f"📁 文件夹 token: {folder_token}")

    # 初始化飞书客户端
    client = FeishuClient()

    # 创建文档
    try:
        # 创建文档（返回文档 token）
        result = client.create_doc(
            folder_token=folder_token,
            title=title
        )

        if not result or 'data' not in result:
            print("❌ 创建文档失败")
            return None, None

        doc_token = result['data'].get('document', {}).get('doc_token')

        if not doc_token:
            print("❌ 未获取到文档 token")
            return None, None

        print(f"✅ 文档创建成功：{doc_token}")

        # 写入内容
        # 注意：这里简化处理，直接写入 Markdown 文本
        # 飞书会自动渲染 Markdown 格式
        client.update_doc(
            doc_token=doc_token,
            content=markdown_content
        )

        print(f"✅ 内容写入成功")

        # 生成文档 URL
        doc_url = f"https://feishu.cn/doc/{doc_token}"

        return doc_token, doc_url

    except Exception as e:
        print(f"❌ 上传失败：{str(e)}")
        import traceback
        traceback.print_exc()
        return None, None


def main():
    parser = argparse.ArgumentParser(description='上传 Markdown 到飞书知识库')
    parser.add_argument('--file', required=True, help='Markdown 文件路径')
    parser.add_argument('--folder', required=True, help='飞书文件夹 token')
    parser.add_argument('--title', help='文档标题（可选）')
    parser.add_argument('--space', help='知识库 ID（可选）')

    args = parser.parse_args()

    # 检查文件是否存在
    if not os.path.exists(args.file):
        print(f"❌ 文件不存在：{args.file}")
        sys.exit(1)

    # 上传
    doc_token, doc_url = upload_to_feishu(
        file_path=args.file,
        folder_token=args.folder,
        title=args.title,
        space_id=args.space
    )

    if doc_token:
        print(f"\n🎉 上传成功！")
        print(f"📄 文档 token: {doc_token}")
        print(f"🔗 文档链接: {doc_url}")

        # 保存到文件供后续使用
        output_file = Path(args.file).parent / f"{Path(args.file).stem}_feishu_info.txt"
        with open(output_file, 'w') as f:
            f.write(f"doc_token={doc_token}\n")
            f.write(f"doc_url={doc_url}\n")
        print(f"💾 信息已保存到：{output_file}")
    else:
        print(f"\n❌ 上传失败")
        sys.exit(1)


if __name__ == '__main__':
    main()
