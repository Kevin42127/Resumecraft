@echo off
echo ========================================
echo   ResumeCraft 生產環境部署腳本
echo ========================================
echo.

echo 檢查 .NET 版本...
dotnet --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 錯誤: 未找到 .NET SDK，請先安裝 .NET 8.0 或更新版本
    pause
    exit /b 1
)

echo ✅ .NET SDK 已安裝
echo.

echo 檢查 Node.js 版本...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 錯誤: 未找到 Node.js，請先安裝 Node.js
    pause
    exit /b 1
)

echo ✅ Node.js 已安裝
echo.

echo 檢查 QuestPDF API 目錄...
if not exist "QuestPdfApi" (
    echo 錯誤: QuestPdfApi 目錄不存在
    pause
    exit /b 1
)

echo ✅ QuestPDF API 目錄存在
echo.

echo ========================================
echo 建置 QuestPDF API 生產版本...
echo ========================================
echo.

cd QuestPdfApi
echo 清理專案...
dotnet clean

echo 還原套件...
dotnet restore

echo 建置生產版本...
dotnet build -c Release

echo 發布生產版本...
dotnet publish -c Release -o ./publish

cd ..
echo ✅ QuestPDF API 生產版本建置完成
echo.

echo ========================================
echo 建置 Next.js 生產版本...
echo ========================================
echo.

echo 安裝依賴包...
npm install

echo 建置生產版本...
npm run build

echo ✅ Next.js 生產版本建置完成
echo.

echo ========================================
echo 啟動生產環境服務...
echo ========================================
echo.

REM 在新的命令視窗中啟動 QuestPDF API 生產服務
start "QuestPDF API (Production)" cmd /k "cd /d %~dp0QuestPdfApi && echo 啟動 QuestPDF API 生產服務... && cd publish && dotnet QuestPdfApi.dll --urls http://localhost:5101 --environment Production"

echo QuestPDF API 生產服務正在啟動...
echo 請等待服務完全啟動後再使用 PDF 匯出功能
echo.

REM 等待 15 秒讓 QuestPDF API 啟動
timeout /t 15 /nobreak >nul

echo ========================================
echo 啟動 Next.js 生產服務器...
echo ========================================
echo.

echo 啟動 Next.js 生產服務器...
echo.
echo 生產環境服務啟動後：
echo - Next.js 前端: http://localhost:3000
echo - QuestPDF API: http://localhost:5101
echo - Swagger 文檔: http://localhost:5101/swagger
echo.
echo 按 Ctrl+C 停止服務
echo.

npm start

pause 