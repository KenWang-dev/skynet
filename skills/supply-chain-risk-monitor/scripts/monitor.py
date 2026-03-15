#!/usr/bin/env python3
"""
供应链风险监控主脚本
使用 Tavily Deep Research 模式搜索 21 项指标数据，生成风险报告
"""

import json
import sys
from datetime import datetime
from typing import Dict, List, Any


# 21项指标定义
INDICATORS = [
    # D1 原材料价格风险
    {"id": "D1.1", "name": "LME铜价走势", "dimension": "D1", "keywords": ["LME copper price March 2026", "伦敦铜交所铜价 2026年3月"]},
    {"id": "D1.2", "name": "CCL覆铜板市场价格", "dimension": "D1", "keywords": ["CCL覆铜板价格 2026年3月", "copper clad laminate price trend March 2026"]},
    {"id": "D1.3", "name": "PA66工程塑胶价格", "dimension": "D1", "keywords": ["PA66价格 2026年3月", "PA66工程塑料 市场报价"]},

    # D2 宏观金融环境风险
    {"id": "D2.1", "name": "RMB/USD/EUR汇率波动", "dimension": "D2", "keywords": ["USD/CNY exchange rate March 2026", "人民币汇率 美元 欧元 最新"]},
    {"id": "D2.2", "name": "企业融资成本变化", "dimension": "D2", "keywords": ["中国LPR利率 2026年3月", "贷款市场报价利率 最新"]},
    {"id": "D2.3", "name": "中国劳动力成本趋势", "dimension": "D2", "keywords": ["最低工资标准 2026年 调整", "制造业劳动力成本 2026"]},

    # D3 产能供需与虹吸风险
    {"id": "D3.1", "name": "AI需求虹吸效应", "dimension": "D3", "keywords": ["HBM demand DRAM capacity 2026", "DRAM合约价 涨价 2026年3月"]},
    {"id": "D3.2", "name": "晶圆代工稼动率（TSMC/SMIC）", "dimension": "D3", "keywords": ["TSMC utilization rate Q1 2026", "台积电 稼动率 2026年第一季度"]},
    {"id": "D3.3", "name": "半导体芯片行业库存周期", "dimension": "D3", "keywords": ["semiconductor inventory days 2026", "芯片库存天数 2026年3月"]},

    # D4 地缘政治与贸易政策风险
    {"id": "D4.1", "name": "出口管制/实体清单变化", "dimension": "D4", "keywords": ["US BIS entity list update 2026", "美国实体清单 最新 2026年3月"]},
    {"id": "D4.2", "name": "关税政策变化", "dimension": "D4", "keywords": ["US tariffs China 2026", "特朗普 关税政策 最新"]},
    {"id": "D4.3", "name": "关键区域冲突升级", "dimension": "D4", "keywords": ["Taiwan Strait tension 2026", "台海局势 最新 2026年3月"]},

    # D5 自然灾害与突发事件风险
    {"id": "D5.1", "name": "人祸事件（罢工/火灾/爆炸）", "dimension": "D5", "keywords": ["Chile copper mine strike 2026", "智利铜矿 罢工 最新"]},
    {"id": "D5.2", "name": "天灾气候与能源中断", "dimension": "D5", "keywords": ["China power rationing 2026", "四川限电 2026年3月"]},
    {"id": "D5.3", "name": "社会公共/卫生事件", "dimension": "D5", "keywords": ["WHO pandemic alert 2026", "世界卫生组织 公共卫生事件"]},

    # D6 物流运输风险
    {"id": "D6.1", "name": "海运成本指数（SCFI/WCI）", "dimension": "D6", "keywords": ["SCFI index March 2026", "上海出口集装箱运价指数 最新"]},
    {"id": "D6.2", "name": "关键咽喉点通行状态", "dimension": "D6", "keywords": ["Suez Canal shipping status 2026", "苏伊士运河 通行 最新"]},
    {"id": "D6.3", "name": "关键港口拥堵状态", "dimension": "D6", "keywords": ["Shanghai port congestion 2026", "上海洋山港 等泊时间"]},

    # D7 合规法规变化风险
    {"id": "D7.1", "name": "环保法规范围/要求变化", "dimension": "D7", "keywords": ["EU CBAM 2026 implementation", "欧盟碳边境调节机制 2026"]},
    {"id": "D7.2", "name": "产品认证范围/要求变化", "dimension": "D7", "keywords": ["UL certification new requirement 2026", "产品认证 强制 新增 2026"]},
    {"id": "D7.3", "name": "供应链尽调新规变化", "dimension": "D7", "keywords": ["EU CSDD directive 2026", "欧盟供应链尽职调查 2026"]},
]


