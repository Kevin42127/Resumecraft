# ResumeCraft 本地生產環境部署指南

## 🏠 **本地生產環境部署（無雲端依賴）**

### **前置需求**

1. **安裝 .NET 8.0 SDK**
   - 下載地址：https://dotnet.microsoft.com/download/dotnet/8.0
   - 驗證安裝：`dotnet --version`

2. **安裝 Node.js 18+**
   - 下載地址：https://nodejs.org/
   - 驗證安裝：`node --version`

3. **確保端口可用**
   - 端口 3000（前端）
   - 端口 5101（QuestPDF API）

---

## 🚀 **快速部署（推薦）**

### **Windows 用戶**
```cmd
# 在專案根目錄執行
deploy-production.bat
```

### **Linux/Mac 用戶**
```bash
# 在專案根目錄執行
chmod +x deploy-production.sh
./deploy-production.sh
```

---

## 📋 **手動部署步驟**

### **步驟 1：建置 QuestPDF API**

#### **Windows**
```cmd
cd QuestPdfApi
dotnet clean
dotnet restore
dotnet build -c Release
dotnet publish -c Release -o ./publish
cd ..
```

#### **Linux/Mac**
```bash
cd QuestPdfApi
dotnet clean
dotnet restore
dotnet build -c Release
dotnet publish -c Release -o ./publish
cd ..
```

### **步驟 2：建置 Next.js 前端**

```bash
# 安裝依賴
npm install

# 建置生產版本
npm run build
```

### **步驟 3：啟動 QuestPDF API 服務**

#### **Windows**
```cmd
cd QuestPdfApi/publish
start "QuestPDF API" cmd /k "dotnet QuestPdfApi.dll --urls http://localhost:5101 --environment Production"
cd ../..
```

#### **Linux/Mac**
```bash
cd QuestPdfApi/publish
dotnet QuestPdfApi.dll --urls http://localhost:5101 --environment Production > questpdf.log 2>&1 &
QUESTPDF_PID=$!
cd ../..
```

### **步驟 4：啟動 Next.js 生產服務器**

```bash
# 啟動生產服務器
npm start
```

---

## 🔧 **進階配置**

### **1. 自定義端口配置**

#### **修改 QuestPDF API 端口**
```bash
# 使用不同端口啟動 API
dotnet QuestPdfApi.dll --urls http://localhost:8080 --environment Production
```

#### **修改 Next.js 端口**
```bash
# 使用不同端口啟動前端
PORT=8080 npm start
```

### **2. 環境變數配置**

#### **創建 .env.production 文件**
```env
# QuestPDF API 配置
ASPNETCORE_ENVIRONMENT=Production
ASPNETCORE_URLS=http://localhost:5101

# Next.js 前端配置
NODE_ENV=production
NEXT_PUBLIC_QUESTPDF_API_URL=http://localhost:5101
PORT=3000
```

### **3. 日誌配置**

#### **QuestPDF API 日誌**
```bash
# 啟動時記錄日誌
dotnet QuestPdfApi.dll --urls http://localhost:5101 --environment Production > questpdf.log 2>&1
```

#### **Next.js 日誌**
```bash
# 啟動時記錄日誌
npm start > nextjs.log 2>&1
```

---

## 📊 **監控和管理**

### **1. 檢查服務狀態**

#### **QuestPDF API 健康檢查**
```bash
curl http://localhost:5101/api/pdf/health
```

#### **前端健康檢查**
```bash
curl http://localhost:3000
```

### **2. 查看日誌**

#### **QuestPDF API 日誌**
```bash
# Windows
type QuestPdfApi\publish\questpdf.log

# Linux/Mac
tail -f QuestPdfApi/publish/questpdf.log
```

#### **Next.js 日誌**
```bash
# Windows
type nextjs.log

# Linux/Mac
tail -f nextjs.log
```

### **3. 停止服務**

#### **Windows**
```cmd
# 停止 QuestPDF API
taskkill /f /im dotnet.exe

# 停止 Next.js
taskkill /f /im node.exe
```

#### **Linux/Mac**
```bash
# 停止 QuestPDF API
kill $QUESTPDF_PID

# 停止 Next.js
pkill -f "next start"
```

---

## 🛠️ **故障排除**

### **常見問題及解決方案**

#### **1. QuestPDF API 無法啟動**

**問題：端口被佔用**
```bash
# 檢查端口使用情況
netstat -ano | findstr :5101  # Windows
lsof -i :5101                 # Linux/Mac

# 殺死佔用端口的進程
taskkill /f /pid <PID>        # Windows
kill -9 <PID>                 # Linux/Mac
```

**問題：.NET 版本不兼容**
```bash
# 檢查 .NET 版本
dotnet --version

# 安裝正確版本
# 下載 .NET 8.0 SDK
```

#### **2. Next.js 建置失敗**

**問題：依賴包問題**
```bash
# 清理並重新安裝
rm -rf node_modules package-lock.json
npm install
```

