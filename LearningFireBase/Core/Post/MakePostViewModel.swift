//
//  ListingViewModel.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/6/24.
//

import Foundation

final class MakePostViewModel: ObservableObject {
    @Published var newItem: /*MakeNewPost*/ Listing = .empty
    
    //    func isValidNumericFormatWithOneDecimalPoint(_ value: String) -> Bool {
    //            let decimalCount = value.components(separatedBy: ".").count - 1
    //            return decimalCount <= 1
    //        }
    
    func postItem(listing: Listing) {
//        print("Item saved: \(newItem)")
//        //        print("Date: \(newItem.item.date.formatted(date: .abbreviated, time: .shortened))")
//        print("Date: \(String(describing: newItem.date?.formatted(date: .abbreviated, time: .shortened)))")
        Task{
            do {
                try await ListingsManager.shared.uploadListing(listing: listing)
                print("Listing success")
            } catch {
                print("Error uploading listing: \(error)")
            }
            
        }
    }
    
    
    func cancelItem() {
        print("Action canceled")
    }
    
    func clearAllFields() {
        newItem = .empty
    }
    
    
    
    
    
}
