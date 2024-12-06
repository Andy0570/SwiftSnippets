import UIKit

extension UIImage {
    func blurHash(numberOfComponents components: (Int, Int)) -> String? {
		let pixelWidth = Int(round(size.width * scale))
		let pixelHeight = Int(round(size.height * scale))

        // swiftlint:disable force_unwrapping
		let context = CGContext(
			data: nil,
			width: pixelWidth,
			height: pixelHeight,
			bitsPerComponent: 8,
			bytesPerRow: pixelWidth * 4,
			space: CGColorSpace(name: CGColorSpace.sRGB)!,
			bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
		)!
        // swiftlint:enable force_unwrapping
		context.scaleBy(x: scale, y: -scale)
		context.translateBy(x: 0, y: -size.height)

		UIGraphicsPushContext(context)
		draw(at: .zero)
		UIGraphicsPopContext()

		guard let cgImage = context.makeImage(),
		let dataProvider = cgImage.dataProvider,
		let data = dataProvider.data,
		let pixels = CFDataGetBytePtr(data) else {
			assertionFailure("Unexpected error!")
			return nil
		}

        let width = cgImage.width
        let height = cgImage.height
        let bytesPerRow = cgImage.bytesPerRow

        var factors: [(Float, Float, Float)] = []
        for y in 0 ..< components.1 {
            for x in 0 ..< components.0 {
                let normalisation: Float = (x == 0 && y == 0) ? 1 : 2
                let factor = multiplyBasisFunction(pixels: pixels, width: width, height: height, bytesPerRow: bytesPerRow, bytesPerPixel: cgImage.bitsPerPixel / 8, pixelOffset: 0) {
                    normalisation * cos(Float.pi * Float(x) * $0 / Float(width)) as Float * cos(Float.pi * Float(y) * $1 / Float(height)) as Float
                }
                factors.append(factor)
            }
        }

        let dc = factors.first! // swiftlint:disable:this force_unwrapping identifier_name
        let ac = factors.dropFirst() // swiftlint:disable:this identifier_name

        var hash = ""

		let sizeFlag = (components.0 - 1) + (components.1 - 1) * 9
		hash += sizeFlag.encode83(length: 1)

		let maximumValue: Float
		if !ac.isEmpty {
            // swiftlint:disable:next force_unwrapping
			let actualMaximumValue = ac.map({ max(abs($0.0), abs($0.1), abs($0.2)) }).max()!
			let quantisedMaximumValue = Int(max(0, min(82, floor(actualMaximumValue * 166 - 0.5))))
			maximumValue = Float(quantisedMaximumValue + 1) / 166
			hash += quantisedMaximumValue.encode83(length: 1)
		} else {
			maximumValue = 1
			hash += 0.encode83(length: 1)
		}

        hash += encodeDC(dc).encode83(length: 4)

        for factor in ac {
            hash += encodeAC(factor, maximumValue: maximumValue).encode83(length: 2)
        }

        return hash
    }

    // swiftlint:disable:next function_parameter_count
    private func multiplyBasisFunction(pixels: UnsafePointer<UInt8>, width: Int, height: Int, bytesPerRow: Int, bytesPerPixel: Int, pixelOffset: Int, basisFunction: (Float, Float) -> Float) -> (Float, Float, Float) {
        var red: Float = 0
        var green: Float = 0
        var blue: Float = 0

        let buffer = UnsafeBufferPointer(start: pixels, count: height * bytesPerRow)

        for x in 0 ..< width {
            for y in 0 ..< height {
                let basis = basisFunction(Float(x), Float(y))
                red += basis * sRGBToLinear(buffer[bytesPerPixel * x + pixelOffset + 0 + y * bytesPerRow])
                green += basis * sRGBToLinear(buffer[bytesPerPixel * x + pixelOffset + 1 + y * bytesPerRow])
                blue += basis * sRGBToLinear(buffer[bytesPerPixel * x + pixelOffset + 2 + y * bytesPerRow])
            }
        }

        let scale = 1 / Float(width * height)

        return (red * scale, green * scale, blue * scale)
    }
}

private func encodeDC(_ value: (Float, Float, Float)) -> Int {
    let roundedR = linearTosRGB(value.0)
    let roundedG = linearTosRGB(value.1)
    let roundedB = linearTosRGB(value.2)
    return (roundedR << 16) + (roundedG << 8) + roundedB
}

private func encodeAC(_ value: (Float, Float, Float), maximumValue: Float) -> Int {
	let quantR = Int(max(0, min(18, floor(signPow(value.0 / maximumValue, 0.5) * 9 + 9.5))))
	let quantG = Int(max(0, min(18, floor(signPow(value.1 / maximumValue, 0.5) * 9 + 9.5))))
	let quantB = Int(max(0, min(18, floor(signPow(value.2 / maximumValue, 0.5) * 9 + 9.5))))

	return quantR * 19 * 19 + quantG * 19 + quantB
}

private func signPow(_ value: Float, _ exp: Float) -> Float {
    return copysign(pow(abs(value), exp), value)
}

private func linearTosRGB(_ value: Float) -> Int {
    let value = max(0, min(1, value))
    if value <= 0.0031308 {
        return Int(value * 12.92 * 255 + 0.5)
    } else {
        return Int((1.055 * pow(value, 1 / 2.4) - 0.055) * 255 + 0.5)
    }
}

private func sRGBToLinear<Type: BinaryInteger>(_ value: Type) -> Float {
    let value = Float(Int64(value)) / 255
    if value <= 0.04045 {
        return value / 12.92
    } else {
        return pow((value + 0.055) / 1.055, 2.4)
    }
}

private let encodeCharacters: [String] = {
    return "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#$%*+,-.:;=?@[]^_{|}~".map { String($0) }
}()

extension BinaryInteger {
	func encode83(length: Int) -> String {
		var result = ""
		for i in 1 ... length {
			let digit = (Int(self) / pow(83, length - i)) % 83
			result += encodeCharacters[Int(digit)]
		}
		return result
	}
}

private func pow(_ base: Int, _ exponent: Int) -> Int {
    return (0 ..< exponent).reduce(1) { value, _ in value * base }
}
