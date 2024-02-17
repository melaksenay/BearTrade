//
//  CrashView.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/5/24.
//

import SwiftUI
import FirebaseCrashlytics

struct CrashView: View {
    var body: some View {
        ZStack{
            Color.gray.opacity(0.3).ignoresSafeArea()
            
            VStack(spacing: 40){
                
                Button("Click me 1") {
                    CrashManager.shared.addLog(message: "button_1_clicked")
                    let myString: String? = nil
                    guard let myString else {
                        CrashManager.shared.sendNonFatal(error: URLError(.dataNotAllowed))
                        return
                    }
                    
                    let _ = myString
                }
                
                Button("Click me 2") {
                    CrashManager.shared.addLog(message: "button_2_clicked")
                    fatalError("this was a fatal crash")
                }
                
                Button("Click me 3") {
                    CrashManager.shared.addLog(message: "button_3_clicked")
                    let array: [String] = []
                    let _ = array[0]
                }
            }
        }
        .onAppear{
            CrashManager.shared.setUserId(userId: "abc123")
            CrashManager.shared.setIsPremiumValue(isPremium: true)
            CrashManager.shared.addLog(message: "Crash view appeared on user's screen")
        }
    }
}

struct CrashView_Previews: PreviewProvider {
    static var previews: some View {
        CrashView()
    }
}
