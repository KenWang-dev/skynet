#!/bin/bash
#############################################
# API Functions Library for OpenClaw
# Created: 2026-03-10
# Purpose: Unified API calling functions
# Usage: source this script in other scripts
#############################################

# Load API keys
API_KEYS_FILE="/root/.openclaw/.env.api-keys"
if [[ -f "$API_KEYS_FILE" ]]; then
    source "$API_KEYS_FILE"
else
    echo "⚠️  Warning: API keys file not found: $API_KEYS_FILE" >&2
fi

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log function
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

#############################################
# GDELT API Functions
# No API key required
#############################################

# GDELT: Search articles by query
# Usage: gdelt_search "query" max_records
# Returns: JSON format
gdelt_search() {
    local query="$1"
    local max_records="${2:-50}"
    local mode="ArtList"  # Article List mode

    local url="https://api.gdeltproject.org/api/v2/doc/doc"
    local full_url="${url}?query=${query}&mode=${mode}&maxrecords=${max_records}&format=json"

    log_info "Fetching GDELT data for query: $query"

    local response=$(curl -s "$full_url")

    if [[ $? -eq 0 ]]; then
        log_success "GDELT data fetched successfully"
        echo "$response"
    else
        log_error "Failed to fetch GDELT data"
        return 1
    fi
}

# GDELT: Get recent articles (last 15 minutes)
gdelt_recent() {
    gdelt_search "*.*" 25
}

#############################################
# Reddit API Functions (Public Data)
# No API key required for public data
#############################################

# Reddit: Get new posts from subreddit
# Usage: reddit_fetch "subreddit" limit
# Returns: JSON format
reddit_fetch() {
    local subreddit="$1"
    local limit="${2:-25}"

    local url="https://www.reddit.com/r/${subreddit}/new.json?limit=${limit}"

    log_info "Fetching Reddit data from r/${subreddit}"

    local response=$(curl -s -A "OpenClaw/1.0" "$url")

    if [[ $? -eq 0 ]]; then
        log_success "Reddit data fetched successfully"
        echo "$response"
    else
        log_error "Failed to fetch Reddit data"
        return 1
    fi
}

# Reddit: Search by keyword
# Usage: reddit_search "keyword" subreddit limit
reddit_search() {
    local keyword="$1"
    local subreddit="${2:-all}"
    local limit="${3:-25}"

    local url="https://www.reddit.com/r/${subreddit}/search.json?q=${keyword}&restrict_sr=on&limit=${limit}"

    log_info "Searching Reddit for: $keyword in r/${subreddit}"

    local response=$(curl -s -A "OpenClaw/1.0" "$url")

    if [[ $? -eq 0 ]]; then
        log_success "Reddit search completed"
        echo "$response"
    else
        log_error "Failed to search Reddit"
        return 1
    fi
}

#############################################
# GitHub API Functions (Public Data)
# No API key required for public data (60 req/hour)
# With API key: 5000 req/hour
#############################################

# GitHub: Get repository information
# Usage: github_repo "owner/repo"
github_repo() {
    local repo="$1"
    local auth=""

    if [[ -n "$GITHUB_TOKEN" ]]; then
        auth="-H \"Authorization: token $GITHUB_TOKEN\""
    fi

    local url="https://api.github.com/repos/${repo}"

    log_info "Fetching GitHub repo: $repo"

    local response=$(curl -s $auth "$url")

    if [[ $? -eq 0 ]]; then
        log_success "GitHub repo data fetched"
        echo "$response"
    else
        log_error "Failed to fetch GitHub repo"
        return 1
    fi
}

# GitHub: Search repositories
# Usage: github_search "query" sort
github_search() {
    local query="$1"
    local sort="${2:-stars}"
    local auth=""

    if [[ -n "$GITHUB_TOKEN" ]]; then
        auth="-H \"Authorization: token $GITHUB_TOKEN\""
    fi

    local url="https://api.github.com/search/repositories?q=${query}&sort=${sort}&order=desc&per_page=20"

    log_info "Searching GitHub for: $query"

    local response=$(curl -s $auth "$url")

    if [[ $? -eq 0 ]]; then
        log_success "GitHub search completed"
        echo "$response"
    else
        log_error "Failed to search GitHub"
        return 1
    fi
}

# GitHub: Get trending repositories
# Usage: github_trending "language" since
# language: any valid GitHub language (e.g., python, javascript)
# since: daily, weekly, monthly
github_trending() {
    local language="${1:-}"
    local since="${2:-daily}"

    # Note: GitHub doesn't have an official trending API
    # This uses an alternative approach with search
    local query="stars:>1000"

    if [[ -n "$language" ]]; then
        query="${query}+language:${language}"
    fi

    github_search "$query" "stars"
}

