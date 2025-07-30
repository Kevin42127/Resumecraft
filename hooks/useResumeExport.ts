import { useState } from 'react'

interface ExportOptions {
  filename?: string
}

export const useResumeExport = () => {
  const [isExporting, setIsExporting] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const handleExportPDF = async (options: ExportOptions = {}) => {
    const { filename = 'resume.pdf' } = options
    
    setIsExporting(true)
    setError(null)

    try {
      console.log('📄 使用 QuestPDF 生成...')
      const success = await generateQuestPDF(filename)
      
      if (!success) {
        throw new Error('QuestPDF 生成失敗，請確保 QuestPDF API 服務正在運行')
      }
    } catch (err) {
      console.error('❌ PDF 匯出失敗:', err)
      setError(err instanceof Error ? err.message : 'PDF 匯出失敗')
    } finally {
      setIsExporting(false)
    }
  }

  const generateQuestPDF = async (filename: string): Promise<boolean> => {
    try {
      const element = document.getElementById('resume-preview')
      if (!element) {
        throw new Error('找不到履歷預覽元素')
      }

      const html = element.outerHTML
      
      // 使用環境變數或默認本地地址
      const QUESTPDF_API_URL = process.env.NEXT_PUBLIC_QUESTPDF_API_URL || 'http://localhost:5101'
      
      // 使用 QuestPDF API
      const response = await fetch(`${QUESTPDF_API_URL}/api/pdf/generate`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ 
          html, 
          filename,
          config: {
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
          },
          styles: {
            removeShadows: true,
            removeRoundedCorners: true,
            removeAnimations: true,
            flattenBackgrounds: true,
            convertToGrayscale: false,
            primaryFont: 'Microsoft YaHei',
            fallbackFont: 'Arial',
          }
        }),
      })

      if (!response.ok) {
        const errorText = await response.text()
        throw new Error(`QuestPDF API 錯誤 (${response.status}): ${errorText}`)
      }

      const blob = await response.blob()
      const url = window.URL.createObjectURL(blob)
      const link = document.createElement('a')
      link.href = url
      link.download = filename
      document.body.appendChild(link)
      link.click()
      document.body.removeChild(link)
      window.URL.revokeObjectURL(url)

      return true
    } catch (error) {
      console.error('QuestPDF 生成失敗:', error)
      return false
    }
  }

  const clearError = () => {
    setError(null)
  }

  return {
    handleExportPDF,
    isExporting,
    error,
    clearError,
  }
} 