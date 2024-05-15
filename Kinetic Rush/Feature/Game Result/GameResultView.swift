//
//  GameResultView.swift
//  Kinetic Rush
//
//  Created by Wahid Hidayat on 15/05/24.
//

import SwiftUI

struct GameResultView: View {
    let score: Int
    @Binding var isGameViewActive: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.black
            
            VStack {
                Text("Your Score:")
                    .font(.title)
                    .bold()
                Text(String(score))
                    .font(.largeTitle)
                    .bold()
                
                HStack {
                    PrimaryButton(title: "Selesai") {
                        isGameViewActive = false
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding(.horizontal)
                    
                    PrimaryButton(title: "Main Lagi", systemImage: "play") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .foregroundStyle(.white)
            .padding()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GameResultView(score: 97, isGameViewActive: .constant(false))
}
