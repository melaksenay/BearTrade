//
//  MessagesViewModel.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/15/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor

final class MainMessagesViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    @Published private (set) var users : [ChatUser] = []
    @Published var errorMessage = ""
    
    init()  {
        
    }
    
    func fetchCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        try await UserManager.shared.fetchCurrentUser()
        
        print("This is the uid: \(self.errorMessage)")
        self.errorMessage = "\(authDataResult.uid)"
    }
    
    func fetchAllMessages() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.users = try await MessagesManager.shared.getAllMessageUsersfromCurrentUser(userId: authDataResult.uid)
        
    }
    
    
    
}
