//
//  ListingModel.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/6/24.
//

import Foundation


//struct MakeNewPost {
//    var item: Listing
//}
//
//extension MakeNewPost {
//    struct Item {
//        var itemName: String
//        var price: String
//        var isBargain: Bargain
//        var date: Date
//        var description: String
//    }
//}
//
//extension MakeNewPost.Item {
//    enum Bargain: String, Identifiable, CaseIterable {
//        var id: Self {self}
//        case Yes
//        case No
//    }
//}

extension Listing {
//    static var empty: MakeNewPost 
    static var empty: Listing
    {
                
////        let general = MakeNewPost.Item(itemName: "", price: "", isBargain: MakeNewPost.Item.Bargain.allCases.first!, date: NSDate() as Date, description: "")
//
////        let general = MakeNewPost(item: Listing(id: "123", sellerId: "123", listingName: "", description: "", price: 0, discountPercentage: 0, rating: 0, stock: 0, brand: "s", category: "", thumbnail: "", images: [], isBargain: MakeNewPost.Item.Bargain.allCases.first!))
////        
        let general = Listing(id: "", sellerId: "123", date: NSDate() as Date, listingName: "", description: "", price: 0, discountPercentage: 0, rating: 0, stock: 0, brand: "s", category: "", thumbnail: "", images: [], isBargain: false)
        
//        return Listing(item: general)
        return general
    }
}