def load_thresholds() -> Dict[str, Any]:
    """
    加载阈值定义（从 references/thresholds.md）
    返回结构化的阈值数据
    """
    # 这里简化处理，实际应该解析 thresholds.md
    # 返回示例结构
    return {
        "D1.1": {
            "green": "$8500-9500/吨",
            "yellow": "突破$10000",
            "red": "持续超$10500或单月波动>15%"
        },
        # ... 其他指标
    }


def generate_search_prompt(indicator: Dict[str, str]) -> str:
    """
    为单个指标生成搜索提示词
    """
    prompt = f"""
请搜索"{indicator['name']}"的最新数据（2026年3月）。

搜索关键词：
- {indicator['keywords'][0]}
- {indicator['keywords'][1]}

请提取以下关键信息：
1. 当前数据值
2. 与上期/历史均值的对比
3. 趋势判断（上升/下降/稳定）
4. 任何相关的预警信号或突发事件

请简洁回答，直接给出数据点和判断。
"""
    return prompt


def format_indicator_result(indicator: Dict[str, str], search_result: str) -> Dict[str, Any]:
    """
    格式化单个指标的搜索结果
    """
    return {
        "id": indicator["id"],
        "name": indicator["name"],
        "dimension": indicator["dimension"],
        "data": search_result,
        "status": "unknown",  # 需要基于阈值判断
        "timestamp": datetime.now().isoformat()
    }


def save_results(results: List[Dict[str, Any]], filename: str = "monitoring_results.json"):
    """
    保存监控结果到JSON文件
    """
    output = {
        "generated_at": datetime.now().isoformat(),
        "total_indicators": len(results),
        "summary": {
            "green": sum(1 for r in results if r.get("status") == "green"),
            "yellow": sum(1 for r in results if r.get("status") == "yellow"),
            "red": sum(1 for r in results if r.get("status") == "red"),
            "unknown": sum(1 for r in results if r.get("status") == "unknown"),
        },
        "indicators": results
    }

    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(output, f, ensure_ascii=False, indent=2)

    print(f"✅ 结果已保存到 {filename}")
    return output


def main():
    """
    主函数：执行监控流程
    """
    print("=" * 60)
    print("供应链风险监控 - 21项核心指标")
    print(f"执行时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 60)
    print()

    results = []

    # 注意：这个脚本需要被 OpenClaw 调用，通过 Tavily 工具进行搜索
    # 这里只是生成待搜索的指标列表
    print("📋 待监控指标列表：")
    for indicator in INDICATORS:
        print(f"  [{indicator['id']}] {indicator['name']} ({indicator['dimension']})")

    print()
    print("⚠️  这个脚本需要通过 OpenClaw 的 Tavily 工具执行搜索")
    print("⚠️  请使用主会话功能，而不是直接运行此脚本")
    print()
    print("建议工作流程：")
    print("1. 加载此 skill 的 SKILL.md")
    print("2. 用户请求：'监控本周供应链风险'")
    print("3. AI 自动调用 Tavily 搜索 21 项指标")
    print("4. 生成飞书文档报告")

    # 生成待搜索列表
    save_results(results, "indicator_list.json")


if __name__ == "__main__":
    main()
