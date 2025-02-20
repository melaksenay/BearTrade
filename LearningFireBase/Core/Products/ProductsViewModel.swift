//
//  ProductsViewModel.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/4/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore
@MainActor
final class ProductsViewModel: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    @Published var selectedFilter: FilterOption? = nil
    @Published var selectedCategory: CategoryOption? = nil
    private var lastDocument: DocumentSnapshot? = nil
    
    enum FilterOption: String, CaseIterable {
        case noFilter
        case priceHigh
        case priceLow
        
        var priceDescending: Bool? {
            switch self {
            case .noFilter : return nil
            case .priceHigh: return true
            case .priceLow: return false
            }
        }
    }
    
    func filterSelected(option: FilterOption) async throws {
        self.selectedFilter = option
        self.products = []
        self.lastDocument = nil
        self.getProducts()
    }
    
    enum CategoryOption: String, CaseIterable {
        case noCategory
        case smartphones
        case laptops
        case fragrances
        
        var categoryKey: String? {
            if self == .noCategory {
                return nil
            }
            return self.rawValue
        }
    }
    
    func categorySelected(option: CategoryOption) async throws {
        self.selectedCategory = option
        self.products = []
        self.lastDocument = nil
        self.getProducts()

    }
    
    func getProducts() {
    
        Task{
            do{
                let(newProducts, lastDocument) = try await ProductsManager.shared.getAllProducts(priceDescending: selectedFilter?.priceDescending, forCategory: selectedCategory?.categoryKey, count: 10, lastDocument: lastDocument)
                self.products.append(contentsOf: newProducts)
                if let lastDocument{
                    self.lastDocument = lastDocument
                    
                }
                print("Products fetched successfully: \(newProducts.count) listings")
        
            } catch{
                print("error fetching products: \(error)")
            }
            
        }
    }
    
    func addUserFavoriteProduct(productId: Int) {
        Task{
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
           try? await  UserManager.shared.addUserFavoriteProduct(userId: authDataResult.uid, productId: productId)
        }
    }
    
//    func getProductsCount() {
//        Task {
//            let count = try await ProductsManager.shared.getallProductsCount()
//            print("ALL PRODUCT COUNT: \(count)")
//        }
//    }
    
//    func getProductsByRating() {
//        Task{
//            let(newProducts, lastDocument) = try await ProductsManager.shared.getProductByRating(count: 3, lastDocument: lastDocument)
//            self.products.append(contentsOf: newProducts)
//            self.lastDocument = lastDocument
//        }
//    }

    
}
