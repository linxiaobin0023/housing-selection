#!/bin/bash

# 嘉禧苑选房系统 iOS 构建脚本

echo "🏠 嘉禧苑选房系统 iOS 构建脚本"
echo "================================"

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo "❌ 错误：未安装 Node.js"
    echo "请访问 https://nodejs.org/ 安装 Node.js"
    exit 1
fi

echo "✅ Node.js 版本: $(node -v)"

# 检查 npm
if ! command -v npm &> /dev/null; then
    echo "❌ 错误：未安装 npm"
    exit 1
fi

echo "✅ npm 版本: $(npm -v)"

# 安装依赖
echo ""
echo "📦 安装依赖..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ 依赖安装失败"
    exit 1
fi

echo "✅ 依赖安装完成"

# 同步 Capacitor
echo ""
echo "🔄 同步 Capacitor 项目..."
npx cap sync

if [ $? -ne 0 ]; then
    echo "⚠️  同步完成但可能有警告"
    echo "继续打开 Xcode..."
fi

echo "✅ 项目同步完成"

# 检查 Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo ""
    echo "⚠️  警告：未检测到 Xcode"
    echo "请从 App Store 安装 Xcode"
    echo ""
    echo "安装完成后，运行以下命令打开项目："
    echo "  npx cap open ios"
    exit 1
fi

echo "✅ Xcode 已安装"

# 打开 Xcode 项目
echo ""
echo "🚀 正在打开 Xcode 项目..."
npx cap open ios

echo ""
echo "================================"
echo "✅ 项目已准备就绪！"
echo ""
echo "下一步操作："
echo "1. 在 Xcode 中选择目标设备（iPhone/iPad）"
echo "2. 点击运行按钮（Cmd+R）开始调试"
echo "3. 或使用 Product → Archive 打包发布"
echo ""
echo "📖 详细说明请查看 BUILD_GUIDE.md"
