//
//  BarCodeGenerateController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/3.
//

import UIKit

/// 使用原生 Swift 代码生成各种条形码和 QR 码
/// Reference: <https://digitalbunker.dev/native-barcode-qr-code-generation-in-swift/>
class BarCodeGenerateController: UIViewController {
    @IBOutlet private weak var aztecImageView: UIImageView!
    @IBOutlet private weak var code128ImageView: UIImageView!
    @IBOutlet private weak var pdf417ImageView: UIImageView!
    @IBOutlet private weak var qrCodeImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never

        generateAztecBarcode()
        generateCode128Barcode()
        generatePDF417Barcode()
        generateQRCode()
    }

    /// Aztec Barcode
    func generateAztecBarcode() {
        if let data = "http://www.digitalbunker.dev".data(using: .ascii),
            let aztecBarcode = try? AztecBarcode(inputMessage: data) {
            aztecImageView.image = BarcodeService.generateBarcode(from: aztecBarcode)
        }
    }

    /// Code128
    func generateCode128Barcode() {
        if let data = "http://www.digitalbunker.dev".data(using: .ascii) {
            let code128Barcode = Code128Barcode(inputMessage: data, inputQuietSpace: 20, inputBarcodeHeight: 100)
            code128ImageView.image = BarcodeService.generateBarcode(from: code128Barcode)
        }
    }

    /// PDF417
    func generatePDF417Barcode() {
        if let data = "http://www.digitalbunker.dev".data(using: .ascii) {
            let pdfBarcode = PDF417Barcode(inputMessage: data, inputMinWidth: 100, inputMaxWidth: 100, inputMinHeight: 100, inputMaxHeight: 100, inputDataColumns: 10, inputRows: 10, inputPreferredAspectRatio: 3, inputCompactionMode: 2, inputCompactStyle: true, inputCorrectionLevel: 2, inputAlwaysSpecifyCompaction: true)
            pdf417ImageView.image = BarcodeService.generateBarcode(from: pdfBarcode)
        }
    }

    /// QRCode
    func generateQRCode() {
        if let data = "http://www.digitalbunker.dev".data(using: .ascii) {
            let qrCode = QRCode(inputMessage: data)
            qrCodeImageView.image = BarcodeService.generateBarcode(from: qrCode)
        }
    }
}
