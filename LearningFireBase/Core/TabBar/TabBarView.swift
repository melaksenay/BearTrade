//
//  TabBarView.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/4/24.
//

import SwiftUI

struct TabBarView: View {
    
    @Binding var showSignInView: Bool
    var body: some View {
        TabView {
//            NavigationStack{
//                ProductsView()
//            }
//            .tabItem {
//                Image(systemName: "cart")
//                Text("Products")
//            }
            
            NavigationStack {
                ListingsView()
            }
            .tabItem {
                Image(systemName: "cart.fill")
                Text("Listings")
            }
            
            NavigationStack{
                WatchlistView()
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text("Watchlist")
            }
            
            NavigationStack{
                MainMessagesView()
            }
            .tabItem {
                Image(systemName: "message.fill")
                Text("Messages")
            }
            
            
            NavigationStack{
                MakePostView()
            }
            .tabItem {
                Image(systemName: "plus.app" )
                Text("Add Item")
            }
            
            NavigationStack{
                ProfileView(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
        }
    }
}

#Preview {
    TabBarView(showSignInView: .constant(false))
}
