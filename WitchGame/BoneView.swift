//
//  BoneView.swift
//  new
//
//  Created by Никита Васильев on 11.11.2023.
//

import SwiftUI

struct BoneView: View {
    let boneSize: CGFloat
    
    var body: some View {
        Image(.skull)
            .resizable()
            .scaledToFit()
            .frame(width: boneSize, height: boneSize)
//            .border(.red, width: 2)
    }
}

#Preview {
    BoneView(boneSize: 80)
    }
