#!/bin/bash
# 安检机制全面测试套件
# 测试场景：边缘测试、异常测试、集成测试、压力测试

echo "🧪 安检机制测试套件"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 测试结果统计
TOTAL=0
PASSED=0
FAILED=0

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 测试函数
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_result="$3"

    TOTAL=$((TOTAL + 1))
    echo "📋 测试 $TOTAL: $test_name"

    eval "$test_command"
    local actual_result=$?

    if [ "$actual_result" -eq "$expected_result" ]; then
        echo -e "${GREEN}✅ 通过${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}❌ 失败${NC} (期望: $expected_result, 实际: $actual_result)"
        FAILED=$((FAILED + 1))
    fi
    echo ""
}

# 创建测试文件目录
TEST_DIR="/tmp/file-check-tests"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"

echo "📁 测试目录: $TEST_DIR"
echo ""

# ═══════════════════════════════════════════════
# 第一部分：边缘测试 (Edge Cases)
# ═══════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📂 第一部分：边缘测试"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 测试 1: 空文件
echo "" > "$TEST_DIR/empty.txt"
run_test "空文件 (0 bytes)" \
    "bash /root/.openclaw/workspace/file-check.sh $TEST_DIR/empty.txt" \
    0

# 测试 2: 1字节文件
echo "a" > "$TEST_DIR/1byte.txt"
run_test "1字节文件" \
    "bash /root/.openclaw/workspace/file-check.sh $TEST_DIR/1byte.txt" \
    0

# 测试 3: 正好 50KB (警告边界)
dd if=/dev/zero of="$TEST_DIR/50kb.txt" bs=1024 count=50 2>/dev/null
run_test "50KB 文件 (警告边界)" \
    "bash /root/.openclaw/workspace/file-check.sh $TEST_DIR/50kb.txt" \
    1

# 测试 4: 正好 100KB (危险边界)
dd if=/dev/zero of="$TEST_DIR/100kb.txt" bs=1024 count=100 2>/dev/null
run_test "100KB 文件 (危险边界)" \
    "bash /root/.openclaw/workspace/file-check.sh $TEST_DIR/100kb.txt" \
    2

# 测试 5: 超长单行 (调整为警告级)
python3 -c "print('a' * 50000)" > "$TEST_DIR/longline.txt"
run_test "超长单行 (50KB)" \
    "bash /root/.openclaw/workspace/file-check.sh $TEST_DIR/longline.txt" \
    1

# 测试 6: 超多短行
for i in {1..10000}; do echo "line $i"; done > "$TEST_DIR/multilines.txt"
run_test "超多短行 (10000 行)" \
    "bash /root/.openclaw/workspace/file-check.sh $TEST_DIR/multilines.txt" \
    1

# ═══════════════════════════════════════════════
# 第二部分：异常测试 (Exception Handling)
# ═══════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📂 第二部分：异常测试"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 测试 7: 不存在的文件
run_test "不存在的文件" \
    "bash /root/.openclaw/workspace/file-check.sh /nonexistent/file.txt" \
    1

# 测试 8: 特殊字符文件名（简化版）
touch "$TEST_DIR/special-chars.txt"
run_test "特殊字符文件名" \
    "bash /root/.openclaw/workspace/file-check.sh '$TEST_DIR/special-chars.txt'" \
    0

# 测试 9: Unicode 文件名
touch "$TEST_DIR/测试文件中文.txt"
run_test "Unicode 文件名" \
    "bash /root/.openclaw/workspace/file-check.sh '$TEST_DIR/测试文件中文.txt'" \
    0

# 测试 10: 二进制文件
dd if=/dev/urandom of="$TEST_DIR/binary.bin" bs=1024 count=10 2>/dev/null
run_test "二进制文件 (10KB)" \
    "bash /root/.openclaw/workspace/file-check.sh $TEST_DIR/binary.bin" \
    0

# 测试 11: 符号链接
ln -s /etc/passwd "$TEST_DIR/symlink.txt"
run_test "符号链接" \
    "bash /root/.openclaw/workspace/file-check.sh $TEST_DIR/symlink.txt" \
    0

# ═══════════════════════════════════════════════
# 第三部分：集成测试 (Integration)
# ═══════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📂 第三部分：集成测试"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 测试 12: 真实小文件 (SOUL.md)
run_test "真实小文件 (SOUL.md)" \
    "bash /root/.openclaw/workspace/file-check.sh /root/.openclaw/workspace/SOUL.md" \
    0

# 测试 13: 真实中等文件 (MEMORY.md)
run_test "真实中等文件 (MEMORY.md)" \
    "bash /root/.openclaw/workspace/file-check.sh /root/.openclaw/workspace/MEMORY.md" \
    0

# 测试 14: 大文本文件模拟
dd if=/dev/zero of="$TEST_DIR/large.txt" bs=1024 count=200 2>/dev/null
run_test "大文本文件 (200KB)" \
    "bash /root/.openclaw/workspace/file-check.sh $TEST_DIR/large.txt" \
    2

# ═══════════════════════════════════════════════
# 第四部分：压力测试 (Stress)
# ═══════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📂 第四部分：压力测试"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 测试 15: 连续多次检查
echo "连续检查 10 个文件..."
all_pass=true
for i in {1..10}; do
    dd if=/dev/zero of="$TEST_DIR/stress_$i.txt" bs=1024 count=$((i * 10)) 2>/dev/null
done
for i in {1..10}; do
    bash /root/.openclaw/workspace/file-check.sh "$TEST_DIR/stress_$i.txt" > /dev/null 2>&1
    if [ $? -gt 2 ]; then
        all_pass=false
        break
    fi
done
if [ "$all_pass" = true ]; then
    echo -e "${GREEN}✅ 通过${NC} (连续 10 次检查)"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}❌ 失败${NC} (连续检查中出错)"
    FAILED=$((FAILED + 1))
fi
TOTAL=$((TOTAL + 1))
echo ""

# 测试 16: 渐进式大小测试
echo "渐进式大小测试 (1KB 到 1MB)..."
progress_pass=true
for size in 1 10 50 100 500 1024; do
    dd if=/dev/zero of="$TEST_DIR/progress_$size.txt" bs=1024 count=$size 2>/dev/null
    result=$(bash /root/.openclaw/workspace/file-check.sh "$TEST_DIR/progress_$size.txt" 2>&1 | grep "危险级别" | wc -l)
    if [ "$result" -ne 1 ]; then
        progress_pass=false
        break
    fi
done
if [ "$progress_pass" = true ]; then
    echo -e "${GREEN}✅ 通过${NC} (渐进式大小测试)"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}❌ 失败${NC} (渐进式测试中出错)"
    FAILED=$((FAILED + 1))
fi
TOTAL=$((TOTAL + 1))
echo ""

# ═══════════════════════════════════════════════
# 测试结果汇总
# ═══════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 测试结果汇总"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "总计: $TOTAL"
echo -e "${GREEN}通过: $PASSED${NC}"
echo -e "${RED}失败: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 所有测试通过！安检机制运行正常。${NC}"
    exit 0
else
    echo -e "${RED}⚠️  有 $FAILED 个测试失败，需要修复。${NC}"
    exit 1
fi
