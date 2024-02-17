//
//  SignInEmailView.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 12/23/23.
//

import SwiftUI


struct SignInEmailView: View {
    @Binding var showSignInView: Bool
    @StateObject private var viewModel = SignInEmailViewModel()
    
    var body: some View {
        VStack{
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            Button{
                Task{
                    do{
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    }
                    catch{
                        print(error)
                    }
                    do{
                        try await viewModel.signIn()
                        showSignInView = false
                        return
                    }
                    catch{
                        print(error)
                    }
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In With Email")
    }
}

#Preview {
    NavigationStack{
        SignInEmailView(showSignInView: .constant(true))
    }
}