#############################################
# USGS API Functions
# No API key required
#############################################

# USGS: Get earthquake data
# Usage: usgs_earthquakes magnitude limit
# magnitude: minimum magnitude (e.g., 2.5, 4.5)
# limit: number of results
usgs_earthquakes() {
    local mag="${1:-2.5}"
    local limit="${2:-20}"

    local url="https://earthquake.usgs.gov/fdsnws/event/1/query?format=json&minmagnitude=${mag}&limit=${limit}&orderby=time"

    log_info "Fetching USGS earthquake data (mag >= ${mag})"

    local response=$(curl -s "$url")

    if [[ $? -eq 0 ]]; then
        log_success "USGS earthquake data fetched"
        echo "$response"
    else
        log_error "Failed to fetch USGS data"
        return 1
    fi
}

# USGS: Get minerals data
# Note: USGS has multiple APIs, this is a placeholder
usgs_minerals() {
    log_warning "USGS minerals API requires specific endpoint"
    log_info "Visit: https://mrdata.usgs.gov/"
}

#############################################
# Tushare API Functions
# Requires TUSHARE_API_TOKEN
#############################################

# Tushare: Get stock基本信息
# Usage: tushare_stock_info "stock_code"
tushare_stock_info() {
    local ts_code="$1"

    if [[ -z "$TUSHARE_API_TOKEN" ]] || [[ "$TUSHARE_API_TOKEN" == "your_token_here" ]]; then
        log_error "Tushare API token not configured"
        log_info "Please set TUSHARE_API_TOKEN in /root/.openclaw/.env.api-keys"
        return 1
    fi

    local api_name="stock_basic"
    local params="ts_code=${ts_code}"
    local url="http://api.tushare.pro"
    local data="{\"api_name\":\"${api_name}\",\"token\":\"${TUSHARE_API_TOKEN}\",\"params\":\"${params}\",\"fields\":\"\"}"

    log_info "Fetching Tushare stock info: ${ts_code}"

    local response=$(curl -s -X POST "$url" -H "Content-Type: application/json" -d "$data")

    if [[ $? -eq 0 ]]; then
        log_success "Tushare data fetched"
        echo "$response"
    else
        log_error "Failed to fetch Tushare data"
        return 1
    fi
}

# Tushare: Get daily stock price
# Usage: tushare_daily "stock_code" "start_date" "end_date"
tushare_daily() {
    local ts_code="$1"
    local start_date="${2:-20200101}"
    local end_date="${3:-$(date +%Y%m%d)}"

    if [[ -z "$TUSHARE_API_TOKEN" ]] || [[ "$TUSHARE_API_TOKEN" == "your_token_here" ]]; then
        log_error "Tushare API token not configured"
        return 1
    fi

    local api_name="daily"
    local params="ts_code=${ts_code},start_date=${start_date},end_date=${end_date}"
    local url="http://api.tushare.pro"
    local data="{\"api_name\":\"${api_name}\",\"token\":\"${TUSHARE_API_TOKEN}\",\"params\":\"${params}\",\"fields\":\"\"}"

    log_info "Fetching Tushare daily data: ${ts_code}"

    local response=$(curl -s -X POST "$url" -H "Content-Type: application/json" -d "$data")

    if [[ $? -eq 0 ]]; then
        log_success "Tushare daily data fetched"
        echo "$response"
    else
        log_error "Failed to fetch Tushare daily data"
        return 1
    fi
}

#############################################
# News API Functions
# Requires NEWS_API_KEY
#############################################

# News API: Get top headlines
# Usage: news_headlines "country" "category"
news_headlines() {
    local country="${1:-us}"
    local category="${2:-technology}"

    if [[ -z "$NEWS_API_KEY" ]] || [[ "$NEWS_API_KEY" == "your_key_here" ]]; then
        log_error "News API key not configured"
        log_info "Please set NEWS_API_KEY in /root/.openclaw/.env.api-keys"
        return 1
    fi

    local url="https://newsapi.org/v2/top-headlines?country=${country}&category=${category}&apiKey=${NEWS_API_KEY}"

    log_info "Fetching news headlines: ${country}/${category}"

    local response=$(curl -s "$url")

    if [[ $? -eq 0 ]]; then
        log_success "News headlines fetched"
        echo "$response"
    else
        log_error "Failed to fetch news headlines"
        return 1
    fi
}

