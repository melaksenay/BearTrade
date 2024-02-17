//
//  Query+EXT.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/4/24.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

extension Query {
    //    func getDocuments <T> (as type: T.Type) async throws -> [T] where T : Decodable {
    //        let snapshot = try await self.getDocuments()
    //        return  try snapshot.documents.map({ document in
    //            try document.data(as: T.self)})
    //
    //
    //    }
    
    func getDocuments <T> (as type: T.Type) async throws -> [T] where T : Decodable {
        try await getDocumentsWithSnapshot(as: type).products
        
        
    }
    
    func getDocumentsWithSnapshot <T> (as type: T.Type) async throws -> (products: [T], lastDocument: DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()
        let products =  try snapshot.documents.map({ document in
            try document.data(as: T.self)})
        return (products, snapshot.documents.last)
        
        
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else { return self }
        return self.start(afterDocument: lastDocument)
    }
    
    func addSnapshotListener<T>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration) where T : Decodable {
        
        let publisher = PassthroughSubject<[T], Error> ()
        
        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("no ducments")
                return
            }
            let products: [T] = documents.compactMap ({ try? $0.data(as: T.self)})
            publisher.send(products)
            
        }
        
        return (publisher.eraseToAnyPublisher() , listener)
    }
}

    


