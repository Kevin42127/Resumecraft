const fetch = require('node-fetch');

const QUESTPDF_API_BASE = 'http://localhost:5101/api/pdf';

async function testQuestPdfAPI() {
  console.log('🧪 測試 QuestPDF API...\n');

  try {
    // 1. 測試健康檢查
    console.log('1️⃣ 測試健康檢查...');
    const healthResponse = await fetch(`${QUESTPDF_API_BASE}/health`);
    if (healthResponse.ok) {
      const healthData = await healthResponse.json();
      console.log('✅ 健康檢查成功:', healthData);
    } else {
      console.log('❌ 健康檢查失敗:', healthResponse.status);
      return false;
    }

    // 2. 測試服務信息
    console.log('\n2️⃣ 測試服務信息...');
    const infoResponse = await fetch(`${QUESTPDF_API_BASE}/info`);
    if (infoResponse.ok) {
      const infoData = await infoResponse.json();
      console.log('✅ 服務信息:', infoData);
    } else {
      console.log('❌ 服務信息獲取失敗:', infoResponse.status);
    }

    // 3. 測試默認配置
    console.log('\n3️⃣ 測試默認配置...');
    const configResponse = await fetch(`${QUESTPDF_API_BASE}/config/default`);
    if (configResponse.ok) {
      const configData = await configResponse.json();
      console.log('✅ 默認配置:', configData);
    } else {
      console.log('❌ 默認配置獲取失敗:', configResponse.status);
    }

    // 4. 測試簡單PDF生成
    console.log('\n4️⃣ 測試PDF生成...');
    const testHtml = `
      <html>
        <body style="font-family: Arial, sans-serif; padding: 20px;">
          <h1>QuestPDF 測試</h1>
          <p>這是一個測試 PDF 文件。</p>
          <p>生成時間: ${new Date().toLocaleString()}</p>
        </body>
      </html>
    `;

    const pdfResponse = await fetch(`${QUESTPDF_API_BASE}/generate`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        html: testHtml,
        filename: 'test-questpdf.pdf',
        config: {
          paperSize: 'A4',
          orientation: 'Portrait',
          marginTop: 20,
          marginBottom: 20,
          marginLeft: 20,
          marginRight: 20,
          enableHeader: false,
          enableFooter: false,
          fontFamily: 'Arial',
          fontSize: 12,
          enablePageNumbers: false,
        },
        styles: {
          removeShadows: true,
          removeRoundedCorners: true,
          removeAnimations: true,
          flattenBackgrounds: true,
          convertToGrayscale: false,
          primaryFont: 'Arial',
          fallbackFont: 'Arial',
        }
      }),
    });

    if (pdfResponse.ok) {
      const pdfBuffer = await pdfResponse.buffer();
      console.log('✅ PDF 生成成功!');
      console.log(`📄 文件大小: ${pdfBuffer.length} bytes`);
      console.log('📁 文件已下載為 test-questpdf.pdf');
      
      // 保存文件
      const fs = require('fs');
      fs.writeFileSync('test-questpdf.pdf', pdfBuffer);
    } else {
      console.log('❌ PDF 生成失敗:', pdfResponse.status);
      const errorText = await pdfResponse.text();
      console.log('錯誤詳情:', errorText);
      return false;
    }

    console.log('\n🎉 所有測試通過！QuestPDF API 運行正常。');
    return true;

  } catch (error) {
    console.log('❌ 測試失敗:', error.message);
    console.log('\n💡 請確保 QuestPDF API 服務正在運行:');
    console.log('   - 執行 start-questpdf-api.bat (Windows)');
    console.log('   - 或執行 ./start-questpdf-api.sh (Linux/Mac)');
    return false;
  }
}

// 運行測試
testQuestPdfAPI().then(success => {
  if (success) {
    console.log('\n✅ QuestPDF API 測試完成');
  } else {
    console.log('\n❌ QuestPDF API 測試失敗');
    process.exit(1);
  }
}); 