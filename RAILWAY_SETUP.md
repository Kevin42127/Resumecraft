# Railway 部署設置指南

## 1. 獲取 Railway Token

### 方法 1：通過 Railway CLI
```bash
# 安裝 Railway CLI
npm install -g @railway/cli

# 登入
railway login

# 獲取 token
railway whoami
```

### 方法 2：通過 Railway Dashboard
1. 登入 [Railway Dashboard](https://railway.app)
2. 點擊右上角頭像
3. 選擇 "Account Settings"
4. 進入 "Tokens" 標籤
5. 點擊 "Create Token"
6. 複製生成的 token

## 2. 設置 GitHub Secrets

1. 進入您的 GitHub 倉庫
2. 點擊 "Settings" 標籤
3. 左側選單選擇 "Secrets and variables" → "Actions"
4. 點擊 "New repository secret"
5. 添加以下 secret：

```
Name: RAILWAY_TOKEN
Value: [您的 Railway Token]
```

## 3. 部署配置

### Railway 專案設置
- **Service Name**: questpdf-api
- **Root Directory**: QuestPdfApi
- **Build Command**: `dotnet restore && dotnet build -c Release && dotnet publish -c Release -o ./publish`
- **Start Command**: `dotnet QuestPdfApi.dll --urls http://0.0.0.0:$PORT`

### 環境變數
在 Railway Dashboard 中添加：
```
ASPNETCORE_ENVIRONMENT=Production
ASPNETCORE_URLS=http://0.0.0.0:$PORT
```

## 4. 測試部署

推送代碼後，GitHub Actions 會自動：
1. 建置 QuestPDF API
2. 部署到 Railway
3. 提供部署 URL

## 5. 更新前端配置

部署成功後，更新前端環境變數：
```
NEXT_PUBLIC_QUESTPDF_API_URL=https://your-railway-app.railway.app
``` 