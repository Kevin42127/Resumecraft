const fetch = require('node-fetch');

async function checkServices() {
  console.log('🔍 檢查 ResumeCraft 服務狀態...\n');

  // 檢查 QuestPDF API 服務
  console.log('1️⃣ 檢查 QuestPDF API 服務...');
  try {
    const response = await fetch('http://localhost:5101/api/pdf/health');
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
    const response = await fetch('http://localhost:3000');
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

  // 總結
  console.log('📋 服務狀態總結:');
  console.log('   - QuestPDF API: http://localhost:5101');
  console.log('   - Next.js 前端: http://localhost:3000');
  console.log('   - Swagger 文檔: http://localhost:5101/swagger');
  console.log();

  console.log('💡 如果服務未運行，請使用以下命令啟動:');
  console.log('   Windows: start-all-services.bat');
  console.log('   Linux/Mac: ./start-all-services.sh');
}

checkServices().catch(console.error); 