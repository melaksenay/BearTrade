//
//  ListingsDatabase.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/8/24.
//

import Foundation

struct ListingArray: Codable {
    let products: [Listing]
    let total, skip, limit: Int
}

struct Listing: Identifiable, Codable, Equatable{
    var id: String
    let sellerId: String
    var date: Date?
    var listingName: String
    var description: String?
    let price: Double?  //CONSIDER CHANGING BACK TO VAR.
    var discountPercentage: Double?
    var rating : Double?
    var stock: Int?
    var brand, category: String?
    var thumbnail: String?
    var images: [String]?
//    let isBargain: MakeNewPost.Item.Bargain?
    let isBargain: Bool?
    
    enum CodingKeys: String,  CodingKey {
        case id
        case sellerId
        case date
        case listingName
        case description
        case price
        case discountPercentage
        case rating
        case stock
        case brand
        case category
        case thumbnail
        case images
        case isBargain
        
        
    }
    
//    static func ==(lhs: Listing, rhs: Listing) -> Bool {
//        return lhs.id == rhs.id
//    }
}


//extension Listing{
//    enum Bargain: String, Identifiable, CaseIterable{
//        var id: Self {self}
//        case Yes
//        case No
//    }
//}



