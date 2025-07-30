#!/bin/bash

echo "========================================"
echo "   ResumeCraft Vercel 部署腳本"
echo "========================================"
echo

# 檢查 Node.js 版本
echo "檢查 Node.js 版本..."
if ! command -v node &> /dev/null; then
    echo "錯誤: 未找到 Node.js，請先安裝 Node.js"
    exit 1
fi

echo "✅ Node.js 已安裝"
echo

# 檢查 Vercel CLI
echo "檢查 Vercel CLI..."
if ! command -v vercel &> /dev/null; then
    echo "安裝 Vercel CLI..."
    npm install -g vercel
fi

echo "✅ Vercel CLI 已安裝"
echo

echo "========================================"
echo "建置 Next.js 專案..."
echo "========================================"
echo

echo "安裝依賴包..."
npm install

echo "建置專案..."
npm run build

echo "✅ 建置完成"
echo

echo "========================================"
echo "部署到 Vercel..."
echo "========================================"
echo

echo "請確保已登入 Vercel 帳號"
echo "如果未登入，請執行: vercel login"
echo

echo "開始部署..."
vercel --prod

echo
echo "✅ 部署完成！"
echo
echo "請在 Vercel 控制台中設置環境變數："
echo "NEXT_PUBLIC_QUESTPDF_API_URL=https://your-questpdf-api-domain.com"
echo 