//
//  UserManager.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 12/26/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

struct Movie: Codable {
    let id: String
    let title: String
    let isPopular: Bool
}

struct DBUser: Codable{
    let userId: String
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isPremium: Bool?
    let preferences: [String]?
    let favoriteMovie: Movie?
    let profileImagePath: String?
    let profileImageUrl: String?
    
    init(
        userId: String,
        email: String? = nil,
        photoUrl: String? = nil,
        dateCreated: Date? = nil,
        isPremium: Bool? = nil,
        preferences: [String]? = nil,
        favoriteMovie: Movie? = nil,
        profileImagePath: String? = nil,
        profileImageUrl: String? = nil
    ) {
        self.userId = userId
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.preferences = preferences
        self.favoriteMovie = favoriteMovie
        self.profileImagePath = profileImagePath
        self.profileImageUrl = profileImageUrl
    }
    
    init(auth: AuthDataResultModel){
        self.userId = auth.uid
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.isPremium = false
        self.preferences = nil
        self.favoriteMovie = nil
        self.profileImagePath = nil
        self.profileImageUrl = nil
        
    }
    
//    func togglePremiumStatus() -> DBUser {
//        let currentValue = isPremium ?? false
//        return DBUser(userId: userId,
//                      email: email,
//                      photoUrl: photoUrl,
//                      dateCreated: dateCreated,
//                      isPremium: !currentValue
//        )
//    }
    
//    mutating func togglePremiumStatus() {
//        let currentValue = isPremium ?? false
//        isPremium = !currentValue
//    }
    
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "user_isPremium"
        case preferences = "preferences"
        case favoriteMovie = "favorite_movie"
        case profileImagePath = "profile_image_path"
        case profileImageUrl = "profile_image_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.favoriteMovie = try container.decodeIfPresent(Movie.self, forKey: .favoriteMovie)
        self.profileImagePath = try container.decodeIfPresent(String.self, forKey: .profileImagePath)
        self.profileImageUrl = try container.decodeIfPresent(String.self, forKey: .profileImageUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encodeIfPresent(self.favoriteMovie, forKey: .favoriteMovie)
        try container.encodeIfPresent(self.profileImagePath, forKey: .profileImagePath)
        try container.encodeIfPresent(self.profileImageUrl, forKey: .profileImageUrl)
    }

    
    
    
}

