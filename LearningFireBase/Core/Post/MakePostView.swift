//
//  MakePostView.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/6/24.
//

import SwiftUI
import UIKit

struct MakePostView: View {
    @StateObject private var viewModel = MakePostViewModel()
    
    var body: some View {
        NavigationView{
            Form {
                item
                clearAll
                
            }
            .navigationTitle("Add Listing")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button ("Post") {
                        viewModel.postItem(listing: viewModel.newItem)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button ("Cancel",
                            role: .cancel) {
                        viewModel.cancelItem()
                    }
                }
            }
        }
    }
}

#Preview {
    MakePostView()
}

private extension MakePostView {
    
    var item : some View {
        Section {
            TextField("Name of Item", text: $viewModel.newItem.listingName)
                .onChange(of: viewModel.newItem.listingName) { newValue, _ in
                    if (newValue.count > 50) {
                        viewModel.newItem.listingName = String(newValue.prefix(50))
                    }
                }
            
            //            TextField("Name of Item", text: $viewModel.newItem.item.itemName)

            
//            TextField("$ Price (Optional)", text: $viewModel.newItem.price?)
//                .keyboardType(.decimalPad)
            
            //            Picker("Open to bargain (Yes/No)", selection: $viewModel.newItem.item.isBargain) {
            //                ForEach(MakeNewPost.Item.Bargain.allCases) { item in
            //                    Text(item.rawValue.uppercased())
            //                }
            //            }
//            DatePicker("Date of event", selection: $viewModel.newItem.date?)
//            
//            TextField("Description: ", text: $viewModel.newItem.description?)
        }
    }
    
    
    var clearAll: some View {
        Button("Clear All", role: .destructive) {
            viewModel.clearAllFields()
        }
    }
}
