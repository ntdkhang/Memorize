//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Nguyen Tran Duy Khang on 3/19/21.
//

import Foundation


class EmojiMemoryGame: ObservableObject {
    
    @Published private var model: MemoryGame<String>
    var theme: Theme
    
    private static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        //let numberOfPairsOfCard = gameTheme.numOfPairs != nil ? gameTheme.numOfPairs : Int.random(in: 3..<gameTheme.emojis.count)
        let numberOfPairsOfCard = theme.numOfPairs
        return MemoryGame<String>(numberOfPairsOfCard: numberOfPairsOfCard) { pairIndex in
            return theme.emojis.map{ String($0) }[pairIndex]
        }
    }
    
    init (_ theme: Theme) {
        self.theme = theme
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    func getTheme() -> Theme {
        return theme
    }
    
    
    // MARK: Intents
    
    func newGame() {
        model = EmojiMemoryGame.createMemoryGame(theme: self.theme)
    }
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}

