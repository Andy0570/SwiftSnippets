//
//  Symbol.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/3/6.
//

import Foundation

struct Symbol: Hashable {
    var title: String?
    var symbol: [SymbolItem]
}

struct SymbolItem: Hashable {
    var title: String
}

class ItemSection {
    var gridItem = [SymbolItem(title: "drop.fill"),
                    SymbolItem(title: "flame"),
                    SymbolItem(title: "bolt.circle.fill"),
                    SymbolItem(title: "tortoise.fill"),
                    SymbolItem(title: "sun.min"),
                    SymbolItem(title: "headphones")]

    var outlineItem = [Symbol(title: "Device", symbol: [SymbolItem(title: "headphones"),
                                                        SymbolItem(title: "iphone.homebutton"),
                                                        SymbolItem(title: "pc")]),
                       Symbol(title: "Nature", symbol: [SymbolItem(title: "flame"),
                                                        SymbolItem(title: "bolt.circle.fill"),
                                                        SymbolItem(title: "drop.fill"),
                                                        SymbolItem(title: "tortoise.fill")]),
                       Symbol(title: "Weather", symbol: [SymbolItem(title: "sunset.fill"),
                                                         SymbolItem(title: "sun.min"),
                                                         SymbolItem(title: "sunset"),
                                                         SymbolItem(title: "sun.min.fill")]),
                       Symbol(title: "Objects & Tools", symbol: [SymbolItem(title: "pencil"),
                                                                 SymbolItem(title: "pencil.and.outline"),
                                                                 SymbolItem(title: "highlighter")]),
                       Symbol(title: "Communication", symbol: [SymbolItem(title: "mic"),
                                                               SymbolItem(title: "mic.fill"),
                                                               SymbolItem(title: "message"),
                                                               SymbolItem(title: "message.fill")])]
}
