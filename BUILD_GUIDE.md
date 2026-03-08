# 嘉禧苑选房系统 iOS 构建指南

## 项目概述

这是一个使用 Capacitor 打包的 iOS 应用，支持 iPhone 和 iPad 设备。

## 系统要求

- macOS 系统
- Xcode 14.0 或更高版本
- Node.js 16.0 或更高版本
- CocoaPods

## 快速开始

### 1. 安装依赖

```bash
npm install
```

### 2. 同步项目

```bash
npx cap sync
```

### 3. 打开 Xcode 项目

```bash
npx cap open ios
```

### 4. 在 Xcode 中构建

1. 选择目标设备（iPhone 或 iPad 模拟器/真机）
2. 点击运行按钮或按 Cmd+R

## 功能特性

### 已配置的原生功能

- ✅ 相机访问 - 用于 OCR 拍照识别
- ✅ 相册访问 - 用于上传房源照片
- ✅ 全屏显示 - 适配 iPhone 和 iPad
- ✅ 横竖屏支持 - 自动旋转适配

### 支持的设备

- iPhone (iOS 13.0+)
- iPad (iPadOS 13.0+)

### 屏幕方向

- 竖屏 (Portrait)
- 横屏 (Landscape Left/Right)
- iPad 支持倒置 (Upside Down)

## 应用信息

- **Bundle ID**: com.housing.selection
- **应用名称**: 嘉禧苑选房
- **版本**: 1.0.0

## 发布到 App Store

### 1. 配置签名

在 Xcode 中：
1. 选择项目 → Signing & Capabilities
2. 选择你的 Apple Developer 账号
3. 配置 Bundle Identifier

### 2. 归档构建

1. 选择 Generic iOS Device
2. Product → Archive
3. 等待构建完成

### 3. 上传到 App Store

1. Window → Organizer
2. 选择最新的 Archive
3. 点击 Distribute App
4. 选择 App Store Connect
5. 按照向导完成上传

## 项目结构

```
选房系统/
├── ios/                    # iOS 原生项目
│   └── App/
│       ├── App.xcodeproj   # Xcode 项目文件
│       └── App/
│           ├── Info.plist  # 应用配置
│           └── public/     # Web 资源
├── www/                    # Web 应用文件
│   ├── index.html
│   └── houses_data.json
├── package.json
└── capacitor.config.json   # Capacitor 配置
```

## 常见问题

### Q: 如何更新 Web 内容？

```bash
# 修改 www/ 目录下的文件
# 然后同步到 iOS 项目
npx cap copy ios
```

### Q: 如何添加新的原生插件？

```bash
npm install @capacitor/插件名
npx cap sync
```

### Q: 真机调试失败？

1. 确保 iPhone/iPad 已连接并信任此电脑
2. 在 Xcode 中选择你的设备
3. 确保 Apple ID 已配置

## 技术支持

如有问题，请检查：
1. Capacitor 文档：https://capacitorjs.com/docs
2. iOS 开发文档：https://developer.apple.com/documentation
