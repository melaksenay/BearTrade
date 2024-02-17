//
//  ListingsViewModel.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/8/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import Combine

@MainActor

final class ListingsViewModel: ObservableObject {
    @Published private(set) var listings: [Listing] = []
    @Published var selectedFilter: FilterOption? = nil
    var moreToLoad = true
    //    @Published var selectedCategory: CategoryOption? = nil
    private var lastDocument: DocumentSnapshot? = nil
    private var cancellables = Set<AnyCancellable>()
    
    
    enum FilterOption: String, CaseIterable {
        case noFilter
        case priceHigh
        case priceLow
        
        var priceDescending: Bool? {
            switch self {
            case .noFilter : return nil
            case .priceHigh: return true
            case .priceLow: return false
            }
        }
    }
    
    func filterSelected(option: FilterOption) async throws {
        self.selectedFilter = option
        self.listings = []
        self.lastDocument = nil
        self.getListings()
    }
    
    
//    func getListings() {
//        
//        Task{
//            let(newListings, lastDocument) = try await ListingsManager.shared.getAllListings(priceDescending: selectedFilter?.priceDescending, count: 10, lastDocument: lastDocument)
//            self.listings.append(contentsOf: newListings)
//            if let lastDocument{
//                self.lastDocument = lastDocument
//                
//            }
//            
//        }
//    }
    func addListenerForListings() {
        ListingsManager.shared.addListenerForAllListings()
            .sink { completion in
                
            } receiveValue: { [weak self] listings in
                self?.listings = listings
            }
            .store(in: &cancellables)

    }
    
    func getListingss() {
        Task {
            do {
                let (newListings, lastDocument) = try await ListingsManager.shared.getAllListings(priceDescending: selectedFilter?.priceDescending, count: 10, lastDocument: lastDocument)
                self.listings.append(contentsOf: newListings)
                if let lastDocument {
                    self.lastDocument = lastDocument
                }
                
                print("Listings fetched successfully: \(newListings.count) listings")
            } catch {
                print("Error fetching listings: \(error)")
            }
        }
    }
    
    func getListings() {
        Task {
            do {
                // Ensure that the selectedFilter is considered during the initial fetch
                let (newListings, lastDocument) = try await ListingsManager.shared.getAllListings(priceDescending: selectedFilter?.priceDescending, count: 10, lastDocument: lastDocument)
                
                // Clear the existing listings if any
                if self.listings.isEmpty {
                    self.listings = newListings
                } else {
                    // If listings are not empty, append the new listings while avoiding duplicates
                    self.listings.append(contentsOf: newListings.filter { newListing in
                        !self.listings.contains { existingListing in
                            existingListing.id == newListing.id
                        }
                    })
                }
                
                if let lastDocument {
                    self.lastDocument = lastDocument
                }
                
                let listingsCount = try await ListingsManager.shared.getAllListingsCount()
                
                if listings.count == listingsCount {
                    moreToLoad = false
                }

                print("Listings fetched successfully: \(newListings.count) listings")
            } catch {
                print("Error fetching listings: \(error)")
            }
        }
    }

    
    
    func addUserWatchlistListing(listingId: String) {
        Task{
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.addUserWatchlistListing(userId: authDataResult.uid, listingId: listingId)
        }
    }
}

//DOWNLOAD PRODUCTS.
    //    func downloadProductsAndUploadToFirebase() {
    //        guard let url = URL(string: "https://dummyjson.com/products") else {return}
    //
    //        Task{
    //            do {
    //                let(data,response) = try await URLSession.shared.data(from: url)
    //                let products = try JSONDecoder().decode(ProductArray.self, from: data)
    //                let productArray = products.products
    //
    //                for product in productArray {
    //                    try? await ProductsManager.shared.uploadProduct(product: product)
    //                }
    //
    //                print("SUCCESS")
    //                print(products.products.count)
    //            } catch{
    //                print(error)
    //            }
    //        }
    //    }


