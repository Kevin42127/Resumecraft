# 🚀 Railway 部署快速開始

## 解決部署失敗問題

### 步驟 1：設置 Railway Token

1. **訪問 Railway Dashboard**
   - 前往 [railway.app](https://railway.app)
   - 使用 GitHub 帳戶登入

2. **獲取 Token**
   - 點擊右上角頭像
   - 選擇 "Account Settings"
   - 進入 "Tokens" 標籤
   - 點擊 "Create Token"
   - 複製生成的 token

### 步驟 2：設置 GitHub Secrets

1. **進入 GitHub 倉庫**
   - 前往您的 Resumecraft 倉庫
   - 點擊 "Settings" 標籤

2. **添加 Secret**
   - 左側選單選擇 "Secrets and variables" → "Actions"
   - 點擊 "New repository secret"
   - 添加：
     ```
     Name: RAILWAY_TOKEN
     Value: [您的 Railway Token]
     ```

### 步驟 3：創建 Railway 專案

1. **新建專案**
   - 在 Railway Dashboard 點擊 "New Project"
   - 選擇 "Deploy from GitHub repo"
   - 選擇您的 Resumecraft 倉庫

2. **配置設置**
   - **Builder**: Nixpacks
   - **Root Directory**: `QuestPdfApi`
   - **Start Command**: `dotnet QuestPdfApi.dll --urls http://0.0.0.0:$PORT`

3. **環境變數**
   ```
   ASPNETCORE_ENVIRONMENT=Production
   ASPNETCORE_URLS=http://0.0.0.0:$PORT
   PORT=8080
   ```

### 步驟 4：推送代碼

```bash
git add .
git commit -m "Switch to Nixpacks builder for Railway deployment"
git push origin master
```

### 步驟 5：監控部署

- 查看 GitHub Actions 執行狀態
- 檢查 Railway Dashboard 部署進度
- 獲得部署 URL

## 故障排除

如果部署仍然失敗：

1. **檢查 Railway 日誌**：點擊 "View logs" 查看詳細錯誤
2. **嘗試手動部署**：在 Railway Dashboard 中手動觸發部署
3. **檢查環境變數**：確保所有必要的環境變數都已設置

## 完成！

部署成功後，您將獲得：
- ✅ 無警告的 GitHub Actions
- ✅ 自動化 Railway 部署
- ✅ 可用的 QuestPDF API 端點 