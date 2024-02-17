//
//  SettingsView.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 12/23/23.
//

import SwiftUI


struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        List{
            Button("Log out") {
                Task{
                    do{
                        try viewModel.signOut()
                        showSignInView = true
                    } catch{
                        print(error)
                        
                    }
                }
                
            }
            
            Button(role: .destructive){
                Task{
                    do{
                        try await viewModel.deleteAccount()
                        showSignInView = true
                    } catch{
                        print(error)
                        
                    }
                }
            } label: {
                Text("Delete Account")
            }
            
        }
        .navigationBarTitle("Settings")
    }
}




#Preview {
    NavigationStack{
        SettingsView(showSignInView: .constant(false))
    }
    
}

extension SettingsView{
    private var emailSectino: some View {
        Section {
            Button("Reset password") {
                Task{
                    do{
                        try await viewModel.resetPassword()
                        print("Password Reset!")
                    } catch{
                        print(error)
                        
                    }
                }
                
            }
            Button("Update password") {
                Task{
                    do{
                        try await viewModel.updatePassword()
                        print("Password updated!")
                    } catch{
                        print(error)
                        
                    }
                }
                
            }
            Button("Update email") {
                Task{
                    do{
                        try await viewModel.updateEmail()
                        print("Email updated!")
                    } catch{
                        print(error)
                        
                    }
                }
                
            }
        } header: {
            Text("Email functions")
        }
    }
}
