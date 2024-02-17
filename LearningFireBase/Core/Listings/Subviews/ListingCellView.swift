//
//  ListingCellView.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/8/24.
//

import SwiftUI

struct ListingCellView: View {
    let listing: Listing
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            Text(listing.listingName)
                .font(.headline)
                .foregroundStyle(.primary)
            Text("Price: $" + "")
            Text("Description: " + String(listing.description ?? "n/a"))
            
            .font(.callout)
            .foregroundColor(.secondary)
//            Text("Rating: " + String(Listing.rating ?? 0))
//            Text("Category: " + (listing.category ?? "n/a"))
//            Text("Brand: " + (listing.brand ?? "n/a"))
        
        }
    }
}

#Preview {
    ListingCellView(listing: Listing(id: "302", sellerId: "3232", date: NSDate() as Date, listingName: "Drake Tickets", description: "cool tix brah", price: 32, discountPercentage: 1231, rating: 234, stock: 234, brand: "esoih", category: "oihoi", thumbnail: "sfsd", images: [], isBargain: true))
}

/*
 struct ProductCellView: View {
     let product: Product
     var body: some View {
             VStack(alignment: .leading, spacing: 4){
                 Text(product.title ?? "n/a")
                     .font(.headline)
                     .foregroundStyle(.primary)
                 Text("Price: $" + String(product.price ?? 0))
                 Text("Rating: " + String(product.rating ?? 0))
                 Text("Category: " + (product.category ?? "n/a"))
                 Text("Brand: " + (product.brand ?? "n/a"))
             }
             .font(.callout)
             .foregroundColor(.secondary)
         }
     }
 }
 */
