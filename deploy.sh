#!/bin/bash

# 嘉禧苑选房系统 - 一键部署脚本
# 自动部署到 GitHub Pages

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "╔════════════════════════════════════════╗"
echo "║     嘉禧苑选房系统 - 一键部署工具      ║"
echo "║         部署到 GitHub Pages            ║"
echo "╚════════════════════════════════════════╝"
echo -e "${NC}"

# 项目路径
PROJECT_PATH="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_PATH"

# 检查 Git
echo -e "${BLUE}🔍 检查环境...${NC}"
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ 错误：未安装 Git${NC}"
    echo "请访问 https://git-scm.com/ 安装 Git"
    exit 1
fi
echo -e "${GREEN}✅ Git 已安装${NC}"

# 获取 GitHub 用户名
echo ""
echo -e "${BLUE}📋 配置信息${NC}"
echo "─────────────────────────────────────"

# 检查是否已有远程仓库
HAS_REMOTE=false
if [ -d ".git" ]; then
    REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
    if [ -n "$REMOTE_URL" ]; then
        HAS_REMOTE=true
        echo -e "${GREEN}✅ 已关联远程仓库：${NC}$REMOTE_URL"
        REPO_NAME=$(basename -s .git "$REMOTE_URL")
        GITHUB_USER=$(echo "$REMOTE_URL" | sed -n 's/.*github.com[:/]\([^/]*\).*/\1/p')
    fi
fi

if [ "$HAS_REMOTE" = false ]; then
    # 需要创建新仓库
    echo -e "${YELLOW}⚠️  未关联远程仓库${NC}"
    echo ""
    
    # 循环直到输入有效用户名
    while true; do
        read -p "请输入你的 GitHub 用户名: " GITHUB_USER
        
        if [ -n "$GITHUB_USER" ]; then
            break
        fi
        
        echo -e "${RED}❌ 用户名不能为空，请重新输入${NC}"
    done
    
    read -p "请输入仓库名称 [默认: housing-selection]: " REPO_NAME
    REPO_NAME=${REPO_NAME:-housing-selection}
    
    echo ""
    echo -e "${YELLOW}请先在 GitHub 创建仓库：${NC}"
    echo ""
    echo "  1. 访问 https://github.com/new"
    echo "  2. 仓库名称: $REPO_NAME"
    echo "  3. 选择 Public（公开）"
    echo "  4. 点击 Create repository"
    echo ""
    echo "   或者点击这个链接快速创建："
    echo "   https://github.com/new?name=$REPO_NAME&visibility=public"
    echo ""
    read -p "创建完成后，按 Enter 键继续..."
fi

echo ""
echo -e "${BLUE}📦 准备部署文件...${NC}"
echo "─────────────────────────────────────"

# 初始化 Git（如果需要）
if [ ! -d ".git" ]; then
    echo "📝 初始化 Git 仓库..."
    git init
    git branch -m main 2>/dev/null || git checkout -b main
fi

# 配置 Git（如果未配置）
if ! git config user.email &> /dev/null; then
    echo "📝 配置 Git 用户信息..."
    git config user.email "deploy@housing-selection.app"
    git config user.name "Deploy Bot"
fi

# 添加所有文件
echo "📁 添加文件到 Git..."
git add .

# 检查是否有变更
if git diff --cached --quiet 2>/dev/null; then
    echo -e "${YELLOW}⚠️  没有需要提交的变更${NC}"
else
    # 提交
    echo "💾 提交变更..."
    git commit -m "Deploy: $(date '+%Y-%m-%d %H:%M:%S')"
    echo -e "${GREEN}✅ 提交成功${NC}"
fi

# 关联远程仓库（如果需要）
if [ "$HAS_REMOTE" = false ]; then
    echo "🔗 关联远程仓库..."
    git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"
fi

# 推送代码
echo ""
echo -e "${BLUE}🚀 推送到 GitHub...${NC}"
echo "─────────────────────────────────────"

if git push -u origin main; then
    echo -e "${GREEN}✅ 代码推送成功！${NC}"
else
    echo -e "${YELLOW}⚠️  推送失败，尝试强制推送...${NC}"
    git push -u origin main --force
fi

# 显示访问链接
echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           🎉 部署成功！                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📱 访问地址：${NC}"
echo "  https://$GITHUB_USER.github.io/$REPO_NAME/"
echo ""
echo -e "${BLUE}📋 下一步操作：${NC}"
echo "─────────────────────────────────────"
echo "1. 访问 GitHub 仓库"
echo "   https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""
echo "2. 进入 Settings → Pages"
echo "   Source 选择 'GitHub Actions'"
echo ""
echo "3. 等待 1-2 分钟，访问上面的链接"
echo ""
echo -e "${BLUE}📲 iPhone/iPad 安装：${NC}"
echo "─────────────────────────────────────"
echo "1. Safari 打开上面的链接"
echo "2. 点击底部'分享'按钮"
echo "3. 选择'添加到主屏幕'"
echo "4. 点击'添加'"
echo ""
echo -e "${GREEN}✨ 完成！现在可以从主屏幕打开应用了${NC}"
echo ""

# 询问是否打开浏览器
read -p "是否打开浏览器访问？ [y/N]: " open_browser
if [[ $open_browser =~ ^[Yy]$ ]]; then
    open "https://$GITHUB_USER.github.io/$REPO_NAME/"
fi
