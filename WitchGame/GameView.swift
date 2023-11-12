//
//  ContentView.swift
//  new
//
//  Created by Никита Васильев on 06.11.2023.
//

import SwiftUI

enum GameState {
    case ready, active, stopped
}

struct GameView: View {
    @AppStorage(wrappedValue: 0, "highScore") private var highScore:Int
    
    @State private var witchVelocity = CGVector(dx: 0, dy: 0)
    @State private var witchPosition = CGPoint(x: 70, y: 300)
    @State private var flameOffset: CGFloat = 0
    @State private var boneOffset: CGFloat = 0
    @State private var lastUpdateTime = Date()
    @State private var gameState: GameState = .ready
    @State private var passedFlame = false
    @State private var topFlameHeight = CGFloat.random(in: 120...400)
    @State private var scores = 0
    @State private var boneX:CGFloat = 0
    @State private var boneY:CGFloat = 0
    @State private var bonePosition = CGPoint(x: 50, y: .random(in: 150...450))
        
    private let witchSize: CGFloat = 100
    private let witchRadius: CGFloat = 13
    
    private let boneSize: CGFloat = 50

    private let flameWidth: CGFloat = 60
    private let flameSpacing: CGFloat = 210
    
    private let boneSpeed: CGFloat = 300
    private let flameSpeed: CGFloat = 300
    
    private let gravity: CGFloat = 1000
    private let groundHeight: CGFloat = 100
    private let jumpVelocity: CGFloat = -400
    
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    @State private var isRotated = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Image(.bg)
                        .resizable()
                        .ignoresSafeArea()
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: -50, trailing: -35))
                    WitchView(witchSize: witchSize)
                        .position(witchPosition)
                    
                    BoneView(boneSize: boneSize)
                        .position(bonePosition)
                        .offset(x: geometry.size.width + boneOffset)
                    FlamesView(
                        topFlameHeight: topFlameHeight,
                        flameWidth: flameWidth,
                        flameSpacing: flameSpacing
                    )
        
                    .offset(x: geometry.size.width + flameOffset)
                    
                    if gameState == .ready {
                        Button(action: {playButtonAction()}) {
                            Image(systemName: "play.fill")
                                .font(Font.system(size: 60))
                                .foregroundColor(.white)
                        }
                    }
                    
                    if gameState == .stopped {
                        ResultView(score: scores, highScore: highScore) {
                            resetGame()
                        }
                    }
                    
                }

                .onTapGesture {
                    witchVelocity = CGVector(dx: 0, dy: jumpVelocity)
                }
                
                .onReceive(timer, perform: { currentTime in
                    guard gameState == .active else {return}
                    
                    let deltaTime = currentTime.timeIntervalSince(lastUpdateTime)
                    
                    applyGravity(deltaTime: deltaTime)
                    updateWitchPosition(deltaTime:  deltaTime )
                    checkBounderies(geometry: geometry)
                    updateFlamePosition(deltaTime: deltaTime)
                    resetFlamePostitionIfNeeded(geomerty: geometry)
                    updateScores(geometry: geometry)
                    updateBonePosition(deltaTime: deltaTime)
                    if checkCollisions(geometry: geometry) {
                        gameState = .stopped
                    }
                    lastUpdateTime = currentTime
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Text(scores.formatted())
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .padding()
                    }
                }
            }
        }
    }
    
    private func playButtonAction() {
        gameState = .active
        lastUpdateTime = Date()
    }
    
    private func applyGravity(deltaTime:TimeInterval) {
        witchVelocity.dy += CGFloat(1000 * deltaTime)
    }
    
    private func updateWitchPosition(deltaTime: TimeInterval) {
        witchPosition.y += witchVelocity.dy * CGFloat(deltaTime)
    }
    
    private func checkBounderies(geometry: GeometryProxy) {
        if witchPosition.y <= 0 {
            witchPosition.y = 0
            gameState = .stopped
        }
        
        if witchPosition.y > geometry.size.height - groundHeight {
            witchPosition.y = geometry.size.height - groundHeight
            witchVelocity.dy = 0
            gameState = .stopped
        }
        
    }
    
    private func updateFlamePosition( deltaTime: TimeInterval) {
        flameOffset -= CGFloat(300 * deltaTime)
    }

    private func updateBonePosition(deltaTime: TimeInterval) {
        boneOffset -= CGFloat(300 * deltaTime)
    }
    
   
    
    private func resetFlamePostitionIfNeeded(geomerty: GeometryProxy) {
        if flameOffset <= -geomerty.size.width - flameWidth {
            flameOffset = 0
            boneOffset = 0
            bonePosition = CGPoint(x: 90, y: .random(in: 220...340))
            boneY = bonePosition.y
            topFlameHeight = CGFloat.random(in: 120...400)
        }
    }
    
    private func resetGame() {
        witchPosition = CGPoint(x: 80, y: 300)
        witchVelocity = CGVector(dx: 0, dy: 0)
        flameOffset = 0
        boneOffset = 0
        topFlameHeight = CGFloat.random(in: 120...400)
        scores = 0
        gameState = .ready
    }
    
    private func checkCollisions(geometry: GeometryProxy) -> Bool {
        let witchFrame = CGRect(x: witchPosition.x - witchRadius/2, y: witchPosition.y - witchRadius/2, width: witchRadius, height: witchRadius)
        
        let topFlameFrame = CGRect(x: geometry.size.width + flameOffset, y: 0, width: flameWidth, height: topFlameHeight)
        
        let buttomFlameFrame = CGRect(x: geometry.size.width + flameOffset, y: topFlameHeight + flameSpacing, width: 3*flameWidth, height: topFlameHeight)
        
        let boneFrame = CGRect(x: geometry.size.width + boneOffset, y: bonePosition.y, width: boneSize, height: boneSize)
        
        return witchFrame.intersects(topFlameFrame) || witchFrame.intersects(buttomFlameFrame) || witchFrame.intersects(boneFrame)
    }
    
    private func updateScores(geometry: GeometryProxy) {
        if flameOffset + flameWidth + geometry.size.width < witchPosition.x && !passedFlame {
            scores += 1
            
            if scores > highScore {
                highScore = scores
            }
            
            passedFlame = true
        } else if flameOffset + geometry.size.width > witchPosition.x {
            passedFlame = false
        }
    }
}

#Preview {
        GameView()
    }

