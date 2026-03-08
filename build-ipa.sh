#!/bin/bash

# 嘉禧苑选房系统 IPA 打包脚本
# 用于生成可直接安装的 .ipa 文件

set -e

echo "🏠 嘉禧苑选房系统 IPA 打包工具"
echo "================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 项目路径
PROJECT_PATH="$(cd "$(dirname "$0")" && pwd)"
IOS_PATH="$PROJECT_PATH/ios/App"
BUILD_PATH="$PROJECT_PATH/build"
ARCHIVE_PATH="$BUILD_PATH/嘉禧苑选房.xcarchive"
IPA_PATH="$BUILD_PATH/嘉禧苑选房.ipa"

# 检查 Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}❌ 错误：未安装 Xcode${NC}"
    echo "请从 App Store 安装 Xcode"
    exit 1
fi

echo -e "${GREEN}✅ Xcode 已安装${NC}"

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ 错误：未安装 Node.js${NC}"
    exit 1
fi

# 安装依赖
echo ""
echo "📦 安装依赖..."
cd "$PROJECT_PATH"
npm install

# 同步 Web 资源
echo ""
echo "🔄 同步 Web 资源..."
npx cap copy ios

# 创建构建目录
mkdir -p "$BUILD_PATH"

# 检查是否配置了签名
echo ""
echo "🔐 检查签名配置..."

# 获取可用的签名身份
SIGNING_IDENTITIES=$(security find-identity -v -p codesigning 2>/dev/null | grep "iPhone" | awk -F '"' '{print $2}')

if [ -z "$SIGNING_IDENTITIES" ]; then
    echo -e "${YELLOW}⚠️  警告：未找到 iPhone 开发者签名${NC}"
    echo ""
    echo "请选择打包方式："
    echo "1) 使用个人账号签名（需要 Apple ID）"
    echo "2) 使用自动签名（Xcode 管理）"
    echo "3) 仅构建模拟器版本（无需签名）"
    echo ""
    read -p "请选择 [1/2/3]: " choice
    
    case $choice in
        1)
            echo "请先在 Xcode 中配置个人账号签名"
            echo "打开 Xcode → Preferences → Accounts → 添加 Apple ID"
            exit 1
            ;;
        2)
            AUTO_SIGN=true
            ;;
        3)
            BUILD_SIMULATOR=true
            ;;
        *)
            echo "无效选择"
            exit 1
            ;;
    esac
else
    echo -e "${GREEN}✅ 找到以下签名身份：${NC}"
    echo "$SIGNING_IDENTITIES"
    AUTO_SIGN=true
fi

# 构建项目
echo ""
echo "🔨 开始构建..."

cd "$IOS_PATH"

if [ "$BUILD_SIMULATOR" = true ]; then
    # 构建模拟器版本
    echo "📱 构建模拟器版本..."
    
    xcodebuild clean build \
        -workspace App.xcworkspace \
        -scheme App \
        -sdk iphonesimulator \
        -configuration Release \
        -derivedDataPath "$BUILD_PATH/DerivedData" \
        CODE_SIGNING_ALLOWED=NO
    
    # 查找生成的 app
    APP_PATH=$(find "$BUILD_PATH/DerivedData" -name "App.app" -type d | head -n 1)
    
    if [ -z "$APP_PATH" ]; then
        echo -e "${RED}❌ 未找到构建产物${NC}"
        exit 1
    fi
    
    # 打包为 IPA（模拟器版本）
    echo "📦 打包 IPA..."
    mkdir -p "$BUILD_PATH/Payload"
    cp -r "$APP_PATH" "$BUILD_PATH/Payload/"
    cd "$BUILD_PATH"
    zip -r "嘉禧苑选房-模拟器.ipa" Payload
    rm -rf Payload
    
    echo -e "${GREEN}✅ 模拟器 IPA 构建成功！${NC}"
    echo "📁 文件位置: $BUILD_PATH/嘉禧苑选房-模拟器.ipa"
    
