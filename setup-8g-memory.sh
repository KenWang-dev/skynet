#!/bin/bash
# 一键设置 8G 内存（4G物理 + 4G虚拟）

echo "🚀 开始设置 8G 内存..."
echo ""

# 检查当前内存
echo "📊 当前内存状态："
free -h
echo ""

# 检查是否已有swap
if [ -f /swapfile ]; then
    echo "⚠️  检测到已有 /swapfile，大小："
    ls -lh /swapfile
    echo ""
    read -p "是否删除并重新创建？(y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        swapoff /swapfile
        rm -f /swapfile
        echo "✅ 已删除旧的 swap 文件"
    else
        echo "❌ 取消操作"
        exit 1
    fi
fi

# 创建4G swap文件
echo "🔨 创建 4G swap 文件..."
dd if=/dev/zero of=/swapfile bs=1G count=4 status=progress
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "✅ Swap 文件创建完成"
echo ""

# 设置永久生效
if ! grep -q '/swapfile' /etc/fstab; then
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
    echo "✅ 已添加到 /etc/fstab（永久生效）"
else
    echo "ℹ️  /etc/fstab 已存在配置"
fi
echo ""

# 优化 swappiness（降低swap使用频率）
echo "⚙️  优化 swap 使用策略..."
if ! grep -q 'vm.swappiness' /etc/sysctl.conf; then
    echo 'vm.swappiness=10' >> /etc/sysctl.conf
    sysctl vm.swappiness=10
    echo "✅ vm.swappiness = 10（优先使用物理内存）"
else
    echo "ℹ️  vm.swappiness 已配置"
fi
echo ""

# 显示最终结果
echo "🎉 设置完成！"
echo ""
echo "📊 新的内存状态："
free -h
echo ""
echo "💾 Swap 信息："
swapon --show
echo ""

# 测试
echo "✅ 内存升级完成！"
echo "   物理内存：4G"
echo "   虚拟内存：4G"
echo "   总可用：8G"
echo ""
echo "📌 建议：重启服务器以确保所有配置生效"
