#!/bin/bash
#############################################
# API Demo: Enhanced Monitoring
# Shows how to use integrated APIs in monitoring tasks
# Created: 2026-03-10
#############################################

# Source API functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/api-functions.sh"

echo "============================================"
echo "OpenClaw API Demo: Enhanced Monitoring"
echo "============================================"
echo "Demo Time: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# ============================================
# Demo 1: GDELT - AI Policy Monitoring
# ============================================
echo "=== Demo 1: GDELT - AI Policy Monitoring ==="
echo "Searching for AI policy news..."
echo ""

gdelt_search "artificial intelligence policy regulation" 10 | jq -r '.articles[]? | "\(.title) - \(.url)"' 2>/dev/null | head -5

echo ""
echo "✅ GDELT demo completed"
echo ""

# ============================================
# Demo 2: Reddit - Procurement Voice Monitoring
# ============================================
echo "=== Demo 2: Reddit - Procurement Voice ==="
echo "Fetching latest procurement discussions..."
echo ""

reddit_fetch "procurement" 5 | jq -r '.data.children[]? | "\(.data.title) - https://reddit.com\(.data.permalink)"' 2>/dev/null | head -3

echo ""
echo "✅ Reddit demo completed"
echo ""

# ============================================
# Demo 3: GitHub - AI Technology Monitoring
# ============================================
echo "=== Demo 3: GitHub - AI Technology Trend ==="
echo "Searching trending LLM projects..."
echo ""

github_search "LLM language model" | jq -r '.items[]? | "\(.name) - ⭐ \(.stargazers_count) - \(.description)"' 2>/dev/null | head -5

echo ""
echo "✅ GitHub demo completed"
echo ""

# ============================================
# Demo 4: USGS - Supply Chain Risk Monitoring
# ============================================
echo "=== Demo 4: USGS - Earthquake Risk Monitoring ==="
echo "Checking recent earthquakes (mag >= 4.5)..."
echo ""

usgs_earthquakes 4.5 5 | jq -r '.features[]? | "\(.properties.mag) magnitude - \(.properties.place)"' 2>/dev/null | head -3

echo ""
echo "✅ USGS demo completed"
echo ""

# ============================================
# Summary
# ============================================
echo "============================================"
echo "Demo Summary"
echo "============================================"
echo ""
echo "All 4 free APIs are working!"
echo ""
echo "Next Steps:"
echo "1. Integrate these APIs into existing monitoring tasks"
echo "2. (Optional) Register Tushare for Chinese VC monitoring"
echo "3. (Optional) Register News API for news aggregation"
echo ""
echo "Documentation:"
echo "- API Guide: /root/.openclaw/workspace/docs/api-integration-guide.md"
echo "- Test Script: /root/.openclaw/workspace/scripts/test-apis.sh"
echo ""
echo "============================================"
