#!/bin/bash

echo "========================================"
echo "   ResumeCraft 生產服務啟動腳本"
echo "========================================"
echo

# 檢查 QuestPDF API 是否已建置
echo "檢查 QuestPDF API 是否已建置..."
if [ ! -f "QuestPdfApi/publish/QuestPdfApi.dll" ]; then
    echo "❌ QuestPDF API 尚未建置，請先執行 deploy-production.sh"
    exit 1
fi

echo "✅ QuestPDF API 已建置"
echo

# 檢查 Next.js 是否已建置
echo "檢查 Next.js 是否已建置..."
if [ ! -d ".next" ]; then
    echo "❌ Next.js 尚未建置，請先執行 deploy-production.sh"
    exit 1
fi

echo "✅ Next.js 已建置"
echo

echo "========================================"
echo "啟動 QuestPDF API 生產服務..."
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
npm start > nextjs-production.log 2>&1 &
NEXTJS_PID=$!

echo "服務已啟動："
echo "- QuestPDF API PID: $QUESTPDF_PID"
echo "- Next.js PID: $NEXTJS_PID"
echo "- QuestPDF 日誌: QuestPdfApi/publish/questpdf-production.log"
echo "- Next.js 日誌: nextjs-production.log"
echo

# 等待用戶中斷
wait 