# News API: Search everything
# Usage: news_search "query" "from_date" "to_date"
news_search() {
    local query="$1"
    local from="${2:-$(date -d '7 days ago' +%Y-%m-%d)}"
    local to="${3:-$(date +%Y-%m-%d)}"

    if [[ -z "$NEWS_API_KEY" ]] || [[ "$NEWS_API_KEY" == "your_key_here" ]]; then
        log_error "News API key not configured"
        return 1
    fi

    local url="https://newsapi.org/v2/everything?q=${query}&from=${from}&to=${to}&sortBy=publishedAt&apiKey=${NEWS_API_KEY}"

    log_info "Searching news: ${query}"

    local response=$(curl -s "$url")

    if [[ $? -eq 0 ]]; then
        log_success "News search completed"
        echo "$response"
    else
        log_error "Failed to search news"
        return 1
    fi
}

#############################################
# Trading Economics API Functions
# Requires TRADING_ECONOMICS_KEY
#############################################

# Trading Economics: Get country data
# Usage: te_country "country_code"
te_country() {
    local country="$1"

    if [[ -z "$TRADING_ECONOMICS_KEY" ]] || [[ "$TRADING_ECONOMICS_KEY" == "your_key_here" ]]; then
        log_error "Trading Economics key not configured"
        return 1
    fi

    local url="https://api.tradingeconomics.com/country/${country}?c=${TRADING_ECONOMICS_KEY}&f=json"

    log_info "Fetching TE data for: ${country}"

    local response=$(curl -s "$url")

    if [[ $? -eq 0 ]]; then
        log_success "Trading Economics data fetched"
        echo "$response"
    else
        log_error "Failed to fetch TE data"
        return 1
    fi
}

# Trading Economics: Get economic calendar
te_calendar() {
    if [[ -z "$TRADING_ECONOMICS_KEY" ]] || [[ "$TRADING_ECONOMICS_KEY" == "your_key_here" ]]; then
        log_error "Trading Economics key not configured"
        return 1
    fi

    local url="https://api.tradingeconomics.com/calendar?c=${TRADING_ECONOMICS_KEY}&f=json"

    log_info "Fetching TE economic calendar"

    local response=$(curl -s "$url")

    if [[ $? -eq 0 ]]; then
        log_success "TE calendar fetched"
        echo "$response"
    else
        log_error "Failed to fetch TE calendar"
        return 1
    fi
}

#############################################
# Utility Functions
#############################################

# Test all configured APIs
test_all_apis() {
    log_info "Testing all API connections..."

    echo -e "\n=== GDELT (No key required) ==="
    gdelt_recent > /dev/null 2>&1 && echo "✅ GDELT: OK" || echo "❌ GDELT: FAILED"

    echo -e "\n=== Reddit (No key required) ==="
    reddit_fetch "python" 5 > /dev/null 2>&1 && echo "✅ Reddit: OK" || echo "❌ Reddit: FAILED"

    echo -e "\n=== GitHub (No key required) ==="
    github_repo "openai/openai-quickstart-python" > /dev/null 2>&1 && echo "✅ GitHub: OK" || echo "❌ GitHub: FAILED"

    echo -e "\n=== USGS (No key required) ==="
    usgs_earthquakes 2.5 5 > /dev/null 2>&1 && echo "✅ USGS: OK" || echo "❌ USGS: FAILED"

    echo -e "\n=== Tushare (Requires key) ==="
    if [[ -n "$TUSHARE_API_TOKEN" ]] && [[ "$TUSHARE_API_TOKEN" != "your_token_here" ]]; then
        tushare_stock_info "000001.SZ" > /dev/null 2>&1 && echo "✅ Tushare: OK" || echo "❌ Tushare: FAILED"
    else
        echo "⚠️  Tushare: Key not configured"
    fi

    echo -e "\n=== News API (Requires key) ==="
    if [[ -n "$NEWS_API_KEY" ]] && [[ "$NEWS_API_KEY" != "your_key_here" ]]; then
        news_headlines "us" "technology" > /dev/null 2>&1 && echo "✅ News API: OK" || echo "❌ News API: FAILED"
    else
        echo "⚠️  News API: Key not configured"
    fi

    echo -e "\n=== Trading Economics (Requires key) ==="
    if [[ -n "$TRADING_ECONOMICS_KEY" ]] && [[ "$TRADING_ECONOMICS_KEY" != "your_key_here" ]]; then
        te_country "china" > /dev/null 2>&1 && echo "✅ Trading Economics: OK" || echo "❌ Trading Economics: FAILED"
    else
        echo "⚠️  Trading Economics: Key not configured"
    fi

    echo ""
}

# Export functions
export -f log_info log_success log_warning log_error
export -f gdelt_search gdelt_recent
export -f reddit_fetch reddit_search
export -f github_repo github_search github_trending
export -f usgs_earthquakes usgs_minerals
export -f tushare_stock_info tushare_daily
export -f news_headlines news_search
export -f te_country te_calendar
export -f test_all_apis
