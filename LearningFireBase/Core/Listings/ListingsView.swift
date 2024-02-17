//
//  ListingsView.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/8/24.
//

import SwiftUI
import FirebaseFirestore

struct ListingsView: View {
    @StateObject private var viewModel = ListingsViewModel()
    @State private var isLoading = true
    var body: some View {
        List{
            ForEach(viewModel.listings) {listing in
                ListingCellView(listing: listing)
                    .contextMenu(menuItems: {
                        Button("Add to watchlist"){
                            viewModel.addUserWatchlistListing(listingId: listing.id)
                        }
                    })
                
                
                if  listing == viewModel.listings.last && viewModel.moreToLoad == true {
                    ProgressView()
                        .onAppear {
                            print("fetching more products")
                            viewModel.getListings()
                        }
                }
            }
        }
        .navigationTitle("Listings")
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Menu("Filter: \( viewModel.selectedFilter?.rawValue ?? "NONE")") {
                    ForEach(ListingsViewModel.FilterOption.allCases, id: \.self) { filterOption in
                        Button(filterOption.rawValue){
                            Task{
                                try? await viewModel.filterSelected(option: filterOption)
                            }
                        }
                    }
                }
            }
        })
        .onAppear {
            //            viewModel.getProductsCount()
            viewModel.getListings()
            //            viewModel.addListenerForListings()
        }
    }
}

#Preview {
    NavigationStack{
        ListingsView()
    }
}
