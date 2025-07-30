@echo off
echo ========================================
echo   ResumeCraft 生產服務啟動腳本
echo ========================================
echo.

echo 檢查 QuestPDF API 是否已建置...
if not exist "QuestPdfApi\publish\QuestPdfApi.dll" (
    echo ❌ QuestPDF API 尚未建置，請先執行 deploy-production.bat
    pause
    exit /b 1
)

echo ✅ QuestPDF API 已建置
echo.

echo 檢查 Next.js 是否已建置...
if not exist ".next" (
    echo ❌ Next.js 尚未建置，請先執行 deploy-production.bat
    pause
    exit /b 1
)

echo ✅ Next.js 已建置
echo.

echo ========================================
echo 啟動 QuestPDF API 生產服務...
echo ========================================
echo.

REM 在新的命令視窗中啟動 QuestPDF API
start "QuestPDF API (Production)" cmd /k "cd /d %~dp0QuestPdfApi\publish && echo 啟動 QuestPDF API 生產服務... && dotnet QuestPdfApi.dll --urls http://localhost:5101 --environment Production"

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