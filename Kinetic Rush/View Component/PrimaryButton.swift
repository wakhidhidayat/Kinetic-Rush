//
//  PrimaryButton.swift
//  Kinetic Rush
//
//  Created by Wahid Hidayat on 15/05/24.
//

import SwiftUI

struct PrimaryButton: View {
    var title: String
    var systemImage: String? = nil
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            if let systemImage {
                HStack {
                    Image(systemName: systemImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 17, height: 17)
                        .foregroundColor(.white)
                    
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(width: 150, height: 52)
            } else {
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 150, height: 52)
            }
        }
        .background(Color.accentColor)
        .cornerRadius(16)
    }
}