final class UserManager{
    static let shared = UserManager()
    private init() {}
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    
    private func userDocument(userId: String)-> DocumentReference{
        userCollection.document(userId)
    }
    
    
    private func userFavoriteProductCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("favorite_products")
    }
        
    private func userFavoriteProductDocument(userId: String, favoriteProductId: String) -> DocumentReference {
        userFavoriteProductCollection(userId: userId).document(favoriteProductId)
    }
    
    private func userWatchlistProductDocument(userId: String, watchlistListingId: String) -> DocumentReference {
        userWatchlistListingCollection(userId: userId).document(watchlistListingId)
    }
    
    private func userWatchlistListingCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("watchlisted_listings")
    }
    
    private func userWatchlistListing(userId: String, watchlistListingId: String) -> DocumentReference {
        userWatchlistListingCollection(userId: userId).document(watchlistListingId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
        
    } () // call function with ().
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
        
    } ()
    
    private var userFavoriteProductsListener: ListenerRegistration? = nil
    private var userWatchlistListingListener: ListenerRegistration? = nil
    
    func createNewUser(user: DBUser) async throws{
        try  userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    //    func createNewUser(auth: AuthDataResultModel) async throws {
    //        var userData: [String: Any] = [
    //            "user_id" : auth.uid,
    //            "date_created" : Timestamp(),
    //        ]
    //        if let email = auth.email {
    //            userData["email"] = email
    //        }
    //        if let photoUrl = auth.photoUrl {
    //            userData["photo_url"] = photoUrl
    //        }
    //        try await userDocument(userId: auth.uid).setData(userData, merge: false)
    //    }
    
    func getUser(userId: String) async throws -> DBUser{
        return try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    //    func getUser(userId: String) async throws -> DBUser{
    //        let snapshot = try await userDocument(userId: userId).getDocument()
    //
    //        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
    //            throw URLError(.badServerResponse)
    //        }
    //
    //
    //        let email = data["email"] as? String
    //        let photoUrl = data["photo_url"] as? String
    //        let dateCreated = data["date_created"] as? Date
    //
    //        return DBUser(userId: userId, email: email, photoUrl: photoUrl, dateCreated: dateCreated)
    //    }
    
//    func updateUserPremiumStatus(user: DBUser) async throws {
//        try  userDocument(userId: user.userId).setData(from: user, merge: true)
//    }
    

    func fetchCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()

        do {
            let snapshot = try await userDocument(userId: authDataResult.uid).getDocument()
            guard let data = snapshot.data() else {
                return
            }
            print(data)
        } catch {
            print("Failed to fetch current user", error)
        }
    }

    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.isPremium.rawValue : isPremium
            ]
        
        try await  userDocument(userId: userId).updateData(data)
    }
    
    func updateUserProfileImagePath(userId: String, path: String?, url: String?) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.profileImagePath.rawValue : path ?? NSNull(), //if error occurs just get rid of NSNull()
            DBUser.CodingKeys.profileImageUrl.rawValue : url ?? NSNull(),
            ]
        
        try await  userDocument(userId: userId).updateData(data)
    }
    
    func addUserPreference(userId: String, preference: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayUnion([preference])
            ]
        
        try await  userDocument(userId: userId).updateData(data)
    }
    
    func removeUserPreference(userId: String, preference: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayRemove([preference])
            ]
        
        try await  userDocument(userId: userId).updateData(data)
    }
    
    func addFavoriteMovie(userId: String, movie: Movie) async throws {
        guard let data = try? encoder.encode(movie) else{
            throw URLError(.badURL)
        }
        let dict: [String : Any] = [
            DBUser.CodingKeys.favoriteMovie.rawValue : data
            ]
        
        try await  userDocument(userId: userId).updateData(dict)
    }
    
    func removeFavoriteMovie(userId: String) async throws {
        let data: [String : Any?] = [
            DBUser.CodingKeys.favoriteMovie.rawValue : nil
            ]
        
        try await  userDocument(userId: userId).updateData(data as [AnyHashable : Any])
    }
    
    func addUserFavoriteProduct(userId: String, productId: Int) async throws {
        
        let document = userFavoriteProductCollection(userId: userId).document()
        let documentId = document.documentID
        
        let data: [String : Any] = [
            UserFavoriteProduct.CodingKeys.id.rawValue : documentId,
            UserFavoriteProduct.CodingKeys.productId.rawValue : productId,
            UserFavoriteProduct.CodingKeys.dateCreated.rawValue : Timestamp()
        ]
        
        try await document.setData(data, merge: false)
    }
    
    func addUserWatchlistListing(userId: String, listingId: String) async throws {
        
        let document = userWatchlistListingCollection(userId: userId).document()
        let documentId = document.documentID
        
        let data: [String : Any] = [
            UserWatchlistListing.CodingKeys.id.rawValue : documentId,
            UserWatchlistListing.CodingKeys.listingId.rawValue : listingId,
            UserWatchlistListing.CodingKeys.dateCreated.rawValue : Timestamp()
        ]
        
        try await document.setData(data, merge: false)
    }
    
    func removeUserWatchlistListing(userId: String, watchlistListingId: String) async throws {
        try await userWatchlistProductDocument(userId: userId, watchlistListingId: watchlistListingId).delete()
    
    }
    
    func getAllUserWatchlistListings(userId: String) async throws -> [UserFavoriteProduct] {
        try await userFavoriteProductCollection(userId: userId).getDocuments(as: UserFavoriteProduct.self)
    }
    
    func removeUserFavoriteProduct(userId: String, favoriteProductId: String) async throws {
        try await userFavoriteProductDocument(userId: userId, favoriteProductId: favoriteProductId).delete()
    
    }
    
    func getAllUserFavoriteProducts(userId: String) async throws -> [UserFavoriteProduct] {
        try await userFavoriteProductCollection(userId: userId).getDocuments(as: UserFavoriteProduct.self)
    }
    
    func removeListenerForAllUserFavoriteProducts() {
        self.userFavoriteProductsListener?.remove()
    }
    
    func removeListenerForAllUserWatchlistListings() {
        self.userWatchlistListingListener?.remove()
    }
    
    func addListenerForAllUserFavoriteProducts(userId: String, completion: @escaping (_ products: [UserFavoriteProduct]) -> Void) {
        self.userFavoriteProductsListener = userFavoriteProductCollection(userId: userId).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("no ducments")
                return
            }
            let products: [UserFavoriteProduct] = documents.compactMap ({ try? $0.data(as: UserFavoriteProduct.self)})
            completion(products)
            
            querySnapshot?.documentChanges.forEach { diff in
                if(diff.type == .added) {
                    print("New products: \(diff.document.data())")
                }
                if(diff.type == .modified) {
                    print("Modified products: \(diff.document.data())")
                }
                if(diff.type == .removed) {
                    print("Removed products: \(diff.document.data())")
                }
            }
            
            //            let products: [UserFavoriteProduct] = documents.compactMap { documentSnapshot in
            //                return try? documentSnapshot.data(as: UserFavoriteProduct.self)
            //            }
        }
        
    }
    
