//
//  TubesView.swift
//  new
//
//  Created by Никита Васильев on 06.11.2023.
//

import SwiftUI

struct FlamesView: View {
    let topFlameHeight: CGFloat
    let flameWidth: CGFloat
    let flameSpacing: CGFloat
    
    var body: some View {
        GeometryReader { geomety in
            let availableHeight = geomety.size.height - flameSpacing
            let bottomTopHeight = availableHeight - topFlameHeight
            
            VStack {
                Image(.flame)
                    .resizable()
                    .rotationEffect(.degrees(180))
                    .frame(width: flameWidth, height: topFlameHeight)
                
                Spacer()
                
                Image(.flame)
                    .resizable()
                    .frame(width: flameWidth, height: bottomTopHeight)
                   

            }
        }
    }
}
    
#Preview {
            FlamesView(topFlameHeight: 300, flameWidth: 100, flameSpacing: 150)
        }

