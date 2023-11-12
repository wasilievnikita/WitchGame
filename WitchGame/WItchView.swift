//
//  BirdView.swift
//  new
//
//  Created by Никита Васильев on 06.11.2023.
//

import SwiftUI

struct WitchView: View {
    let witchSize: CGFloat
    
    var body: some View {
        Image(.witch)
            .resizable()
            .scaledToFit()
            .frame(width: witchSize, height: witchSize)
    }
}

#Preview {
        WitchView(witchSize: 80)
    }

