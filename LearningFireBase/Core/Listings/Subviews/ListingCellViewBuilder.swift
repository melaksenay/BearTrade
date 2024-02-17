//
//  ListingCellViewBuilder.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/8/24.
//

import SwiftUI

struct ListingCellViewBuilder: View {
    let listingId: String
    @State private var listing: Listing? = nil
    
    var body: some View {
        ZStack{
            if let listing{
                ListingCellView(listing: listing)
            }
        }
        .task {
            self.listing = try? await
            ListingsManager.shared.getListing(listingId: listingId)
        }
    }
}
/*/
 struct ProductCellViewBuilder: View {
     let productId: String
     @State private var product: Product? = nil
     var body: some View {
         ZStack{
             if let product{
                 ProductCellView(product: product)
             }
             
         }
         .task {
             self.product = try? await ProductsManager.shared.getProduct(productId: productId)
         }
     }
 }
 */

#Preview {
    ListingCellViewBuilder(listingId: "3CV8LSTeA5F401KyC4j3")
}