//    func addListenerForAllUserWatchlistListings(userId: String, completion: @escaping (_ products: [UserWatchlistListing]) -> Void) {
//        self.userWatchlistListingListener = userWatchlistListingCollection(userId: userId).addSnapshotListener { querySnapshot, error in
//            guard let documents = querySnapshot?.documents else {
//                print("no documents")
//                return
//            }
//            let products: [UserWatchlistListing] = documents.compactMap ({ try? $0.data(as: UserWatchlistListing.self)})
//            completion(products)
//            
//            querySnapshot?.documentChanges.forEach { diff in
//                if(diff.type == .added) {
//                    print("New products: \(diff.document.data())")
//                }
//                if(diff.type == .modified) {
//                    print("Modified products: \(diff.document.data())")
//                }
//                if(diff.type == .removed) {
//                    print("Removed products: \(diff.document.data())")
//                }
//            }
//            
//            //            let products: [UserFavoriteProduct] = documents.compactMap { documentSnapshot in
//            //                return try? documentSnapshot.data(as: UserFavoriteProduct.self)
//            //            }
//        }
//        
//    }
    
//    func addListenerForAllUserFavoriteProducts(userId: String) ->  AnyPublisher<[UserFavoriteProduct], Error> {
//        let publisher = PassthroughSubject<[UserFavoriteProduct], Error> ()
//        
//        self.userFavoriteProductsListener = userFavoriteProductCollection(userId: userId).addSnapshotListener { querySnapshot, error in
//            guard let documents = querySnapshot?.documents else {
//                print("no ducments")
//                return
//            }
//            let products: [UserFavoriteProduct] = documents.compactMap ({ try? $0.data(as: UserFavoriteProduct.self)})
//            publisher.send(products)
//            
//        }
//        
//        return publisher.eraseToAnyPublisher()
//    }
    
    
    
    func addListenerForAllUserWatchlistListings(userId: String) -> AnyPublisher<[UserWatchlistListing], Error> {
        let (publisher, listener) = userWatchlistListingCollection(userId: userId)
            .addSnapshotListener(as: UserWatchlistListing.self)
        
        self.userWatchlistListingListener = listener
        return publisher
    }
    
    
    
    func addListenerForAllUserFavoriteProducts(userId: String) ->  AnyPublisher<[UserFavoriteProduct], Error> {
        let (publisher, listener) = userFavoriteProductCollection(userId: userId)
            .addSnapshotListener(as: UserFavoriteProduct.self)
        
        self.userFavoriteProductsListener = listener
        return publisher
    }
}

struct UserWatchlistListing: Codable {
    let id: String
    let listingId: String
    let dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case listingId = "listing_id"
        case dateCreated = "date_created"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.listingId = try container.decode(String.self, forKey: .listingId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.listingId, forKey: .listingId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
    }
    
   
    
    
}

struct UserFavoriteProduct: Codable {
    let id: String
    let productId: Int
    let dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case productId = "product_id"
        case dateCreated = "date_created"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.productId = try container.decode(Int.self, forKey: .productId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.productId, forKey: .productId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
    }
    
   
    
    
}
