#!/usr/bin/env python3
"""
Tavily API Key 轮换池管理器
- 自动切换 Key（当用量 > 90% 时）
- 记录使用次数
- 每月自动重置
- API Key 存储在 .env 中，此处只管理状态
"""

import json
import os
from datetime import datetime
from pathlib import Path

POOL_FILE = Path("/root/.openclaw/workspace/tavily-key-pool.json")
ENV_FILE = Path("/root/.openclaw/.env")
USAGE_THRESHOLD = 0.90  # 90% 阈值

def load_env():
    """加载 .env 文件"""
    env_vars = {}
    if ENV_FILE.exists():
        with open(ENV_FILE, 'r') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#') and '=' in line:
                    key, value = line.split('=', 1)
                    env_vars[key.strip()] = value.strip()
    return env_vars

def load_pool():
    """加载 Key 池配置"""
    if not POOL_FILE.exists():
        return None
    with open(POOL_FILE, 'r') as f:
        return json.load(f)

def save_pool(pool):
    """保存 Key 池配置"""
    pool["last_updated"] = datetime.now().isoformat()
    with open(POOL_FILE, 'w') as f:
        json.dump(pool, f, indent=2)

def get_active_key():
    """获取当前可用的 API Key"""
    pool = load_pool()
    if not pool:
        return None, None
    
    env_vars = load_env()
    current_idx = pool.get("current_index", 0)
    keys = pool.get("keys", [])
    
    if not keys:
        return None, None
    
    # 检查当前 Key 是否可用
    current_key_config = keys[current_idx]
    env_key_name = current_key_config.get("env_key", "")
    actual_key = env_vars.get(env_key_name, "")
    
    # 如果当前 Key 已用完，尝试切换下一个
    if current_key_config["usage"] >= current_key_config["limit"] * USAGE_THRESHOLD:
        # 寻找下一个可用的 Key
        for i in range(len(keys)):
            next_idx = (current_idx + i + 1) % len(keys)
            if keys[next_idx]["usage"] < keys[next_idx]["limit"] * USAGE_THRESHOLD:
                pool["current_index"] = next_idx
                pool["remaining_quota"] = sum(
                    k["limit"] - k["usage"] for k in keys
                )
                save_pool(pool)
                
                # 返回实际的 API Key
                next_env_key = keys[next_idx].get("env_key", "")
                actual_key = env_vars.get(next_env_key, "")
                return actual_key, next_idx
        
        # 所有 Key 都用完了，返回第一个
        first_env_key = keys[0].get("env_key", "")
        actual_key = env_vars.get(first_env_key, "")
        return actual_key, 0
    
    return actual_key, current_idx

def increment_usage():
    """增加当前 Key 的使用计数"""
    pool = load_pool()
    if not pool:
        return
    
    current_idx = pool.get("current_index", 0)
    keys = pool.get("keys", [])
    
    if current_idx < len(keys):
        keys[current_idx]["usage"] += 1
        pool["remaining_quota"] = sum(
            k["limit"] - k["usage"] for k in keys
        )
        save_pool(pool)

def reset_monthly():
    """每月重置所有 Key 用量"""
    pool = load_pool()
    if not pool:
        return
    
    for key in pool.get("keys", []):
        key["usage"] = 0
        key["status"] = "active"
    
    pool["current_index"] = 0
    pool["remaining_quota"] = pool.get("total_quota", 0)
    save_pool(pool)
    print("✅ 所有 Key 已重置")

def add_key(env_key_name, note=""):
    """添加新的 API Key 配置（需要先在 .env 中添加实际的 Key）"""
    pool = load_pool()
    if not pool:
        pool = {"keys": [], "current_index": 0}
    
    pool["keys"].append({
        "env_key": env_key_name,
        "usage": 0,
        "limit": 1000,
        "status": "standby",
        "note": note
    })
    pool["total_quota"] = len(pool["keys"]) * 1000
    pool["remaining_quota"] = sum(
        k["limit"] - k["usage"] for k in pool["keys"]
    )
    save_pool(pool)
    print(f"✅ 新 Key 配置已添加: {env_key_name}")
    print(f"   请确保在 .env 中添加: {env_key_name}=tvly-dev-xxx...")

def status():
    """显示当前状态"""
    pool = load_pool()
    env_vars = load_env()
    
    if not pool:
        print("❌ Key 池未配置")
        return
    
    print("📊 Tavily API Key 轮换池状态")
    print("=" * 50)
    for i, k in enumerate(pool.get("keys", [])):
        status_icon = "✅" if k["usage"] < k["limit"] * USAGE_THRESHOLD else "⚠️"
        current = " ← 当前" if i == pool.get("current_index") else ""
        env_key_name = k.get("env_key", "")
        actual_key = env_vars.get(env_key_name, "未配置")
        key_preview = actual_key[:20] + "..." if actual_key and actual_key != "未配置" else "未配置"
        
        print(f"{status_icon} Key #{i+1}: {env_key_name}")
        print(f"   实际 Key: {key_preview}")
        print(f"   用量: {k['usage']}/{k['limit']}{current}")
        if k.get("note"):
            print(f"   Note: {k['note']}")
    
    print("=" * 50)
    print(f"总配额: {pool.get('total_quota', 0)} 次/月")
    print(f"剩余: {pool.get('remaining_quota', 0)} 次")
    print(f"\n🔒 安全: API Key 存储在 .env 中")

if __name__ == "__main__":
    import sys
    
    if len(sys.argv) < 2:
        status()
        sys.exit(0)
    
    cmd = sys.argv[1]
    
    if cmd == "get":
        key, idx = get_active_key()
        if key:
            print(key)
        else:
            print("ERROR: No available key")
    
    elif cmd == "increment":
        increment_usage()
    
    elif cmd == "reset":
        reset_monthly()
    
    elif cmd == "add" and len(sys.argv) >= 3:
        env_key_name = sys.argv[2]
        note = sys.argv[3] if len(sys.argv) > 3 else ""
        add_key(env_key_name, note)
    
    elif cmd == "status":
        status()
    
    else:
        print("用法: tavily-pool.py [get|increment|reset|add|status]")