//
//  OnboardingItem.swift
//  Kinetic Rush
//
//  Created by Wahid Hidayat on 17/05/24.
//

import SwiftUI

struct OnboardingItem: View {
    let model: OnboardingModel
    
    var body: some View {
        VStack {
            Image(model.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: .infinity, height: 500)
                .cornerRadius(16)
                .padding(.horizontal, 32)
            
            composedText(from: model.id)
                .font(.system(size: 16, weight: .medium))
                .multilineTextAlignment(.center)
                .padding()
        }
    }
    
    private func composedText(from id: Int) -> Text {
        switch id {
        case 0:
            return Text("Gerakin ")
                + Text("tanganmu").foregroundColor(.accentColor)
                + Text(" kearah ")
                + Text("serangga ungu").foregroundColor(.accentColor)
                + Text(" buat dapet poin.")
            
        case 1:
            return Text("Gerakin ")
                + Text("lututmu").foregroundColor(.tertiaryColor)
                + Text(" kearah ")
                + Text("serangga pink").foregroundColor(.tertiaryColor)
                + Text(" buat dapet poin.")
            
        case 2:
            return Text("Gerakin ")
                + Text("kakimu").foregroundColor(.secondaryColor)
                + Text(" kearah ")
                + Text("serangga hijau").foregroundColor(.secondaryColor)
                + Text(" buat dapet poin.")
            
        default:
            return Text("")
        }
    }
}
