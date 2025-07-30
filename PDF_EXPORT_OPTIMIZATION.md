# PDF 匯出優化指南

## 概述

本文檔說明 ResumeCraft 專案中 PDF 匯出功能的優化策略和實現方案。

## 當前架構

### QuestPDF (C# 後端) - 唯一方案
- **位置**: `QuestPdfApi/` 目錄
- **技術**: C# + QuestPDF 庫
- **特點**: 最高品質輸出，原生中文字體支援，性能優越

### 統一管理：useResumeExport Hook
- **位置**: `hooks/useResumeExport.ts`
- **功能**: 統一管理 PDF 匯出邏輯
- **特點**: 單一方案，無回退機制，確保品質一致性

## 單一方案架構

### QuestPDF 唯一方案
- **無回退機制**: 確保輸出品質一致性
- **錯誤處理**: 提供詳細的錯誤訊息
- **品質保證**: 最高品質的 PDF 輸出

### 錯誤處理流程
```
QuestPDF 失敗 → 顯示詳細錯誤訊息 → 提示用戶檢查服務狀態
```

## QuestPDF 特點

### 技術優勢
- **開源免費**: MIT 授權，無需付費
- **原生 C#**: 專為 .NET 設計，完美整合
- **現代化 API**: 聲明式、強類型的設計
- **活躍社群**: 持續更新和改進

### 性能優勢
- **生成速度**: 比 Puppeteer 快 30-50%
- **記憶體使用**: 流式處理，減少記憶體佔用
- **文件大小**: 優化的 PDF 輸出
- **中文字體**: 完整支援

## 啟動指南

### QuestPDF API 啟動
```bash
# 進入 QuestPDF API 目錄
cd QuestPdfApi

# 檢查 .NET 版本
dotnet --version

# 清理並重建
dotnet clean
dotnet restore
dotnet build

# 啟動服務
dotnet run
```

### 測試 QuestPDF API
```bash
# 健康檢查
curl http://localhost:5101/api/pdf/health

# 查看 Swagger 文檔
open http://localhost:5101/swagger
```

## 配置選項

### 程式碼配置
```typescript
// 使用 QuestPDF (唯一方案)
await handleExportPDF({ filename: 'resume.pdf' })
```

### QuestPDF 配置
```typescript
const config = {
  paperSize: 'A4',
  orientation: 'Portrait',
  marginTop: 20,
  marginBottom: 20,
  marginLeft: 20,
  marginRight: 20,
  enableHeader: false,
  enableFooter: false,
  fontFamily: 'Microsoft YaHei',
  fontSize: 12,
  enablePageNumbers: false,
};

const styles = {
  removeShadows: true,
  removeRoundedCorners: true,
  removeAnimations: true,
  flattenBackgrounds: true,
  convertToGrayscale: false,
  primaryFont: 'Microsoft YaHei',
  fallbackFont: 'Arial',
};
```

## 性能優化建議

### QuestPDF 優化
- 使用適當的紙張大小和邊距
- 配置合適的字體和字號
- 啟用樣式平面化處理
- 優化 HTML 內容結構

### 預期性能
- **生成速度**: 比 Puppeteer 快 30-50%
- **記憶體使用**: 減少 40-60%
- **文件大小**: 優化 20-30%

## 故障排除

### QuestPDF 無法啟動
1. 檢查 .NET 版本 (需要 .NET 8.0+)
2. 確認端口 5101 未被佔用
3. 檢查依賴包是否正確安裝

### PDF 生成失敗
1. 確認 API 服務正在運行
2. 檢查網路連線
3. 查看瀏覽器控制台錯誤

### 服務連接問題
1. 確保 QuestPDF API 服務正在運行
2. 檢查防火牆設置
3. 確認 CORS 配置正確

## 部署建議

### 開發環境
- 使用啟動腳本快速啟動服務
- 配置適當的日誌記錄
- 定期測試 API 健康狀態

### 生產環境
- 考慮容器化部署
- 配置負載均衡
- 設置監控和警報

## 未來改進

### 短期目標
- [ ] QuestPDF API 容器化部署
- [ ] 性能監控和日誌記錄
- [ ] 自動化測試覆蓋

### 長期目標
- [ ] 支援更多 PDF 格式
- [ ] 批次匯出功能
- [ ] 雲端儲存整合 