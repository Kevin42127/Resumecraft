# ResumeCraft

現代化履歷製作網站，支援多模板切換、即時預覽、PDF 匯出，並以 Next.js App Router 架構搭配 Tailwind CSS + Material Design UI 開發。

## 🎯 目標
打造完整產品，具備現代化 UI/UX 設計、可用首頁、動畫過渡與響應式體驗。程式碼結構清晰，模組可擴充，後端服務專責處理 PDF 匯出。

---

## 🔧 技術堆疊

- Next.js v14（App Router）
- TypeScript
- Tailwind CSS v3.x（避免 v4）
- Material Design UI（品牌一致性）
- Framer Motion（動畫效果）
- react-hook-form（表單管理）
- Puppeteer（後端 PDF 匯出）
- C#
- LocalStorage（儲存表單資料）

---

## 🚀 快速開始

### 安裝依賴
```bash
npm install
```

### 開發環境
```bash
npm run dev
```

### 建置專案
```bash
npm run build
```

### 啟動生產環境
```bash
npm start
```

---

## 🖼️ 頁面設計結構

### 1️⃣ 首頁（/）
- 含品牌 Logo、網站名稱、CTA 按鈕（開始製作）
- 使用 Framer Motion 動畫進場
- 可加上服務特色、範例模板預覽

### 2️⃣ 履歷編輯頁（/editor）
- 左：表單欄位編輯（含拖曳排序）
- 右：即時預覽 A4 區塊
- 上方控制列（切換模板、主題、匯出 PDF）
- 響應式設計

### 3️⃣ 頁腳（Footer）
```
網站由 ChatGPT 建立專案結構，程式碼由 Cursor 撰寫，最後由人工進行網站測試。
© ResumeCraft 2025. All rights reserved. | 隱私政策 | 聯絡我們 | 關於我們
```

---

## ✨ 動畫規劃（使用 Framer Motion）

- 首頁 Logo、標語、按鈕：淡入 + 向上滑動
- 表單區塊切換：fade + scale
- 模板切換：交叉淡出（crossfade）
- 彈窗（意見回饋）：drop-in 動畫

---

## 🔑 功能模組

- 拖曳排序履歷區塊
- 即時預覽（Live Preview）
- 模板切換（Template Switcher）
- 自訂樣式（字體、顏色、區塊順序）
- 範例資料填充、撰寫提示、ATS 關鍵字建議
- PDF 匯出：
  - QuestPDF (C# 後端) 高品質渲染

---

## 🔒 隱私與安全

- 資料保存在使用者瀏覽器 LocalStorage
- 無登入、無帳號、無 Cookie、無追蹤
- 離線可用（匯出除外）

---

## 📩 意見回饋功能

- 網站右下 / 底部可點擊「意見回饋」
- 表單欄位：姓名（選填）、Email（選填）、內容（必填）
- 發送至：`tyouxipindao@gmail.com`（使用 nodemailer）

---

## 🧱 可擴充項目

- 多語系支援（預設繁中）
- 履歷分享（hash link 或 base64）
- 模板儲存與雲端同步
- 第三方登入支援

---

## 📁 專案結構

```
Resumecraft/
├── app/                    # Next.js App Router
│   ├── api/               # API 路由
│   │   ├── feedback/      # 意見回饋 API
│   │   └── generate-pdf/  # PDF 生成 API
│   ├── editor/            # 編輯器頁面
│   ├── globals.css        # 全域樣式
│   ├── layout.tsx         # 根布局
│   └── page.tsx           # 首頁
├── components/            # React 元件
│   ├── ResumeTemplates/   # 履歷模板
│   │   ├── TemplateA.tsx  # 經典模板
│   │   └── TemplateB.tsx  # 現代模板
│   ├── FeedbackModal.tsx  # 意見回饋彈窗
│   ├── FormEditor.tsx     # 表單編輯器
│   ├── Header.tsx         # 頁面標題
│   └── PreviewPanel.tsx   # 預覽面板
├── hooks/                 # 自訂 Hooks
│   ├── useResumeForm.ts   # 履歷表單管理
│   └── useResumeExport.ts # PDF 匯出管理
├── types/                 # TypeScript 型別定義
│   └── resume.ts          # 履歷資料型別
├── utils/                 # 工具函式
│   ├── formatter.ts       # 格式化工具
│   └── validation.ts      # 驗證工具
└── public/                # 靜態資源
    └── logo.svg           # 專案 Logo
```