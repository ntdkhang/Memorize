//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Nguyen Tran Duy Khang on 3/18/21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Grid(viewModel.cards) { card in
                CardView(card: card, color: viewModel.theme.color).onTapGesture{
                    withAnimation(.linear(duration: 0.5)) {
                        viewModel.choose(card: card)
                    }
                }
                .padding(5)
            }
            .padding()
            
            Button("New Game") {
                withAnimation(.easeInOut ) {
                    viewModel.newGame()
                }
            }
            .foregroundColor(Color.red)
        }
        .navigationBarTitle(Text(viewModel.theme.name))
    }
    
   
}


struct CardView: View {
    var card: MemoryGame<String>.Card
    var color: UIColor.RGB
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    var body: some View {
        GeometryReader {geometry in
            if (card.isFaceUp || !card.isMatched) {
                ZStack {
                    Group {
                        if card.isConsumingBonusTime {
                            Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(-animatedBonusRemaining * 360 - 90), clockwise: true)
                                .onAppear {
                                    startBonusTimeAnimation()
                                }
                        } else {
                            Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(-card.bonusRemaining * 360 - 90), clockwise: true)
                        }
                    }
                        .opacity(0.4)
                        .padding(5)
                        .transition(AnyTransition.scale)
                    Text(card.content)
                        .font(Font.system(size: fontSize(size: geometry.size)))
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                        .animation(card.isMatched ? Animation.linear(duration: 1.5).repeatForever(autoreverses: false) : .default)
                }
                .cardify(isFaceUp: card.isFaceUp)
                .transition(AnyTransition.scale)
                .foregroundColor(Color(color))
            }
        }
    }
    
    private func fontSize(size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.65
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let game = EmojiMemoryGame()
//        game.choose(card: game.cards[0])
//        return EmojiMemoryGameView(viewModel: game)
//    }
//}



