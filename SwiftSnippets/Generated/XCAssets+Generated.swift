// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Assets {
    internal static let accentColor = ColorAsset(name: "AccentColor")
    internal enum Auteurs {
      internal static let blackKlansman = ImageAsset(name: "blackKlansman")
      internal static let blackKlansmanBig = ImageAsset(name: "blackKlansmanBig")
      internal static let brightStar = ImageAsset(name: "brightStar")
      internal static let budapestHotel = ImageAsset(name: "budapestHotel")
      internal static let davidCronenberg = ImageAsset(name: "davidCronenberg")
      internal static let departed = ImageAsset(name: "departed")
      internal static let doTheRightThing = ImageAsset(name: "doTheRightThing")
      internal static let escapeNewYork = ImageAsset(name: "escapeNewYork")
      internal static let existenz = ImageAsset(name: "existenz")
      internal static let goodfellas = ImageAsset(name: "goodfellas")
      internal static let halloween = ImageAsset(name: "halloween")
      internal static let holySmoke = ImageAsset(name: "holySmoke")
      internal static let inTheCut = ImageAsset(name: "inTheCut")
      internal static let janeCampion = ImageAsset(name: "janeCampion")
      internal static let johnCarpenter = ImageAsset(name: "johnCarpenter")
      internal static let jungleFever = ImageAsset(name: "jungleFever")
      internal static let lifeAquatic = ImageAsset(name: "lifeAquatic")
      internal static let malcomX = ImageAsset(name: "malcomX")
      internal static let martinScorsese = ImageAsset(name: "martinScorsese")
      internal static let ragingBull = ImageAsset(name: "ragingBull")
      internal static let royalTenenbaums = ImageAsset(name: "royalTenenbaums")
      internal static let rushmore = ImageAsset(name: "rushmore")
      internal static let scanners = ImageAsset(name: "scanners")
      internal static let spikeLee = ImageAsset(name: "spikeLee")
      internal static let taxiDriver = ImageAsset(name: "taxiDriver")
      internal static let theFly = ImageAsset(name: "theFly")
      internal static let thePiano = ImageAsset(name: "thePiano")
      internal static let theThing = ImageAsset(name: "theThing")
      internal static let theyLive = ImageAsset(name: "theyLive")
      internal static let videodrome = ImageAsset(name: "videodrome")
      internal static let wesAnderson = ImageAsset(name: "wesAnderson")
    }
    internal enum Chirper {
      internal static let pause = ImageAsset(name: "pause")
      internal static let play = ImageAsset(name: "play")
    }
    internal enum Cubica {
      internal static let background = ImageAsset(name: "background")
      internal static let confetti0 = ImageAsset(name: "confetti0")
      internal static let confetti1 = ImageAsset(name: "confetti1")
      internal static let confetti2 = ImageAsset(name: "confetti2")
      internal static let confetti3 = ImageAsset(name: "confetti3")
      internal static let confetti4 = ImageAsset(name: "confetti4")
      internal static let confetti5 = ImageAsset(name: "confetti5")
      internal static let mascot = ImageAsset(name: "mascot")
      internal static let overlay = ImageAsset(name: "overlay")
    }
    internal enum CustomControl {
      internal static let checkmarks = ImageAsset(name: "checkmarks")
      internal static let download = ImageAsset(name: "download")
      internal static let likeFill = ImageAsset(name: "like_fill")
      internal static let likeNormal = ImageAsset(name: "like_normal")
      internal static let navBarMore = ImageAsset(name: "navBar_more")
      internal static let ovalHighlighted = ImageAsset(name: "oval_highlighted")
      internal static let ovalNormal = ImageAsset(name: "oval_normal")
      internal static let rectHighlighted = ImageAsset(name: "rect_highlighted")
      internal static let rectNormal = ImageAsset(name: "rect_normal")
    }
    internal enum FaveButton {
      internal static let heart = ImageAsset(name: "heart")
      internal static let heartEmpty = ImageAsset(name: "heart_empty")
      internal static let heartFilled = ImageAsset(name: "heart_filled")
      internal static let like = ImageAsset(name: "like")
      internal static let smile = ImageAsset(name: "smile")
      internal static let star = ImageAsset(name: "star")
    }
    internal enum Flags {
      internal static let estonia = ImageAsset(name: "estonia")
      internal static let france = ImageAsset(name: "france")
      internal static let germany = ImageAsset(name: "germany")
      internal static let ireland = ImageAsset(name: "ireland")
      internal static let italy = ImageAsset(name: "italy")
      internal static let monaco = ImageAsset(name: "monaco")
      internal static let nigeria = ImageAsset(name: "nigeria")
      internal static let poland = ImageAsset(name: "poland")
      internal static let russia = ImageAsset(name: "russia")
      internal static let spain = ImageAsset(name: "spain")
      internal static let uk = ImageAsset(name: "uk")
      internal static let us = ImageAsset(name: "us")
    }
    internal enum FluidPhoto {
      internal static let fluidPhoto1 = ImageAsset(name: "fluidPhoto1")
      internal static let fluidPhoto10 = ImageAsset(name: "fluidPhoto10")
      internal static let fluidPhoto11 = ImageAsset(name: "fluidPhoto11")
      internal static let fluidPhoto12 = ImageAsset(name: "fluidPhoto12")
      internal static let fluidPhoto13 = ImageAsset(name: "fluidPhoto13")
      internal static let fluidPhoto14 = ImageAsset(name: "fluidPhoto14")
      internal static let fluidPhoto15 = ImageAsset(name: "fluidPhoto15")
      internal static let fluidPhoto16 = ImageAsset(name: "fluidPhoto16")
      internal static let fluidPhoto17 = ImageAsset(name: "fluidPhoto17")
      internal static let fluidPhoto18 = ImageAsset(name: "fluidPhoto18")
      internal static let fluidPhoto2 = ImageAsset(name: "fluidPhoto2")
      internal static let fluidPhoto3 = ImageAsset(name: "fluidPhoto3")
      internal static let fluidPhoto4 = ImageAsset(name: "fluidPhoto4")
      internal static let fluidPhoto5 = ImageAsset(name: "fluidPhoto5")
      internal static let fluidPhoto6 = ImageAsset(name: "fluidPhoto6")
      internal static let fluidPhoto7 = ImageAsset(name: "fluidPhoto7")
      internal static let fluidPhoto8 = ImageAsset(name: "fluidPhoto8")
      internal static let fluidPhoto9 = ImageAsset(name: "fluidPhoto9")
    }
    internal enum IconCollectionView {
      internal static let candle = ImageAsset(name: "candle")
      internal static let cat = ImageAsset(name: "cat")
      internal static let dribbble = ImageAsset(name: "dribbble")
      internal static let featureBg = ImageAsset(name: "feature_bg")
      internal static let ghost = ImageAsset(name: "ghost")
      internal static let hat = ImageAsset(name: "hat")
      internal static let icBackpack = ImageAsset(name: "ic_backpack")
      internal static let icBook = ImageAsset(name: "ic_book")
      internal static let icCamera = ImageAsset(name: "ic_camera")
      internal static let icCoffee = ImageAsset(name: "ic_coffee")
      internal static let icGlasses = ImageAsset(name: "ic_glasses")
      internal static let icIceCream = ImageAsset(name: "ic_ice_cream")
      internal static let icSmokingPipe = ImageAsset(name: "ic_smoking_pipe")
      internal static let icVespa = ImageAsset(name: "ic_vespa")
      internal static let owl = ImageAsset(name: "owl")
      internal static let pot = ImageAsset(name: "pot")
      internal static let pumkin = ImageAsset(name: "pumkin")
      internal static let rip = ImageAsset(name: "rip")
      internal static let skull = ImageAsset(name: "skull")
      internal static let sky = ImageAsset(name: "sky")
      internal static let toxic = ImageAsset(name: "toxic")
    }
    internal enum ModeratorsExplorer {
      internal static let seIcon = ImageAsset(name: "se_icon")
    }
    internal enum RaysBooks {
      internal static let expertswift = ImageAsset(name: "expertswift")
      internal static let git = ImageAsset(name: "git")
      internal static let livingcode = ImageAsset(name: "livingcode")
      internal static let pasi = ImageAsset(name: "pasi")
      internal static let swiftui = ImageAsset(name: "swiftui")
    }
    internal static let backgroundBayleaf = ImageAsset(name: "background_bayleaf")
    internal static let backgroundRwdevcon = ImageAsset(name: "background_rwdevcon")
    internal static let kanagawa = ImageAsset(name: "kanagawa")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
