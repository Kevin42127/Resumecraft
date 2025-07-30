#!/bin/bash

echo "========================================"
echo "    ResumeCraft 完整服務啟動腳本"
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
echo "啟動 QuestPDF API 服務..."
echo "========================================"
echo

# 啟動 QuestPDF API 服務（後台運行）
echo "正在啟動 QuestPDF API..."
cd QuestPdfApi
dotnet clean > /dev/null 2>&1
dotnet restore > /dev/null 2>&1
dotnet build > /dev/null 2>&1
dotnet run > questpdf.log 2>&1 &
QUESTPDF_PID=$!
cd ..

echo "QuestPDF API 服務正在啟動..."
echo "請等待服務完全啟動後再使用 PDF 匯出功能"
echo

# 等待 QuestPDF API 啟動
sleep 10

# 檢查 QuestPDF API 是否成功啟動
if curl -s http://localhost:5101/api/pdf/health > /dev/null 2>&1; then
    echo "✅ QuestPDF API 服務已成功啟動"
else
    echo "⚠️  QuestPDF API 服務可能還在啟動中，請稍等..."
fi

echo

echo "========================================"
echo "啟動 Next.js 開發服務器..."
echo "========================================"
echo

# 檢查 node_modules 是否存在
if [ ! -d "node_modules" ]; then
    echo "安裝依賴包..."
    npm install
fi

echo "啟動 Next.js 開發服務器..."
echo
echo "服務啟動後："
echo "- Next.js 前端: http://localhost:3000"
echo "- QuestPDF API: http://localhost:5101"
echo "- Swagger 文檔: http://localhost:5101/swagger"
echo
echo "按 Ctrl+C 停止服務"
echo

# 啟動 Next.js 開發服務器
npm run dev

# 清理：停止 QuestPDF API 服務
echo "正在停止 QuestPDF API 服務..."
kill $QUESTPDF_PID 2>/dev/null
rm -f QuestPdfApi/questpdf.log 