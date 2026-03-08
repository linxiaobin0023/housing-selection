# 嘉禧苑选房系统部署指南

## 方式一：PWA 渐进式 Web 应用（推荐 ⭐）

### 特点
- ✅ 无需 App Store 审核
- ✅ 无需开发者账号
- ✅ 可添加到主屏幕
- ✅ 支持离线访问
- ✅ 自动更新

### iPhone/iPad 安装步骤

#### 方法一：Safari 添加到主屏幕

1. **用 Safari 打开网站**
   ```
   https://你的用户名.github.io/选房系统/
   ```

2. **点击分享按钮**（底部中间）

3. **选择"添加到主屏幕"**
   
4. **点击"添加"**

5. **从主屏幕打开应用**
   - 现在它就像一个原生应用了！
   - 全屏显示，没有浏览器地址栏

#### 方法二：扫描二维码

1. 生成二维码（使用任意二维码生成器）
2. 用 iPhone/iPad 相机扫描
3. 在 Safari 中打开
4. 添加到主屏幕

---

## 方式二：GitHub Pages 部署（免费）

### 步骤 1：创建 GitHub 仓库

1. 登录 GitHub
2. 创建新仓库，命名为 `housing-selection`
3. 设置为 Public（公开）

### 步骤 2：上传代码

```bash
# 在项目目录执行
cd "/Users/linxiaobin/Desktop/选房系统"

# 初始化 Git
git init
git add .
git commit -m "Initial commit"

# 关联远程仓库（替换为你的用户名）
git remote add origin https://github.com/你的用户名/housing-selection.git

# 推送代码
git push -u origin main
```

### 步骤 3：启用 GitHub Pages

1. 进入仓库 → Settings → Pages
2. Source 选择 "Deploy from a branch"
3. Branch 选择 "main"，文件夹选择 "/ (root)"
4. 点击 Save
5. 等待几分钟，访问提供的链接

### 访问地址

```
https://你的用户名.github.io/housing-selection/
```

---

## 方式三：Vercel 部署（推荐）

### 特点
- 自动部署
- 全球 CDN
- 自定义域名

### 步骤

1. 注册 Vercel 账号（用 GitHub 登录）
2. 点击 "New Project"
3. 导入 GitHub 仓库
4. 框架预设选择 "Other"
5. 点击 Deploy

### 访问地址

```
https://你的项目名.vercel.app
```

---

## 方式四：Netlify 部署

### 步骤

1. 注册 Netlify 账号
2. 拖拽项目文件夹到 Netlify 网站
3. 自动获得访问链接

---

## 方式五：自己的服务器

### 使用 Nginx

```nginx
server {
    listen 80;
    server_name housing.yourdomain.com;
    
    location / {
        root /var/www/housing-selection;
        index index.html;
        try_files $uri $uri/ /index.html;
    }
}
```

---

## iOS 设备访问方式对比

| 方式 | 难度 | 成本 | 体验 | 推荐度 |
|------|------|------|------|--------|
| **PWA** | ⭐ 简单 | 免费 | 接近原生 | ⭐⭐⭐⭐⭐ |
| **Web 直接访问** | ⭐ 简单 | 免费 | 一般 | ⭐⭐⭐ |
| **TestFlight** | ⭐⭐ 中等 | $99/年 | 原生 | ⭐⭐⭐⭐ |
| **IPA 安装** | ⭐⭐⭐ 复杂 | 免费/付费 | 原生 | ⭐⭐ |
| **App Store** | ⭐⭐⭐⭐ 复杂 | $99/年 | 原生 | ⭐⭐⭐⭐ |

---

## 快速开始

### 最简部署（5分钟）

1. **创建 GitHub 仓库**
   - 登录 github.com
   - New Repository → 命名 → Create

2. **上传代码**
   ```bash
   cd "/Users/linxiaobin/Desktop/选房系统"
   git init
   git add .
   git commit -m "init"
   git remote add origin https://github.com/用户名/仓库名.git
   git push -u origin main
   ```

3. **启用 GitHub Pages**
   - Settings → Pages → Source: main → Save

4. **iPhone/iPad 访问**
   - Safari 打开 `https://用户名.github.io/仓库名/`
   - 分享 → 添加到主屏幕

---

## 注意事项

### PWA 限制
- iOS 上 PWA 存储限制约 50MB
- 部分原生功能受限（如蓝牙、NFC）
- 后台同步受限

### 离线功能
- 首次访问需要联网
- 之后可离线使用
- 数据更新需要联网

### 更新机制
- PWA 自动检测更新
- 用户刷新页面即可获得新版本
- 无需重新安装
