#!/bin/bash
#############################################
# API Integration Test Script
# Created: 2026-03-10
# Purpose: Test all API connections
# Usage: bash /root/.openclaw/workspace/scripts/test-apis.sh
#############################################

# Source API functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/api-functions.sh"

echo "============================================"
echo "OpenClaw API Integration Test"
echo "============================================"
echo "Test Time: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# Run API tests
test_all_apis

echo "============================================"
echo "Test Summary:"
echo "- Green APIs: Ready to use"
echo "- Yellow APIs: Need configuration (API keys)"
echo "- Red APIs: Connection failed"
echo ""
echo "Next Steps:"
echo "1. For yellow APIs: Add API keys to /root/.openclaw/.env.api-keys"
echo "2. For red APIs: Check network connection or API status"
echo "============================================"
