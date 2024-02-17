//
//  WatchlistView.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/9/24.
//

import SwiftUI

struct WatchlistView: View {
    @StateObject private var viewModel = WatchlistViewModel()
    var body: some View {
        List{
            ForEach(viewModel.userWatchlistListings, id: \.id.self) {item in
                ListingCellViewBuilder(listingId: item.listingId)
                    .contextMenu {
                        Button("Remove from Watchlist") {
                            viewModel.removeFromWatchlist(watchlistListingId: item.id)
                        }
                    }
            
            }
        }
        .navigationTitle("Watchlist")
        .onFirstAppear{
            viewModel.addListenerForWatchlist()
        }
    }
}

#Preview {
    WatchlistView()
}
