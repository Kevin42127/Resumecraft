#!/bin/bash

echo "========================================"
echo "   ResumeCraft 生產環境部署腳本"
echo "========================================"
echo

# 檢查 .NET 版本
echo "檢查 .NET 版本..."
if ! command -v dotnet &> /dev/null; then
    echo "錯誤: 未找到 .NET SDK，請先安裝 .NET 8.0 或更新版本"
    echo "下載地址: https://dotnet.microsoft.com/download"
    exit 1
fi

echo "✅ .NET SDK 已安裝"
echo

# 檢查 Node.js 版本
echo "檢查 Node.js 版本..."
if ! command -v node &> /dev/null; then
    echo "錯誤: 未找到 Node.js，請先安裝 Node.js"
    exit 1
fi

echo "✅ Node.js 已安裝"
echo

# 檢查 QuestPDF API 目錄
echo "檢查 QuestPDF API 目錄..."
if [ ! -d "QuestPdfApi" ]; then
    echo "錯誤: QuestPdfApi 目錄不存在"
    exit 1
fi

echo "✅ QuestPDF API 目錄存在"
echo

echo "========================================"
echo "建置 QuestPDF API 生產版本..."
echo "========================================"
echo

cd QuestPdfApi
echo "清理專案..."
dotnet clean > /dev/null 2>&1

echo "還原套件..."
dotnet restore > /dev/null 2>&1

echo "建置生產版本..."
dotnet build -c Release > /dev/null 2>&1

echo "發布生產版本..."
dotnet publish -c Release -o ./publish > /dev/null 2>&1

cd ..
echo "✅ QuestPDF API 生產版本建置完成"
echo

echo "========================================"
echo "建置 Next.js 生產版本..."
echo "========================================"
echo

echo "安裝依賴包..."
npm install > /dev/null 2>&1

echo "建置生產版本..."
npm run build > /dev/null 2>&1

echo "✅ Next.js 生產版本建置完成"
echo

echo "========================================"
echo "啟動生產環境服務..."
echo "========================================"
echo

# 啟動 QuestPDF API 生產服務（後台運行）
echo "正在啟動 QuestPDF API 生產服務..."
cd QuestPdfApi/publish
dotnet QuestPdfApi.dll --urls http://localhost:5101 --environment Production > questpdf-production.log 2>&1 &
QUESTPDF_PID=$!
cd ../..

echo "QuestPDF API 生產服務正在啟動..."
echo "請等待服務完全啟動後再使用 PDF 匯出功能"
echo

# 等待 QuestPDF API 啟動
sleep 15

# 檢查 QuestPDF API 是否成功啟動
if curl -s http://localhost:5101/api/pdf/health > /dev/null 2>&1; then
    echo "✅ QuestPDF API 生產服務已成功啟動"
else
    echo "⚠️  QuestPDF API 生產服務可能還在啟動中，請稍等..."
fi

echo

echo "========================================"
echo "啟動 Next.js 生產服務器..."
echo "========================================"
echo

echo "啟動 Next.js 生產服務器..."
echo
echo "生產環境服務啟動後："
echo "- Next.js 前端: http://localhost:3000"
echo "- QuestPDF API: http://localhost:5101"
echo "- Swagger 文檔: http://localhost:5101/swagger"
echo
echo "按 Ctrl+C 停止服務"
echo

# 啟動 Next.js 生產服務器
npm start

# 清理：停止 QuestPDF API 服務
echo "正在停止 QuestPDF API 生產服務..."
kill $QUESTPDF_PID 2>/dev/null
rm -f QuestPdfApi/publish/questpdf-production.log 