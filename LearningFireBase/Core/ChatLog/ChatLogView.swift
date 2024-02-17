//
//  ChatLogView.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/17/24.
//
import SwiftUI
import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogView(chatUser: .init(data: ["uid": "R8ZrxIT4uRZMVZeWwWeQWPI5zUE3", "email": "waterfall1@gmail.com"]))
        }
        MainMessagesView()
    }
}


@MainActor
final class ChatLogViewModel: ObservableObject {
    @Published var count = 0
    @Published var chatText = ""
    @Published var errorMessage = ""
    @Published private (set) var chatMessages: [ChatMessage] = []
    var chatUser: ChatUser?
    private var cancellables = Set<AnyCancellable> ()
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        Task{
            await fetchMessages()
        }
    }
    
    private func fetchMessages() async  {
        guard let fromId = try? AuthenticationManager.shared.getAuthenticatedUser().uid else { return }
        guard let toId = chatUser?.uid else { return }
        Firestore.firestore()
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                    }
                })
                
                DispatchQueue.main.async {
                    self.count += 1
                }
            }
    }

    func handleSend() async throws {
        print(chatText)
        
        try await MessagesManager.shared.handleSend(receiver: chatUser ?? ChatUser(data: ["uid" : ""]) , chatText: chatText)
        
        self.count += 1
        self.chatText = ""
    }
    
    private func persistRecentMessage() async throws {
        guard let chatUser = chatUser else { return }
        
        guard let uid = try? AuthenticationManager.shared.getAuthenticatedUser().uid else {return}
        guard let toId = self.chatUser?.uid else { return }
        
        
        let document = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .document(toId)
        
        let data = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: chatUser.profileImageUrl,
            FirebaseConstants.email: chatUser.email
        ] as [String : Any]
        
        // you'll need to save another very similar dictionary for the recipient of this message...how?
        
        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                print("Failed to save recent message: \(error)")
                return
            }
        }
        
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        let recipientRecentMessageDictionary = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: currentUser.profileImageUrl,
            FirebaseConstants.email: currentUser.email
        ] as [String : Any]
        
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(toId)
            .collection(FirebaseConstants.messages)
            .document(currentUser.uid)
            .setData(recipientRecentMessageDictionary) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
    }
    //@Published var count = 0
    
 }


struct ChatLogView: View {
    
    let chatUser: ChatUser?
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        self.viewModel = .init(chatUser: chatUser)
    }
    
    @ObservedObject var viewModel: ChatLogViewModel
    
    var body: some View {
        ZStack {
            messagesView

            VStack(spacing: 0) {
                Spacer()
                chatBottomBar
                    .background(Color.white.ignoresSafeArea())
            }
        }
        .navigationTitle(chatUser?.email ?? "")
            .navigationBarTitleDisplayMode(.inline)
    }
    
//    private var messagesView: some View {
//        VStack {
////            if #available(iOS 17.0, *) {
//                ScrollView {
//                    ForEach(viewModel.chatMessages) { message in
//                        MessageView(message: message)
//                        
//                    }
//                    
//                    HStack{ Spacer() }
//                }
//                .background(Color(.init(white: 0.95, alpha: 1)))
//                .safeAreaInset(edge: .bottom) {
//                    chatBottomBar
//                        .background(Color(.systemBackground).ignoresSafeArea())
//                }
////            } else {
////                // Fallback on earlier versions
////            }
//        }
//    }
    static let emptyScrollToString = "Empty"
    
    private var messagesView: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack {
                        ForEach(viewModel.chatMessages) { message in
                            MessageView(message: message)
                        }
                        
                        HStack{ Spacer() }
                        .id(Self.emptyScrollToString)
                    }
                    .onReceive(viewModel.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color(.init(white: 0.95, alpha: 1)))
            .safeAreaInset(edge: .bottom) {
                chatBottomBar
                    .background(Color(.systemBackground).ignoresSafeArea())
            }
        }
    }
    
    struct MessageView: View {
        let message: ChatMessage
        var body: some View {
            VStack {
                let id = try? AuthenticationManager.shared.getAuthenticatedUser().uid
                if message.fromId == id {
                    HStack {
                        Spacer()
                        HStack {
                            Text(message.text)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                } else {
                    HStack {
                        HStack {
                            Text(message.text)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $viewModel.chatText)
                    .opacity(viewModel.chatText.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)
            
            Button {
                Task {
                    try await viewModel.handleSend()
                }
                
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Description")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}
