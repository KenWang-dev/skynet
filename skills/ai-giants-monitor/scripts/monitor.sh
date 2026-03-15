#!/bin/bash
# AI 三巨头监控脚本
# 使用 Tavily 搜索 OpenAI、Anthropic、Google DeepMind 的最新动态

SKILL_DIR="$(dirname "$(dirname "$(realpath "$0")")")"
TAVILY_DIR="/root/.openclaw/workspace/skills/tavily-search"

echo "🔍 开始监控 AI 三巨头..."
echo ""

# 搜索 OpenAI
echo "📌 搜索 OpenAI..."
cd "$TAVILY_DIR" && node scripts/search.mjs "OpenAI GPT ChatGPT Sam Altman" --topic news --days 1 -n 10 > /tmp/openai-news.txt 2>&1
echo "✅ OpenAI 搜索完成"
echo ""

# 搜索 Anthropic
echo "📌 搜索 Anthropic..."
cd "$TAVILY_DIR" && node scripts/search.mjs "Anthropic Claude Dario Amodei" --topic news --days 1 -n 10 > /tmp/anthropic-news.txt 2>&1
echo "✅ Anthropic 搜索完成"
echo ""

# 搜索 Google DeepMind
echo "📌 搜索 Google DeepMind..."
cd "$TAVILY_DIR" && node scripts/search.mjs "Google DeepMind Gemini" --topic news --days 1 -n 10 > /tmp/google-news.txt 2>&1
echo "✅ Google DeepMind 搜索完成"
echo ""

echo "📊 所有搜索已完成，结果已保存到 /tmp/"
echo "- OpenAI: /tmp/openai-news.txt"
echo "- Anthropic: /tmp/anthropic-news.txt"
echo "- Google: /tmp/google-news.txt"
echo ""
echo "下一步：按照框架整理信息并生成报告"
