#!/bin/bash

echo "========================================"
echo "    停止 ResumeCraft 所有服務"
echo "========================================"
echo

echo "正在停止 QuestPDF API 服務..."
pkill -f "dotnet.*QuestPdfApi" >/dev/null 2>&1
echo "✅ QuestPDF API 服務已停止"

echo
echo "正在停止 Next.js 開發服務器..."
pkill -f "next.*dev" >/dev/null 2>&1
echo "✅ Next.js 開發服務器已停止"

echo
echo "所有服務已停止" 