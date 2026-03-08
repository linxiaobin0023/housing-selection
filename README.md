# 嘉禧苑选房系统

光明区第四批次保障性租赁住房选房系统 - PWA 渐进式 Web 应用

## 功能特性

- 📱 **PWA 应用** - 可添加到主屏幕，像原生应用一样使用
- 🔍 **房源筛选** - 按楼栋、楼层、房型筛选
- ⭐ **意向房型** - 标记意向房型，实时显示剩余数量
- 📊 **统计卡片** - 悬浮按钮显示全部/已选/剩余房源统计
- 📷 **OCR 识别** - 拍照识别已选房源（支持划掉标记识别）
- 💾 **离线访问** - 支持离线使用，无需网络
- 🔄 **自动更新** - 代码更新后自动同步

## 快速开始

### 方法一：一键部署（推荐）

```bash
# 进入项目目录
cd 选房系统

# 运行部署脚本
./deploy.sh
```

按提示操作即可自动部署到 GitHub Pages。

### 方法二：手动部署

#### 1. 创建 GitHub 仓库

1. 访问 https://github.com/new
2. 仓库名称：`housing-selection`
3. 选择 **Public**（公开）
4. 点击 **Create repository**

#### 2. 上传代码

```bash
# 初始化 Git
git init
git add .
git commit -m "Initial commit"

# 关联远程仓库（替换为你的用户名）
git remote add origin https://github.com/你的用户名/housing-selection.git
git push -u origin main
```

#### 3. 启用 GitHub Pages

1. 进入仓库 → **Settings** → **Pages**
2. **Source** 选择 **GitHub Actions**
3. 等待 1-2 分钟

#### 4. 访问应用

```
https://你的用户名.github.io/housing-selection/
```

## iPhone/iPad 安装指南

### 添加到主屏幕

1. **Safari 打开网站**
   ```
   https://你的用户名.github.io/housing-selection/
   ```

2. **点击分享按钮**（底部中间的 ⬆️）

3. **选择"添加到主屏幕"**
   
   ![添加到主屏幕](https://support.apple.com/library/content/dam/edam/applecare/images/en_US/iOS/ios15-iphone12-pro-safari-share-add-to-home-screen.png)

4. **点击"添加"**

5. **从主屏幕打开**
   - 现在它就像一个原生应用了！
   - 全屏显示，没有浏览器地址栏
   - 支持离线访问

### 效果预览

```
┌─────────────────┐
│   嘉禧苑选房    │  ← 主屏幕图标
│     🏠         │
└─────────────────┘
        ↓
┌─────────────────┐
│ 嘉禧苑选房系统  │  ← 全屏应用
│                 │
│  📊 房源统计    │
│                 │
│  [筛选栏]       │
│                 │
│  [房源列表]     │
│                 │
└─────────────────┘
```

## 项目结构

```
选房系统/
├── index.html          # 主页面
├── houses_data.json    # 房源数据
├── manifest.json       # PWA 配置
├── sw.js              # Service Worker（离线支持）
├── deploy.sh          # 一键部署脚本
├── .github/
│   └── workflows/
│       └── deploy.yml # GitHub Actions 自动部署
├── .gitignore         # Git 忽略配置
└── README.md          # 项目说明
```

## 技术栈

- **前端**: HTML5 + CSS3 + JavaScript (ES6+)
- **PWA**: Service Worker + Web App Manifest
- **OCR**: Tesseract.js
- **部署**: GitHub Pages + GitHub Actions

## 浏览器支持

- ✅ Safari (iOS/iPadOS 11+)
- ✅ Chrome (Android/Windows/macOS)
- ✅ Edge
- ✅ Firefox

## 更新日志

### v1.0.0
- ✨ 初始版本发布
- 🏠 房源列表展示
- 🔍 筛选功能
- ⭐ 意向房型标记
- 📊 统计功能
- 📷 OCR 识别
- 📱 PWA 支持

## 许可证

MIT License

## 技术支持

如有问题，请通过 GitHub Issues 反馈。
# Trigger redeploy
# Trigger redeploy
