//
//  WatchlistViewModel.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/9/24.
//

import Foundation
import SwiftUI
import Combine

@MainActor

final class WatchlistViewModel: ObservableObject {
    @Published private(set) var userWatchlistListings: [UserWatchlistListing] = []
    private var cancellables = Set<AnyCancellable> ()
    
    func addListenerForWatchlist() {
        guard let authDataResult = try? AuthenticationManager.shared.getAuthenticatedUser() else {return}
        
        UserManager.shared.addListenerForAllUserWatchlistListings(userId: authDataResult.uid)
            .sink { completion in
                
            } receiveValue: { [weak self] products in
                self?.userWatchlistListings = products
            }
            .store(in: &cancellables)

        print("This is the watchlist: \(self.userWatchlistListings)")
    }
    
    func removeFromWatchlist(watchlistListingId: String) {
        Task{
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserWatchlistListing(userId: authDataResult.uid, watchlistListingId: watchlistListingId)
        }
    }
}

