@echo off
echo ========================================
echo    QuestPDF API 啟動腳本
echo ========================================
echo.

echo 檢查 .NET 版本...
dotnet --version
if %errorlevel% neq 0 (
    echo 錯誤: 未找到 .NET SDK，請先安裝 .NET 8.0 或更新版本
    pause
    exit /b 1
)

echo.
echo 進入 QuestPDF API 目錄...
cd QuestPdfApi

echo.
echo 清理專案...
dotnet clean

echo.
echo 還原套件...
dotnet restore

echo.
echo 建置專案...
dotnet build

echo.
echo 啟動 QuestPDF API 服務...
echo 服務將在 http://localhost:5101 啟動
echo Swagger 文檔: http://localhost:5101/swagger
echo.
echo 按 Ctrl+C 停止服務
echo.

dotnet run

pause 