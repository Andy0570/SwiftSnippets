//
//  WKWebViewExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/4/8.
//

import WebKit

extension WKWebView {
    /// Dark Mode for WKWebView.
    ///
    /// - SeeAlso: <https://stackoverflow.com/questions/57203909/how-to-use-ios-13-darkmode-for-wkwebview>
    func toDark() {
        let cssString = "@media (prefers-color-scheme: dark) {body { background-color: black; color: white;} a:link {color: #0096e2;} a:visited {color: #9d57df;}}"
        let jsString = "var style = document.createElement('style'); style.innerHTML = '\(cssString)'; document.head.appendChild(style);"
        self.evaluateJavaScript(jsString, completionHandler: nil)
    }
}

// MARK: - PDF

extension WKWebView {
    /// Create PDF from WKWebView, Call this function when WKWebView finish loading.
    ///
    ///     let pdfFilePath = self.webView.exportAsPdfFromWebView()
    ///     print(pdfFilePath)
    ///
    /// - SeeAlso: <https://www.swiftdevcenter.com/create-pdf-from-uiview-wkwebview-and-uitableview/>
    func exportAsPdfFromWebView() -> String {
        let pdfData = createPdfFile(printFormatter: self.viewPrintFormatter())
        return self.saveWebViewPdf(data: pdfData)
    }

    func createPdfFile(printFormatter: UIViewPrintFormatter) -> NSMutableData {
        let originalBounds = self.bounds
        self.bounds = CGRect(x: originalBounds.origin.x, y: bounds.origin.y, width: self.bounds.size.width, height: self.scrollView.contentSize.height)
        let pdfPageFrame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.scrollView.contentSize.height)
        let printPageRenderer = UIPrintPageRenderer()
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        printPageRenderer.setValue(NSValue(cgRect: UIScreen.main.bounds), forKey: "paperRect")
        printPageRenderer.setValue(NSValue(cgRect: pdfPageFrame), forKey: "printableRect")
        self.bounds = originalBounds
        return printPageRenderer.generatePdfData()
    }

    /// Save PDF file in Document directory.
    func saveWebViewPdf(data: NSMutableData) -> String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("webViewPdf.pdf")
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
    }
}

extension UIPrintPageRenderer {
    /// generate PDF data
    func generatePdfData() -> NSMutableData {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, self.paperRect, nil)
        self.prepare(forDrawingPages: NSRange(location: 0, length: self.numberOfPages))
        let printRect = UIGraphicsGetPDFContextBounds()
        for pdfPage in 0..<(self.numberOfPages) {
            UIGraphicsBeginPDFPage()
            self.drawPage(at: pdfPage, in: printRect)
        }
        UIGraphicsEndPDFContext()
        return pdfData
    }
}
