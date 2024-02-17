//
//  ListingsManager.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/8/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class ListingsManager{
    static let shared = ListingsManager()
    private init() {}
    
    private var listingsListener: ListenerRegistration? = nil
    private let listingsCollection = Firestore.firestore().collection("listings")
    
    private func listingDocument(listingId: String)-> DocumentReference{
        listingsCollection.document(listingId)
    }
    
    func addListenerForAllListings() -> AnyPublisher<[Listing], Error> {
        let(publisher, listener) = listingsCollection.addSnapshotListener(as: Listing.self)
        self.listingsListener = listener
        return publisher
    }
    
    func uploadListing(listing: Listing) async throws {
        var newListing = listing  // Create a mutable copy
        newListing.id = listingsCollection.document().documentID  // Set id before using .setData
        
        // Use .setData to update the document in Firestore
        try listingDocument(listingId: newListing.id).setData(from: newListing)
    }

    func getListing(listingId: String) async throws -> Listing {
        try await listingDocument(listingId: listingId).getDocument(as: Listing.self)
        
    }
    
    //    private func getAllProducts() async throws -> [Product] {
    //        try await productsCollection
    //            .getDocuments(as: Product.self)
    //    }
    //
    //    private func getAllProductsSortedByPrice(descending: Bool) async throws -> [Product] {
    //        try await productsCollection
    //            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    //            .getDocuments(as: Product.self)
    //    }
    //
    //    private func getAllProductsForCategory(category: String) async throws -> [Product] {
    //        try await productsCollection
    //            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
    //            .getDocuments(as: Product.self)
    //    }
    //
    //   private func getAllProductsByPriceAndCategory(descending: Bool, category: String) async throws -> [Product] {
    //        try await productsCollection
    //            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
    //            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    //            .getDocuments(as: Product.self)
    //    }
    
//    private func getAllProductsQuery()  -> Query {
//        listingsCollection
//        
//    }
    
    private func getAllListingsQuery()  -> Query {
        listingsCollection
        
    }
    
//    private func getAllProductsSortedByPriceQuery(descending: Bool)  -> Query {
//        listingsCollection
//            .order(by: Listing.CodingKeys.price.rawValue, descending: descending)
//        
//    }
    
    private func getAllListingsSortedByPriceQuery(descending: Bool)  -> Query {
        listingsCollection
            .order(by: Listing.CodingKeys.price.rawValue, descending: descending)
        
    }
    
//    private func getAllProductsForCategoryQuery(category: String)  -> Query {
//        listingsCollection
//            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
//        
//    }
    
///   private func getAllProductsByPriceAndCategoryQuery(descending: Bool, category: String)  -> Query {
///        listingsCollection
///            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
///            .order(by: Listing.CodingKeys.price.rawValue, descending: descending)
///
///    }
    
    
    
    func getAllListings(priceDescending descending: Bool?, count: Int, lastDocument: DocumentSnapshot?) async throws -> (products: [Listing], lastDocument: DocumentSnapshot?) {
        var query: Query = getAllListingsQuery()
        
        
          if let descending {
            query = getAllListingsSortedByPriceQuery(descending: descending)
        }
        
        return try await query
            .limit(to: count)
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: Listing.self)
    }
    
//    func getProductByRating(count: Int, lastRating: Double?) async throws -> [Listing] {
//        try await listingsCollection
//            .order(by: Product.CodingKeys.rating.rawValue, descending: true)
//            .limit(to: count)
//            .start(after: [lastRating ?? 9999999])
//            .getDocuments(as: Listing.self)
//        
//    }
    
//    func getProductByRating(count: Int, lastDocument: DocumentSnapshot?) async throws -> (products: [Listing], lastDocument: DocumentSnapshot?) {
//        if let lastDocument{
//            return try await listingsCollection
//                .order(by: Listing.CodingKeys.rating.rawValue, descending: true)
//                .limit(to: count)
//                .start(afterDocument: lastDocument)
//                .getDocumentsWithSnapshot(as: Listing.self)
//        } else {
//            return try await listingsCollection
//                .order(by: Listing.CodingKeys.rating.rawValue, descending: true)
//                .limit(to: count)
//                .getDocumentsWithSnapshot(as: Listing.self)
//        }
//        
//        
//    }
    
//    func getallProductsCount () async throws -> Int {
//        let snapshot = try await listingsCollection.count.getAggregation(source: .server)
//        return Int(truncating: snapshot.count)
//    }
    
    func getAllListingsCount() async throws -> Int {
        let snapshot = try await listingsCollection.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
    
}
