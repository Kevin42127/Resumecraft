const fetch = require('node-fetch');
const fs = require('fs');
const path = require('path');

async function checkProductionStatus() {
  console.log('🔍 檢查 ResumeCraft 生產環境狀態...\n');

  // 檢查建置狀態
  console.log('📋 建置狀態檢查:');
  
  // 檢查 QuestPDF API 建置
  const questpdfPath = path.join(__dirname, 'QuestPdfApi', 'publish', 'QuestPdfApi.dll');
  if (fs.existsSync(questpdfPath)) {
    console.log('✅ QuestPDF API 已建置');
  } else {
    console.log('❌ QuestPDF API 未建置');
  }

  // 檢查 Next.js 建置
  const nextPath = path.join(__dirname, '.next');
  if (fs.existsSync(nextPath)) {
    console.log('✅ Next.js 已建置');
  } else {
    console.log('❌ Next.js 未建置');
  }

  console.log();

  // 檢查服務運行狀態
  console.log('🚀 服務運行狀態檢查:');

  // 檢查 QuestPDF API 服務
  console.log('1️⃣ 檢查 QuestPDF API 服務...');
  try {
    const response = await fetch('http://localhost:5101/api/pdf/health', {
      timeout: 5000
    });
    if (response.ok) {
      const data = await response.json();
      console.log('✅ QuestPDF API 服務運行正常');
      console.log(`   - 狀態: ${data.status}`);
      console.log(`   - 版本: ${data.version}`);
      console.log(`   - 引擎: ${data.engine}`);
    } else {
      console.log('❌ QuestPDF API 服務無響應');
    }
  } catch (error) {
    console.log('❌ QuestPDF API 服務未運行');
    console.log(`   - 錯誤: ${error.message}`);
  }

  console.log();

  // 檢查 Next.js 前端服務
  console.log('2️⃣ 檢查 Next.js 前端服務...');
  try {
    const response = await fetch('http://localhost:3000', {
      timeout: 5000
    });
    if (response.ok) {
      console.log('✅ Next.js 前端服務運行正常');
      console.log('   - 地址: http://localhost:3000');
    } else {
      console.log('❌ Next.js 前端服務無響應');
    }
  } catch (error) {
    console.log('❌ Next.js 前端服務未運行');
    console.log(`   - 錯誤: ${error.message}`);
  }

  console.log();

  // 檢查日誌文件
  console.log('📄 日誌文件檢查:');
  
  const questpdfLogPath = path.join(__dirname, 'QuestPdfApi', 'publish', 'questpdf-production.log');
  if (fs.existsSync(questpdfLogPath)) {
    const stats = fs.statSync(questpdfLogPath);
    const size = (stats.size / 1024).toFixed(2);
    console.log(`✅ QuestPDF 日誌文件存在 (${size} KB)`);
  } else {
    console.log('❌ QuestPDF 日誌文件不存在');
  }

  const nextjsLogPath = path.join(__dirname, 'nextjs-production.log');
  if (fs.existsSync(nextjsLogPath)) {
    const stats = fs.statSync(nextjsLogPath);
    const size = (stats.size / 1024).toFixed(2);
    console.log(`✅ Next.js 日誌文件存在 (${size} KB)`);
  } else {
    console.log('❌ Next.js 日誌文件不存在');
  }

  console.log();

  // 總結
  console.log('📋 生產環境狀態總結:');
  console.log('   - QuestPDF API: http://localhost:5101');
  console.log('   - Next.js 前端: http://localhost:3000');
  console.log('   - Swagger 文檔: http://localhost:5101/swagger');
  console.log();

  // 提供建議
  console.log('💡 建議操作:');
  
  if (!fs.existsSync(questpdfPath) || !fs.existsSync(nextPath)) {
    console.log('   1. 執行建置命令:');
    console.log('      Windows: deploy-production.bat');
    console.log('      Linux/Mac: ./deploy-production.sh');
  }
  
  console.log('   2. 啟動生產服務:');
  console.log('      Windows: start-production-services.bat');
  console.log('      Linux/Mac: ./start-production-services.sh');
  console.log();
  
  console.log('   3. 停止服務:');
  console.log('      Windows: stop-all-services.bat');
  console.log('      Linux/Mac: ./stop-all-services.sh');
}

checkProductionStatus().catch(console.error); 