**問題：記憶體不足**
```bash
# 增加 Node.js 記憶體限制
export NODE_OPTIONS="--max-old-space-size=4096"
npm run build
```

#### **3. 服務無法連接**

**問題：CORS 錯誤**
- 檢查 QuestPDF API 的 CORS 配置
- 確認前端 URL 是否正確

**問題：網路連接問題**
```bash
# 測試 API 連接
curl -v http://localhost:5101/api/pdf/health

# 檢查防火牆設置
```

---

## 🔒 **安全配置**

### **1. 防火牆配置**

#### **Windows**
```cmd
# 允許端口通過防火牆
netsh advfirewall firewall add rule name="ResumeCraft Frontend" dir=in action=allow protocol=TCP localport=3000
netsh advfirewall firewall add rule name="ResumeCraft API" dir=in action=allow protocol=TCP localport=5101
```

#### **Linux/Mac**
```bash
# 使用 ufw
sudo ufw allow 3000
sudo ufw allow 5101
sudo ufw enable
```

### **2. 環境安全**

#### **創建專用用戶**
```bash
# Linux/Mac
sudo useradd -r -s /bin/false resumecraft
sudo chown -R resumecraft:resumecraft /path/to/resumecraft
```

#### **限制文件權限**
```bash
# 設置適當的文件權限
chmod 755 /path/to/resumecraft
chmod 644 /path/to/resumecraft/*.log
```

---

## 📈 **性能優化**

### **1. QuestPDF API 優化**

#### **記憶體配置**
```bash
# 設置記憶體限制
dotnet QuestPdfApi.dll --urls http://localhost:5101 --environment Production --memory-limit 512MB
```

#### **並發配置**
```bash
# 設置最大並發連接
dotnet QuestPdfApi.dll --urls http://localhost:5101 --environment Production --max-concurrent-requests 100
```

### **2. Next.js 優化**

#### **記憶體配置**
```bash
# 增加 Node.js 記憶體
export NODE_OPTIONS="--max-old-space-size=2048"
npm start
```

#### **緩存配置**
```bash
# 啟用緩存
npm start -- --cache
```

---

## 🔄 **自動化腳本**

### **創建啟動腳本**

#### **Windows (start-services.bat)**
```batch
@echo off
echo 啟動 ResumeCraft 生產服務...

cd QuestPdfApi/publish
start "QuestPDF API" cmd /k "dotnet QuestPdfApi.dll --urls http://localhost:5101 --environment Production"
cd ../..

timeout /t 10 /nobreak >nul

echo 啟動 Next.js 前端...
npm start
```

#### **Linux/Mac (start-services.sh)**
```bash
#!/bin/bash
echo "啟動 ResumeCraft 生產服務..."

cd QuestPdfApi/publish
dotnet QuestPdfApi.dll --urls http://localhost:5101 --environment Production > questpdf.log 2>&1 &
QUESTPDF_PID=$!
cd ../..

sleep 10

echo "啟動 Next.js 前端..."
npm start > nextjs.log 2>&1 &
NEXTJS_PID=$!

echo "服務已啟動："
echo "- QuestPDF API: http://localhost:5101"
echo "- Next.js 前端: http://localhost:3000"
echo "- QuestPDF PID: $QUESTPDF_PID"
echo "- Next.js PID: $NEXTJS_PID"
```

### **創建停止腳本**

#### **Windows (stop-services.bat)**
```batch
@echo off
echo 停止 ResumeCraft 服務...

taskkill /f /im dotnet.exe
taskkill /f /im node.exe

echo 服務已停止
```

#### **Linux/Mac (stop-services.sh)**
```bash
#!/bin/bash
echo "停止 ResumeCraft 服務..."

pkill -f "dotnet QuestPdfApi.dll"
pkill -f "next start"

echo "服務已停止"
```

---

## 📋 **部署檢查清單**

### **部署前檢查**
- [ ] .NET 8.0 SDK 已安裝
- [ ] Node.js 18+ 已安裝
- [ ] 端口 3000 和 5101 可用
- [ ] 專案代碼已更新到最新版本

### **部署後檢查**
- [ ] QuestPDF API 健康檢查通過
- [ ] Next.js 前端正常訪問
- [ ] PDF 匯出功能正常
- [ ] 日誌文件正常生成
- [ ] 服務穩定運行

### **性能檢查**
- [ ] API 響應時間 < 2秒
- [ ] PDF 生成時間 < 5秒
- [ ] 記憶體使用量正常
- [ ] CPU 使用率正常

---

## 🎯 **總結**

本地生產環境部署提供了完全的控制權，不依賴任何雲端服務。通過以上配置，您可以：

1. **完全自主控制** - 所有服務都在本地運行
2. **無網路依賴** - 離線環境也能正常使用
3. **成本控制** - 無需支付雲端服務費用
4. **安全可控** - 數據完全在本地管理
5. **靈活配置** - 可根據需求自定義配置

選擇適合您需求的部署方式，享受穩定可靠的 ResumeCraft 服務！ 