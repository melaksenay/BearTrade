//
//  SettingsViewModel.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 12/25/23.
//

import Foundation
@MainActor
final class SettingsViewModel: ObservableObject{
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
        
    }
    
    func resetPassword() async throws {
        let authUser =  try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await  AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws{
        let email = "melaksenay@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws{
        let password = "hello123"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    
}
