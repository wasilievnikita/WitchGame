//
//  ResultView.swift
//  new
//
//  Created by Никита Васильев on 06.11.2023.
//

import SwiftUI

struct ResultView: View {
    let score: Int
    let highScore: Int
    let resetAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Game over")
                .font(.largeTitle)
                .padding()
            Text("Score: \(score)")
                .font(.largeTitle)
            Text("Best: \(highScore)")
                .padding()
            Button("Restart", action: resetAction)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                
                .clipShape(.rect(cornerRadius:20))
                .padding()
        }
                .background(.white.opacity(0.8))
                .clipShape(.rect(cornerRadius:20))
                .padding()
    }
}

#Preview {
        ResultView(score: 5, highScore: 8, resetAction: {})
    }
    
    
