//
//  AuthenticationView.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 12/23/23.
//

import SwiftUI

struct AuthenticationView: View {
    @Binding var showSignInView: Bool
    var body: some View {
        VStack{
            NavigationLink{
                SignInEmailView(showSignInView: $showSignInView)
                    
            } label: {
                Text("Sign In With Email")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
    }
}

#Preview {
    NavigationStack{
        AuthenticationView(showSignInView: .constant(false))
    }
}
