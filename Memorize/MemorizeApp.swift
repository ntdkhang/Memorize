//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Nguyen Tran Duy Khang on 3/18/21.
//

import SwiftUI



@main
struct MemorizeApp: App {
//    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ThemeChooser()
                .environmentObject(MemoryThemeStore())
        }
    }
}