else
    # 构建真机版本
    echo "📱 构建真机版本..."
    
    # 清理之前的构建
    rm -rf "$ARCHIVE_PATH"
    
    # 归档构建
    if [ "$AUTO_SIGN" = true ]; then
        # 使用自动签名
        xcodebuild clean archive \
            -workspace App.xcworkspace \
            -scheme App \
            -configuration Release \
            -archivePath "$ARCHIVE_PATH" \
            -destination generic/platform=iOS \
            CODE_SIGN_STYLE=Automatic \
            DEVELOPMENT_TEAM="" \
            || {
                echo -e "${YELLOW}⚠️  自动签名失败，尝试使用临时签名...${NC}"
                xcodebuild clean archive \
                    -workspace App.xcworkspace \
                    -scheme App \
                    -configuration Release \
                    -archivePath "$ARCHIVE_PATH" \
                    -destination generic/platform=iOS \
                    CODE_SIGN_IDENTITY="iPhone Developer" \
                    DEVELOPMENT_TEAM=""
            }
    else
        # 使用指定签名
        xcodebuild clean archive \
            -workspace App.xcworkspace \
            -scheme App \
            -configuration Release \
            -archivePath "$ARCHIVE_PATH" \
            -destination generic/platform=iOS
    fi
    
    if [ ! -d "$ARCHIVE_PATH" ]; then
        echo -e "${RED}❌ 归档构建失败${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ 归档构建成功${NC}"
    
    # 创建导出选项
    EXPORT_OPTIONS="$BUILD_PATH/ExportOptions.plist"
    cat > "$EXPORT_OPTIONS" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>development</string>
    <key>teamID</key>
    <string></string>
    <key>uploadSymbols</key>
    <false/>
    <key>uploadBitcode</key>
    <false/>
    <key>compileBitcode</key>
    <false/>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>stripSwiftSymbols</key>
    <true/>
</dict>
</plist>
EOF
    
    # 导出 IPA
    echo ""
    echo "📦 导出 IPA 文件..."
    
    xcodebuild -exportArchive \
        -archivePath "$ARCHIVE_PATH" \
        -exportPath "$BUILD_PATH" \
        -exportOptionsPlist "$EXPORT_OPTIONS" \
        || {
            echo -e "${YELLOW}⚠️  导出失败，尝试其他方法...${NC}"
            
            # 手动打包
            APP_PATH="$ARCHIVE_PATH/Products/Applications/App.app"
            if [ -d "$APP_PATH" ]; then
                mkdir -p "$BUILD_PATH/Payload"
                cp -r "$APP_PATH" "$BUILD_PATH/Payload/"
                cd "$BUILD_PATH"
                zip -r "嘉禧苑选房.ipa" Payload
                rm -rf Payload
            else
                echo -e "${RED}❌ 未找到应用文件${NC}"
                exit 1
            fi
        }
    
    # 查找生成的 IPA
    IPA_FILE=$(find "$BUILD_PATH" -name "*.ipa" -type f | head -n 1)
    
    if [ -n "$IPA_FILE" ]; then
        # 重命名为标准名称
        if [ "$IPA_FILE" != "$IPA_PATH" ]; then
            mv "$IPA_FILE" "$IPA_PATH"
        fi
        
        echo ""
        echo -e "${GREEN}================================${NC}"
        echo -e "${GREEN}✅ IPA 打包成功！${NC}"
        echo -e "${GREEN}================================${NC}"
        echo ""
        echo "📁 文件位置: $IPA_PATH"
        echo "📱 文件大小: $(du -h "$IPA_PATH" | cut -f1)"
        echo ""
        echo "安装方法："
        echo "1. 使用 Apple Configurator 2 安装"
        echo "2. 使用 Xcode → Window → Devices and Simulators"
        echo "3. 使用第三方工具（如 iMazing、爱思助手）"
        echo "4. 上传到 TestFlight 或 App Store"
        echo ""
    else
        echo -e "${RED}❌ 未找到 IPA 文件${NC}"
        exit 1
    fi
fi

# 清理临时文件
echo "🧹 清理临时文件..."
rm -rf "$EXPORT_OPTIONS"

echo ""
echo "🎉 打包完成！"
