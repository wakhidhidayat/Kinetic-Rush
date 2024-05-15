//
//  GameView.swift
//  Kinetic Rush
//
//  Created by Wahid Hidayat on 27/04/24.
//

import SwiftUI

struct GameView: View {
    @StateObject private var poseEstimator = GameViewModel()
    @State private var elapsedTime = 59
    @State private var isRunning = false
    @State private var timer: Timer?
    @State private var navigateToResult = false
    @State private var gameViewActive = true
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            CameraViewWrapper(poseEstimator: poseEstimator)
                .frame(width: .infinity, height: .infinity, alignment: .center)
                .ignoresSafeArea()
            
            if poseEstimator.isGoodPosture {
                VStack {
                    Text(String(poseEstimator.score))
                        .frame(height: 46)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 97, height: 46)
                                .foregroundColor(.accentColor)
                        )
                    Spacer()
                }
                
                if let objectImage = poseEstimator.object?.rawValue {
                    Image(objectImage)
                        .resizable()
                        .frame(width: poseEstimator.objectFrame.size.width, height: poseEstimator.objectFrame.size.height)
                        .position(x: poseEstimator.objectFrame.origin.x, y: poseEstimator.objectFrame.origin.y)
                        .animation(.default)
                }
                
                Image("effect_purple")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .position(poseEstimator.leftWristPosition)
                
                Image("effect_purple")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .position(poseEstimator.rightWristPosition)
                
                Image("effect_pink")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .position(poseEstimator.leftKneePosition)
                
                Image("effect_pink")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .position(poseEstimator.rightKneePosition)
                
                Image("effect_green")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .position(poseEstimator.leftAnklePosition)
                
                Image("effect_green")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .position(poseEstimator.rightAnklePosition)
            } else {
                VStack {
                    Text("Stand up and fit your body")
                        .frame(width: 280, height: 50)
                        .font(.system(size: 19, weight: .bold))
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.black.opacity(0.3)))
                        .padding()
                    
                    Image("pose")
                        .resizable()
                        .scaledToFit()
                        .padding()
                    
                    Spacer()
                }
            }
        }
        .onChange(of: poseEstimator.isGoodPosture) { isGoodPosture in
            if isGoodPosture {
                elapsedTime = 59
                startTimer()
            }
        }
        .onAppear {
            if gameViewActive == false {
                presentationMode.wrappedValue.dismiss()
            }
            resetGameplay()
        }
        .onDisappear {
            AudioHelper.stopBacksound()
        }
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $navigateToResult) {
            GameResultView(score: poseEstimator.score, isGameViewActive: $gameViewActive)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if elapsedTime == 1 {
                stopTimer()
                navigateToResult = true
            }
            elapsedTime -= 1
        }
    }
    
    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    private func resetGameplay() {
        elapsedTime = 59
        isRunning = false
        navigateToResult = false
        
        poseEstimator.isGoodPosture = false
        poseEstimator.score = 0
    }
}

#Preview {
    GameView()
}
