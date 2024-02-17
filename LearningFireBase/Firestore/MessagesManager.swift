//
//  ChatUserStruct.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/17/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

struct ChatUser: Codable, Identifiable {
    
    var id: String { uid }
    
    let uid, email, profileImageUrl: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
    
}

struct RecentMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let text, email: String
    let fromId, toId: String
    let profileImageUrl: String
    let timestamp: Date
    
    var username: String {
        email.components(separatedBy: "@").first ?? email
    }
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}

struct FirebaseConstants {
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    //new declarations Sat Feb 3, 2024
    static let timestamp = "timestamp"
    static let email = "email"
    static let uid = "uid"
    static let profileImageUrl = "profileImageUrl"
    static let messages = "messages"
    static let users = "users"
    static let recentMessages = "recent_messages"
    
}

//struct ChatMessage: Identifiable, Codable {
//    var id : String { documentId }
//    
//    let documentId: String
//    let fromId, toId, text: String
//    
//    init(documentId: String, data: [String : Any]) {
//        self.documentId = documentId
//        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
//        self.toId = data[FirebaseConstants.toId] as? String ?? ""
//        self.text = data[FirebaseConstants.text] as? String ?? ""
//    }
//    
//}

struct ChatMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let fromId, toId, text: String
    let timestamp: Date
    
    // Computed property to convert a ChatMessage instance to [String: Any]
    var dictionary: [String: Any] {
        return [
            "fromId": fromId,
            "toId": toId,
            "text": text,
            "timestamp": timestamp
        ]
    }
}

final class MessagesManager {
    static let shared = MessagesManager()
    private init() {}
    
    private let messagesCollection: CollectionReference = Firestore.firestore().collection("messages")
    
//    private func userDocument(userId: String)-> DocumentReference{
//        messagesCollection.document(userId)
//    }
    
//    Create new collection under each id.
    private func userRecentMessagesCollection(userId: String) -> CollectionReference {
        userMessageDocument(userId: userId).collection("recentMessages")
    }
    
    private func userMessageDocument(userId: String)-> DocumentReference{
        messagesCollection.document(userId)
    }
    
    private func userMessageCollectionAtUserId(userId: String) -> CollectionReference {
        userMessageDocument(userId: userId).collection("\(userId)")
    }
    
    
    func getAllMessageUsersfromCurrentUser(userId: String) async throws -> [ChatUser] {
        try await userMessageCollectionAtUserId(userId: userId).getDocuments(as: ChatUser.self)
    }
    
    private var messagesListener: ListenerRegistration? = nil
    
    
   
    
  
    
    func addListenerForMessages(chatUser: ChatUser) async throws -> AnyPublisher<[ChatMessage], Error> {
        let fromId = try AuthenticationManager.shared.getAuthenticatedUser().uid
        print("From Id", fromId)
        let toId = chatUser.uid
        print("To Id", toId)
        
        let (publisher, listener) = messagesCollection
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener(as: ChatMessage.self)
        self.messagesListener = listener
        print("yo this is the pUBLISHER: ",publisher)
        return publisher
        
        
    }
    
    func messagesPublisher(for chatUser: ChatUser) -> AnyPublisher<[ChatMessage], Error> {
        let fromId = (try? AuthenticationManager.shared.getAuthenticatedUser().uid) ?? ""
            let toId = chatUser.uid
            
            return Future<[ChatMessage], Error> { promise in
                self.messagesListener = self.messagesCollection
                    .document(fromId)
                    .collection(toId)
                    .order(by: "timestamp")
                    .addSnapshotListener { querySnapshot, error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            let messages = querySnapshot?.documents.compactMap { document -> ChatMessage? in
                                let data = document.data()
                                return ChatMessage(documentId: document.documentID, data: data)
                            } ?? []
                            promise(.success(messages))
                        }
                    }
            }
            .eraseToAnyPublisher()
        }


    
    //    private func messageDocument(userId: String)-> DocumentReference{
    //        messagesCollection.document(userId)
    //    }
    
    
    
    func handleSend(receiver : ChatUser, chatText: String) async throws {
        //        print(chatText)
        
        let fromId = try AuthenticationManager.shared.getAuthenticatedUser().uid
        
        let toId = receiver.uid
        let document = userRecentMessagesCollection(userId: fromId).document(toId)/* messagesCollection.document(fromId).collection(toId).document()*/
        
//        let messageData: [String : Any] = [FirebaseConstants.fromId: fromId, FirebaseConstants.toId: toId, FirebaseConstants.text: chatText, "timestamp": Timestamp()]
        let messageData = ChatMessage(id: nil, fromId: fromId, toId: toId, text: chatText, timestamp: Date())
        print("MESSAGE DATA: ", messageData)
        
//        let messageData = ["fromId": fromId, "toId": toId, "text": chatText, "timestamp": Timestamp()] as [String : Any]
        let messageDict = messageData.dictionary
        
        try await document.setData(messageDict)
        
        let recipientMessageDocument = userRecentMessagesCollection(userId: toId).document(fromId)
//        messagesCollection
//            .document(toId)
//            .collection(fromId)
//            .document()
        
        try await recipientMessageDocument.setData(messageDict)
        
    }
    
}
