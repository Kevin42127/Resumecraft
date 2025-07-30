# ResumeCraft 部署指南

## 🚀 **部署選項**

### 1. **本地生產環境部署**
### 2. **Docker 容器化部署**
### 3. **雲端服務部署**

---

## 📋 **本地生產環境部署**

### **Windows 用戶**

1. **使用生產部署腳本**
   ```bash
   deploy-production.bat
   ```

2. **手動部署步驟**
   ```bash
   # 建置 QuestPDF API
   cd QuestPdfApi
   dotnet publish -c Release -o ./publish
   cd ..
   
   # 建置 Next.js 前端
   npm run build
   
   # 啟動服務
   cd QuestPdfApi/publish
   dotnet QuestPdfApi.dll --urls http://localhost:5101 --environment Production
   
   # 新終端啟動前端
   npm start
   ```

### **Linux/Mac 用戶**

1. **使用生產部署腳本**
   ```bash
   chmod +x deploy-production.sh
   ./deploy-production.sh
   ```

2. **手動部署步驟**
   ```bash
   # 建置 QuestPDF API
   cd QuestPdfApi
   dotnet publish -c Release -o ./publish
   cd ..
   
   # 建置 Next.js 前端
   npm run build
   
   # 啟動服務
   cd QuestPdfApi/publish
   dotnet QuestPdfApi.dll --urls http://localhost:5101 --environment Production &
   cd ../..
   
   # 啟動前端
   npm start
   ```

---

## 🐳 **Docker 容器化部署**

### **前置需求**
- Docker Desktop 或 Docker Engine
- Docker Compose

### **快速部署**

1. **啟動所有服務**
   ```bash
   docker-compose up -d
   ```

2. **查看服務狀態**
   ```bash
   docker-compose ps
   ```

3. **查看日誌**
   ```bash
   docker-compose logs -f
   ```

4. **停止服務**
   ```bash
   docker-compose down
   ```

### **單獨建置和運行**

1. **建置 QuestPDF API 映像**
   ```bash
   cd QuestPdfApi
   docker build -t resumecraft-questpdf .
   ```

2. **建置 Next.js 前端映像**
   ```bash
   docker build -f Dockerfile.frontend -t resumecraft-frontend .
   ```

3. **運行容器**
   ```bash
   # 運行 QuestPDF API
   docker run -d -p 5101:5101 --name questpdf-api resumecraft-questpdf
   
   # 運行前端
   docker run -d -p 3000:3000 --name resumecraft-frontend resumecraft-frontend
   ```

---

## ☁️ **雲端服務部署**

### **Vercel 部署（僅前端）**

1. **安裝 Vercel CLI**
   ```bash
   npm i -g vercel
   ```

2. **部署前端**
   ```bash
   vercel
   ```

3. **配置環境變數**
   - `NEXT_PUBLIC_QUESTPDF_API_URL`: QuestPDF API 的 URL

### **Railway 部署**

1. **連接 GitHub 倉庫**
2. **配置服務**
   - 前端服務：Node.js
   - API 服務：.NET

3. **設置環境變數**
   - `ASPNETCORE_ENVIRONMENT`: Production
   - `NEXT_PUBLIC_QUESTPDF_API_URL`: API 服務 URL

### **Azure 部署**

1. **部署 QuestPDF API**
   ```bash
   cd QuestPdfApi
   az webapp up --name resumecraft-api --runtime "DOTNETCORE:8.0"
   ```

2. **部署 Next.js 前端**
   ```bash
   az staticwebapp create --name resumecraft-frontend --source .
   ```

---

## 🔧 **環境配置**

### **環境變數**

#### **QuestPDF API**
```env
ASPNETCORE_ENVIRONMENT=Production
ASPNETCORE_URLS=http://+:5101
```

#### **Next.js 前端**
```env
NODE_ENV=production
NEXT_PUBLIC_QUESTPDF_API_URL=http://localhost:5101
```

### **端口配置**

- **前端服務**: 3000
- **QuestPDF API**: 5101
- **Swagger 文檔**: http://localhost:5101/swagger

---

## 📊 **監控和日誌**

### **健康檢查**

1. **QuestPDF API 健康檢查**
   ```bash
   curl http://localhost:5101/api/pdf/health
   ```

2. **前端健康檢查**
   ```bash
   curl http://localhost:3000
   ```

### **日誌查看**

#### **Docker 日誌**
```bash
# 查看所有服務日誌
docker-compose logs -f

# 查看特定服務日誌
docker-compose logs -f questpdf-api
docker-compose logs -f resumecraft-frontend
```

#### **本地服務日誌**
```bash
# QuestPDF API 日誌
tail -f QuestPdfApi/publish/questpdf-production.log

# Next.js 日誌
npm start 2>&1 | tee nextjs.log
```

---

## 🔒 **安全配置**

### **生產環境安全建議**

1. **啟用 HTTPS**
   ```bash
   # QuestPDF API
   dotnet QuestPdfApi.dll --urls https://+:5101 --environment Production
   
   # Next.js
   npm start -- --https
   ```

2. **配置防火牆**
   ```bash
   # 只允許必要端口
   ufw allow 3000
   ufw allow 5101
   ```

3. **環境變數安全**
   - 使用 `.env.production` 文件
   - 不要在代碼中硬編碼敏感信息

---

## 🚨 **故障排除**

### **常見問題**

1. **QuestPDF API 無法啟動**
   ```bash
   # 檢查 .NET 版本
   dotnet --version
   
   # 檢查端口是否被佔用
   netstat -ano | findstr :5101
   ```

2. **前端無法連接 API**
   ```bash
   # 檢查 API 服務狀態
   curl http://localhost:5101/api/pdf/health
   
   # 檢查 CORS 配置
   ```

3. **Docker 容器無法啟動**
   ```bash
   # 檢查 Docker 日誌
   docker-compose logs
   
   # 重新建置映像
   docker-compose build --no-cache
   ```

### **性能優化**

1. **QuestPDF API 優化**
   - 使用 Release 配置
   - 配置適當的記憶體限制
   - 啟用日誌記錄

2. **Next.js 前端優化**
   - 使用生產建置
   - 配置 CDN
   - 啟用緩存

---

## 📈 **擴展建議**

### **負載均衡**
- 使用 Nginx 作為反向代理
- 配置多個 QuestPDF API 實例
- 實現健康檢查和自動故障轉移

### **監控**
- 集成 Prometheus 和 Grafana
- 設置告警機制
- 監控 API 響應時間和錯誤率

### **備份**
- 定期備份配置和數據
- 設置自動備份腳本
- 測試恢復流程 