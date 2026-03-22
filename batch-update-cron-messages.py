#!/usr/bin/env python3
"""
批量更新 cron 任务消息，添加"不要发送过程性消息"的要求
"""

import json
import re

CRON_FILE = "/root/.openclaw/cron/jobs.json"

# 要添加的输出要求
OUTPUT_REQUIREMENT = """

⚠️ 输出要求：
不要发送"我来执行..."、"现在开始执行..."、"现在我将整理..."等过程性消息。
直接生成完整报告，通过飞书发送最终结果即可。"""

def update_message(message: str) -> str:
    """更新消息，添加输出要求"""
    if "输出要求" in message:
        # 已经有输出要求，跳过
        return message
    if "不要发送" in message:
        # 已经有相关要求，跳过
        return message
    
    # 所有任务都添加输出要求
    return message + OUTPUT_REQUIREMENT

def main():
    # 读取 cron 配置
    with open(CRON_FILE, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    updated_count = 0
    
    for job in data.get('jobs', []):
        if 'payload' in job and 'message' in job['payload']:
            old_message = job['payload']['message']
            new_message = update_message(old_message)
            
            if new_message != old_message:
                job['payload']['message'] = new_message
                updated_count += 1
                print(f"✅ 更新任务: {job.get('name', 'unknown')}")
    
    if updated_count > 0:
        # 保存更新后的配置
        with open(CRON_FILE, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"\n✅ 共更新 {updated_count} 个任务")
    else:
        print("没有需要更新的任务")

if __name__ == '__main__':
    main()