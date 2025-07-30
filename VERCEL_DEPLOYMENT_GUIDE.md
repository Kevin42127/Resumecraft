# ResumeCraft Vercel 部署指南

## 🚀 **Vercel 部署概述**

Vercel 是一個優秀的前端部署平台，但由於 QuestPDF API 是 C# 後端服務，我們需要採用混合部署策略。

### **部署架構**

```
┌─────────────────┐    ┌─────────────────┐
│   Vercel        │    │   QuestPDF API  │
│   (前端)        │◄──►│   (後端)        │
│                 │    │                 │
│ - Next.js       │    │ - C# .NET       │
│ - 靜態資源      │    │ - QuestPDF      │
│ - API Routes    │    │ - PDF 生成      │
└─────────────────┘    └─────────────────┘
```

---

## 📋 **部署選項**

### **選項 1：僅前端部署到 Vercel**

**優點：**
- 快速部署
- 免費額度充足
- 自動 CDN
- 自動 HTTPS

**缺點：**
- 需要單獨部署 QuestPDF API
- 需要配置跨域

### **選項 2：使用 Vercel Serverless Functions**

**優點：**
- 全棧部署
- 統一管理

**缺點：**
- 需要重寫 QuestPDF 功能
- 可能有限制

---

## 🎯 **推薦部署方案：混合部署**

### **步驟 1：部署 QuestPDF API**

#### **部署到 Railway**
```bash
# 1. 註冊 Railway 帳號
# 2. 連接 GitHub 倉庫
# 3. 選擇 QuestPdfApi 目錄
# 4. 設置環境變數
ASPNETCORE_ENVIRONMENT=Production
```

#### **部署到 Azure**
```bash
# 使用 Azure CLI
az webapp up --name resumecraft-api --runtime "DOTNETCORE:8.0"
```

#### **部署到 Heroku**
```bash
# 創建 Procfile
echo "web: dotnet QuestPdfApi.dll --urls http://0.0.0.0:\$PORT" > Procfile

# 部署
heroku create resumecraft-api
git push heroku main
```

### **步驟 2：部署前端到 Vercel**

#### **使用自動化腳本**

**Windows：**
```cmd
deploy-vercel.bat
```

**Linux/Mac：**
```bash
chmod +x deploy-vercel.sh
./deploy-vercel.sh
```

#### **手動部署**

```bash
# 1. 安裝 Vercel CLI
npm install -g vercel

# 2. 登入 Vercel
vercel login

# 3. 建置專案
npm run build

# 4. 部署
vercel --prod
```

---

## ⚙️ **配置環境變數**

### **在 Vercel 控制台中設置**

1. 登入 Vercel 控制台
2. 選擇您的專案
3. 進入 Settings > Environment Variables
4. 添加以下變數：

```env
NEXT_PUBLIC_QUESTPDF_API_URL=https://your-questpdf-api-domain.com
```

### **本地測試環境變數**

創建 `.env.local` 文件：
```env
NEXT_PUBLIC_QUESTPDF_API_URL=http://localhost:5101
```

---

## 🔧 **更新前端配置**

### **修改 QuestPDF API 連接**

更新 `hooks/useResumeExport.ts` 中的 API URL：

```typescript
const QUESTPDF_API_URL = process.env.NEXT_PUBLIC_QUESTPDF_API_URL || 'http://localhost:5101';

const generateQuestPDF = async (filename: string): Promise<boolean> => {
  try {
    const response = await fetch(`${QUESTPDF_API_URL}/api/pdf/generate`, {
      // ... 其他配置
    });
    // ... 處理響應
  } catch (error) {
    // ... 錯誤處理
  }
};
```

---

## 🌐 **CORS 配置**

### **在 QuestPDF API 中配置 CORS**

更新 `QuestPdfApi/Program.cs`：

```csharp
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowVercel", policy =>
    {
        policy.WithOrigins(
            "https://your-vercel-domain.vercel.app",
            "https://your-custom-domain.com"
        )
        .AllowAnyMethod()
        .AllowAnyHeader();
    });
});

// 在 app.UseRouting() 之後添加
app.UseCors("AllowVercel");
```

---

## 📊 **部署檢查清單**

### **部署前檢查**
- [ ] QuestPDF API 已部署並可訪問
- [ ] 環境變數已正確配置
- [ ] CORS 已正確設置
- [ ] 專案已建置成功

### **部署後檢查**
- [ ] 前端正常訪問
- [ ] PDF 匯出功能正常
- [ ] API 連接正常
- [ ] 跨域請求成功

---

## 🚨 **故障排除**

### **常見問題**

#### **1. CORS 錯誤**
```
Access to fetch at 'https://api-domain.com/api/pdf/generate' from origin 'https://vercel-domain.vercel.app' has been blocked by CORS policy
```

**解決方案：**
- 檢查 QuestPDF API 的 CORS 配置
- 確保 Vercel 域名已添加到允許列表

#### **2. API 連接失敗**
```
Failed to fetch: NetworkError when attempting to fetch resource
```

**解決方案：**
- 檢查環境變數配置
- 確認 API 服務正在運行
- 檢查網路連接

#### **3. 建置失敗**
```
Build failed: Error during build
```

**解決方案：**
- 檢查 Node.js 版本
- 清理 node_modules 並重新安裝
- 檢查 TypeScript 錯誤

---

## 🔄 **自動化部署**

### **GitHub Actions 工作流**

創建 `.github/workflows/deploy.yml`：

```yaml
name: Deploy to Vercel

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          
      - name: Install dependencies
        run: npm install
        
      - name: Build project
        run: npm run build
        
      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
          vercel-args: '--prod'
```

---

## 📈 **性能優化**

### **Vercel 優化建議**

1. **啟用圖片優化**
   ```javascript
   // next.config.js
   module.exports = {
     images: {
       domains: ['your-domain.com'],
       formats: ['image/webp', 'image/avif']
     }
   }
   ```

2. **啟用壓縮**
   ```javascript
   // next.config.js
   module.exports = {
     compress: true,
     swcMinify: true
   }
   ```

3. **優化字體加載**
   ```javascript
   // 使用 next/font
   import { Inter } from 'next/font/google'
   ```

---

## 🎯 **總結**

Vercel 部署提供了優秀的前端體驗，配合 QuestPDF API 的混合部署方案，您可以：

1. **享受 Vercel 的優勢**
   - 快速部署
   - 自動 CDN
   - 全球邊緣節點
   - 自動 HTTPS

2. **保持 QuestPDF 的優勢**
   - 高性能 PDF 生成
   - 完整的 C# 生態系統
   - 靈活的配置選項

3. **實現最佳用戶體驗**
   - 快速加載
   - 可靠的 PDF 生成
   - 全球可用性

選擇適合您需求的部署方案，開始您的 ResumeCraft 之旅！ 