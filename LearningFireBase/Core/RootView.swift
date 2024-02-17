//
//  RootView.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 12/23/23.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView: Bool = false
    var body: some View {
        ZStack{
            if !showSignInView {
                TabBarView(showSignInView: $showSignInView)
//                CrashView()
            }
        }.onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView){
            NavigationStack{
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    RootView()
}
