//
//  OnboardingView.swift
//  Kinetic Rush
//
//  Created by Wahid Hidayat on 15/05/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentTab = 0
    @State private var isNavigate = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $currentTab) {
                    OnboardingItem(model: OnboardingModel(id: 0, imageName: "first_onboarding", description: "Gerakin tanganmu ke arah serangga ungu buat dapet poin."))
                        .tag(0)
                    
                    OnboardingItem(model: OnboardingModel(id: 1, imageName: "second_onboarding", description: "Gerakin lututmu ke arah serangga pink buat dapet poin."))
                        .tag(1)
                    
                    OnboardingItem(model: OnboardingModel(id: 2, imageName: "third_onboarding", description: "Gerakin kakimu ke arah serangga hijau buat dapet poin."))
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                PrimaryButton(title: "Mulai") {
                    isNavigate = true
                }
                .padding(16)
            }
            .navigationDestination(isPresented: $isNavigate) {
                GameView()
            }
            .onAppear {
                let content = UNMutableNotificationContent()
                content.title =  "Gerak bareng yuk, sambil main game"
                content.subtitle = "Mulailah bergerak dengan bermain Kinetic Rush"
                content.sound = UNNotificationSound.default
                
                var datComp = DateComponents()
                datComp.hour = 08
                datComp.minute = 00
                
                // show this notification at 08.00 everyday
                let trigger = UNCalendarNotificationTrigger(dateMatching: datComp, repeats: false)
                
                // choose a random identifier
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                // add our notification request
                UNUserNotificationCenter.current().add(request)
                
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("Permission approved!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    OnboardingView()
}
