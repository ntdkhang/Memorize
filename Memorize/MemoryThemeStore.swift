//
//  MemoryThemeStore.swift
//  Memorize
//
//  Created by Nguyen Tran Duy Khang on 5/29/21.
//

import Foundation
import SwiftUI
import Combine

class MemoryThemeStore: ObservableObject {
    var name: String
    @Published var themes: [Theme]
    
    private var autosave: AnyCancellable?
    
    init(name: String = "Untitled") {
        self.name = name
        let defaultkey = "MemoryThemeStore.\(name)"
        self.themes = ThemeTemplate().themes
        //self.themes = UserDefaults.standard.object(forKey: defaultkey) as! [Theme]
        
        // THEMES TO JSON !!!!!
        if self.json != nil, let jsonData = UserDefaults.standard.data(forKey: defaultkey), let newThemes = try? JSONDecoder().decode([Theme].self, from: jsonData) {
            self.themes = newThemes
        } else {
            self.themes = ThemeTemplate().themes
        }

        
        autosave = $themes.sink { themes in
            UserDefaults.standard.set(self.json, forKey: defaultkey)
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(themes)
    }
    func indexOfTheme(matching theme: Theme) -> Int? {
        for index in 0..<themes.count {
            if themes[index] == theme {
                return index
            }
        }
        return nil
    }
    
    func removeTheme(_ theme: Theme) {
        if let index = indexOfTheme(matching: theme) {
            themes.remove(at: index)
        }
    }
    
    func addTheme() {
        themes.append(Theme(name: "Untitled", emojis: "🧟‍♂️🍬👻🕷🎃🍭💋🦠", color: UIColor.orange.rgb))
    }
    
    func changeEmojis(_ fromTheme: Theme, newEmojis: String) {
        if let index = indexOfTheme(matching: fromTheme) {
            themes[index].emojis = newEmojis
        }
    }
    
    func addEmojis(_ emojis: String, fromTheme theme: Theme) {
        changeEmojis(theme, newEmojis: (emojis + theme.emojis).uniqued())
    }
    
    func removeEmoji(_ emoji: String, fromTheme theme: Theme) {
        changeEmojis(theme, newEmojis: theme.emojis.filter { String($0) != emoji })
    }
    
    func changeName(_ name: String, fromTheme theme: Theme) {
        if let index = indexOfTheme(matching: theme) {
            themes[index].name = name
        }
    }
    
    func choseColor(_ color: UIColor.RGB, fromTheme theme: Theme) {
        if let index = indexOfTheme(matching: theme) {
            themes[index].color = color
        }
    }
    
    func changeNumOfPairs(_ numOfPairs: Int, fromTheme theme: Theme) {
        if let index = indexOfTheme(matching: theme) {
            themes[index].numOfPairs = numOfPairs
        }
    }
    
}

struct Theme: Codable, Equatable {
    var name: String
    var emojis: String
    var color: UIColor.RGB
    var numOfPairs: Int
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
//    init?(json: Data?) {
//        if json != nil, let newTheme = try? JSONDecoder().decode(Theme.self, from: json!) {
//            self = newTheme
//        } else {
//            return nil
//        }
//    }
    init(name: String, emojis: String, color: UIColor.RGB, numOfPairs: Int? = nil) {
        self.name = name
        self.emojis = emojis
        self.color = color
        self.numOfPairs = numOfPairs ?? emojis.count
    }
}

class ThemeTemplate {
    var themes: Array<Theme> = [
        Theme(name: "Emotions", emojis: "😌😏😢😡😗🌝🥺😩", color: UIColor.red.rgb),
        Theme(name: "Halloween", emojis: "🧟‍♂️🍬👻🕷🎃🍭💋🦠", color: UIColor.orange.rgb),
        Theme(name: "Fruits", emojis: "🍎🍐🍊🍉🍓🍇🥥🥑", color: UIColor.green.rgb),
        Theme(name: "Food", emojis: "🌭🍔🍟🍕🌮🍙🍡🍜", color: UIColor.magenta.rgb),
        Theme(name: "Transportation", emojis: "🚗🚌🏎🛵🛴✈️🚀🛸", color: UIColor.purple.rgb),
        Theme(name: "Sports", emojis: "⚽️🏀🏈⚾️🎾🥊🏸🛹", color: UIColor.blue.rgb),
    ]
    
    var colors: [UIColor.RGB] = [
        UIColor.red.rgb,
        UIColor.green.rgb,
        UIColor.blue.rgb,
        UIColor.orange.rgb,
        UIColor.yellow.rgb,
        UIColor.magenta.rgb,
        UIColor.purple.rgb,
        UIColor.gray.rgb,
        UIColor.brown.rgb
    ]
    
    init() { }
    
}

extension Data {
    // just a simple converter from a Data to a String
    var utf8: String? { String(data: self, encoding: .utf8) }
}

extension String {
    // returns ourself without any duplicate Characters
    // not very efficient, so only for use on small-ish Strings
    func uniqued() -> String {
        var uniqued = ""
        for ch in self {
            if !uniqued.contains(ch) {
                uniqued.append(ch)
            }
        }
        return uniqued
    }
}
